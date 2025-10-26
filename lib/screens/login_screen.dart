import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _passwordVisible = false;
  String _userEmail = '';
  String _userPassword = '';

  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn.standard();
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userEmail,
          password: _userPassword,
        );
      } on FirebaseAuthException catch (err) {
        final message = err.message ?? 'Ocurrió un error. Por favor, revisa tus credenciales.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Theme.of(context).colorScheme.error),
          );
        }
         if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _googleSignInHandler() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDocSnapshot = await userDoc.get();

        if (!userDocSnapshot.exists) {
          await userDoc.set({
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': Timestamp.now(),
            'hasCompletedOnboarding': false,
          });
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al iniciar sesión con Google.')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/Logo.png', height: 80),
                const SizedBox(height: 16),
                const Text(
                  'BIENVENIDO',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión o crea una cuenta para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.54)),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        key: const ValueKey('email'),
                        validator: (value) => (value!.isEmpty || !value.contains('@')) ? 'Ingresa un correo válido' : null,
                        onSaved: (value) => _userEmail = value!,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('12345678@pronabec.edu.pe'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        key: const ValueKey('password'),
                        validator: (value) => (value!.isEmpty || value.length < 7) ? 'La contraseña debe tener al menos 7 caracteres' : null,
                        onSaved: (value) => _userPassword = value!,
                        obscureText: !_passwordVisible,
                        decoration: _inputDecoration('Contraseña', isPassword: true),
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
                            child: const Text('Ingresar'),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_userEmail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingresa tu correo para recuperar la contraseña.')));
                        return;
                      }
                      try {
                         FirebaseAuth.instance.sendPasswordResetEmail(email: _userEmail);
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Se ha enviado un enlace a tu correo.')));
                      } catch (e) {
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo enviar el correo. Verifica la dirección.')));
                      }
                    },
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 24),
                if (!_isLoading)
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset('assets/svgs/google_logo.svg', height: 24.0),
                          onPressed: _googleSignInHandler,
                          style: _buttonStyle(Colors.white, borderColor: Colors.grey.shade300),
                          label: const Text('Continuar con Google', style: TextStyle(color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset('assets/svgs/facebook.svg', height: 24.0), 
                          onPressed: () { /* TODO: Implementar login con Facebook */ },
                          style: _buttonStyle(const Color(0xFF1877F2)),
                          label: const Text('Continuar con Facebook'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    if (!_isLoading) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    }
                  },
                  child: Text.rich(
                    TextSpan(
                      text: '¿Aún no tienes una cuenta? ',
                      style: TextStyle(color: Colors.black.withOpacity(0.54)),
                      children: [
                        const TextSpan(
                          text: 'Regístrate ahora.',
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

  InputDecoration _inputDecoration(String label, {bool isPassword = false}) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: const Color(0xFFF0F2F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0D6EFD))),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey,),
              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
            )
          : null,
    );
  }

  ButtonStyle _buttonStyle(Color backgroundColor, {Color? borderColor}) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderColor != null ? BorderSide(color: borderColor) : BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('O')),
        Expanded(child: Divider()),
      ],
    );
  }
}
