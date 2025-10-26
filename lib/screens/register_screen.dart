
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;
  bool _agreedToTerms = false;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      setState(() {
        _userImageFile = File(pickedImage.path);
      });
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!_agreedToTerms) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones.')),
      );
      return;
    }

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen de perfil.')),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        if (!_userEmail.endsWith('@pronabec.edu.pe')) {
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'Solo se permiten correos con el dominio @pronabec.edu.pe.',
          );
        }

        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(_userImageFile!);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'username': _userName,
          'email': _userEmail,
          'image_url': url,
          'createdAt': Timestamp.now(),
          'hasCompletedOnboarding': false,
        });

        // Después de un registro exitoso, el AuthWrapper se encargará de la navegación.

      } on FirebaseAuthException catch (err) {
        String message = 'Ocurrió un error.';
        if (err.message != null) {
          message = err.message!;
        }
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 const Icon(Icons.school, size: 60, color: Color(0xFF0D47A1)),
                const SizedBox(height: 16),
                const Text(
                  'Crear cuenta usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _userImageFile != null ? FileImage(_userImageFile!) : null,
                          child: _userImageFile == null
                              ? Icon(Icons.camera_alt, color: Colors.grey[800], size: 30)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('username'),
                        validator: (value) => (value!.isEmpty || value.length < 4) ? 'Ingresa al menos 4 caracteres' : null,
                        onSaved: (value) => _userName = value!,
                        decoration: _inputDecoration('Carlos Cueva Huamán'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) => (value!.isEmpty || !value.contains('@')) ? 'Ingresa un correo válido' : null,
                        onSaved: (value) => _userEmail = value!,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('12345678@pronabec.edu.pe'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                        child: Text(
                          'Usa tu correo institucional Pronabec, no se aceptan otros dominios',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('password'),
                         onChanged: (value) => _userPassword = value,
                        validator: (value) => (value!.isEmpty || value.length < 7) ? 'La contraseña debe tener al menos 7 caracteres' : null,
                        obscureText: true,
                        decoration: _inputDecoration('Contraseña'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('confirm_password'),
                        obscureText: true,
                        validator: (value) {
                          if (value != _userPassword) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                        decoration: _inputDecoration('Confirmar Contraseña'),
                      ),
                       const SizedBox(height: 16),
                      CheckboxListTile(
                        value: _agreedToTerms,
                        onChanged: (value) {
                          setState(() {
                             _agreedToTerms = value!;
                          });
                        },
                        title: const Text(
                            'Acepto términos y condiciones',
                             style: TextStyle(fontSize: 14),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: const Color(0xFF0D6EFD),
                        contentPadding: EdgeInsets.zero,
                        ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _trySubmit,
                            style: _buttonStyle(const Color(0xFF0D6EFD)),
                            child: const Text('Registrarme'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    if (!_isLoading) {
                      Navigator.of(context).pop(); // Regresa a la pantalla de Login
                    }
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: '¿Ya tienes una cuenta? Por favor ',
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: 'ingresa',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D6EFD)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
      ),
    );
  }

  ButtonStyle _buttonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
