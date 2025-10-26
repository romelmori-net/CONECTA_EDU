
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for TextFormFields for better state management
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _careerController = TextEditingController();
  final _interestsController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _userImageFile;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _careerController.dispose();
    _interestsController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress image
      maxWidth: 400,   // Resize image
    );
    if (pickedImage != null) {
      setState(() {
        _userImageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus(); // Close keyboard

    if (!isValid) {
      _showErrorSnackBar('Por favor, corrige los errores en el formulario.');
      return;
    }
    if (!_agreedToTerms) {
      _showErrorSnackBar('Debes aceptar los términos y condiciones.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      if (!email.endsWith('@pronabec.edu.pe')) {
        throw const FormatException('Solo se permiten correos con el dominio @pronabec.edu.pe.');
      }
      
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );
      
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Error inesperado: no se pudo obtener el usuario creado.');
      }

      // Conditionally upload image and get URL
      String? imageUrl;
      if (_userImageFile != null) {
        final ref = FirebaseStorage.instance.ref().child('user_images').child('${user.uid}.jpg');
        await ref.putFile(_userImageFile!);
        imageUrl = await ref.getDownloadURL();
      }

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': _nameController.text.trim(),
        'email': email,
        'phone': _phoneController.text.trim(),
        'career': _careerController.text.trim(),
        'interests': _interestsController.text.trim(),
        'photoUrl': imageUrl ?? '', // Save URL or empty string
        'createdAt': Timestamp.now(),
        'hasCompletedOnboarding': false,
      });

      if (mounted) {
        // On success, the StreamBuilder in main.dart will handle navigation.
        // We DO NOT set _isLoading back to false here, to prevent UI flicker.
      }

    } on FirebaseAuthException catch (err) {
      String message = 'Ocurrió un error de autenticación.';
      if (err.code == 'email-already-in-use') {
        message = 'Este correo electrónico ya está en uso.';
      } else if (err.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (err.message != null) {
        message = err.message!;
      }
      _showErrorSnackBar(message);
    } on FormatException catch (err) {
      _showErrorSnackBar(err.message);
    } catch (err) {
      _showErrorSnackBar('Ocurrió un error inesperado. Inténtalo de nuevo.');
    } finally {
      if (mounted) {
         // Only reset loading state on error
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // --- HEADER ---
                Image.asset('assets/images/Logo.png', height: 50),
                const SizedBox(height: 16),
                Text(
                  'Crea tu Cuenta en ConectaEDU',
                  style: GoogleFonts.poppins(
                    textStyle: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A2540),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Únete a la comunidad de becarios.',
                  style: GoogleFonts.poppins(textStyle: textTheme.titleMedium?.copyWith(color: Colors.black54)),
                ),
                const SizedBox(height: 32),

                // --- PROFILE IMAGE PICKER ---
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _userImageFile != null ? FileImage(_userImageFile!) : null,
                        child: _userImageFile == null
                            ? Icon(Icons.person, color: Colors.grey.shade600, size: 60)
                            : null,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)
                        ),
                        padding: const EdgeInsets.all(6.0),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- FORM ---
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        hintText: 'Nombre Completo',
                        prefixIcon: Icons.person_outline,
                        validator: (v) => (v == null || v.isEmpty || v.length < 4) ? 'Ingresa tu nombre completo' : null,
                      ),
                      _buildTextFormField(
                        controller: _emailController,
                        hintText: 'Correo Institucional',
                        prefixIcon: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@pronabec.edu.pe')) ? 'Debe ser un correo @pronabec.edu.pe' : null,
                      ),
                      _buildTextFormField(
                        controller: _phoneController,
                        hintText: 'Teléfono',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.length < 9) ? 'Ingresa un teléfono válido' : null,
                      ),
                      _buildTextFormField(
                        controller: _careerController,
                        hintText: 'Carrera',
                        prefixIcon: Icons.school_outlined,
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu carrera' : null,
                      ),
                       _buildTextFormField(
                        controller: _interestsController,
                        hintText: 'Intereses (ej. "deportes, lectura")',
                        prefixIcon: Icons.interests_outlined,
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingresa al menos un interés' : null,
                      ),
                      _buildTextFormField(
                        controller: _passwordController,
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_passwordVisible,
                        validator: (v) => (v == null || v.length < 7) ? 'Mínimo 7 caracteres' : null,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                      _buildTextFormField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirmar Contraseña',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_confirmPasswordVisible,
                        validator: (v) => (v != _passwordController.text) ? 'Las contraseñas no coinciden' : null,
                        suffixIcon: IconButton(
                          icon: Icon(_confirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- TERMS AND CONDITIONS ---
                      CheckboxListTile(
                        value: _agreedToTerms,
                        onChanged: (value) => setState(() => _agreedToTerms = value ?? false),
                        title: Text.rich(
                          TextSpan(
                            text: 'He leído y acepto los ',
                            style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: 'Términos y Condiciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  // Placeholder for showing terms
                                  print('Navigate to Terms & Conditions');
                                },
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 24),

                      // --- SUBMIT BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _trySubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D6EFD),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: _isLoading
                              ? const Text('Registrando...')
                              : Text(
                                  'Crear Mi Cuenta',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- LOGIN REDIRECT ---
                Text.rich(
                  TextSpan(
                    text: '¿Ya tienes una cuenta? ',
                    style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.black54)),
                    children: [
                      TextSpan(
                        text: 'Ingresa aquí',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          if (!_isLoading) Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable TextFormField Widget ---
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade400, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red.shade400, width: 2)),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
