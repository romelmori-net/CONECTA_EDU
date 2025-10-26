
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // On success, the StreamBuilder in main.dart will handle navigation.
      // We DO NOT set _isLoading back to false here, to prevent UI flicker.
    } on FirebaseAuthException catch (err) {
      // Only reset loading state on error
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar(err.message ?? 'Ocurrió un error. Por favor, revisa tus credenciales.');
      }
    }
  }

  Future<void> _googleSignInHandler() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (mounted) setState(() => _isGoogleLoading = false); // User cancelled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'fullName': user.displayName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': Timestamp.now(),
            'hasCompletedOnboarding': false,
          });
        }
      }
       // On success, StreamBuilder will navigate. We don't reset the loading state.
    } catch (error) {
      if (mounted) {
        // Only reset loading state on error
        setState(() => _isGoogleLoading = false);
        _showErrorSnackBar('Error al iniciar sesión con Google. Inténtalo de nuevo.');
      }
    }
  }

  void _resetPassword() {
    if (_emailController.text.trim().isEmpty) {
        _showErrorSnackBar('Ingresa tu correo para recuperar la contraseña.');
        return;
    }
    try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se ha enviado un enlace de recuperación a tu correo.'), backgroundColor: Colors.green),
        );
    } catch (e) {
        _showErrorSnackBar('No se pudo enviar el correo. Verifica la dirección.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light grey background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // --- HEADER ---
                Image.asset('assets/images/Logo.png', height: 60),
                const SizedBox(height: 16),
                Text(
                  'Bienvenido a ConectaEDU',
                  style: GoogleFonts.poppins(
                    textStyle: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A2540),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesión para continuar',
                  style: GoogleFonts.poppins(textStyle: textTheme.titleMedium?.copyWith(color: Colors.black54)),
                ),
                const SizedBox(height: 40),

                // --- FORM ---
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _emailController,
                        hintText: 'Correo Institucional',
                        prefixIcon: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@')) ? 'Ingresa un correo válido' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(
                        controller: _passwordController,
                        hintText: 'Contraseña',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_passwordVisible,
                        validator: (v) => (v == null || v.length < 7) ? 'La contraseña es muy corta' : null,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _resetPassword,
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                             style: GoogleFonts.poppins(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- SUBMIT BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading || _isGoogleLoading ? null : _trySubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D6EFD),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: _isLoading
                              ? const Text('Ingresando...')
                              : Text(
                                  'Ingresar',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Text('O', style: TextStyle(color: Colors.black54))),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 24),

                // --- SOCIAL LOGINS ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: SvgPicture.asset('assets/svgs/google_logo.svg', height: 22.0),
                    onPressed: _isLoading || _isGoogleLoading ? null : _googleSignInHandler,
                    style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white,
                       foregroundColor: Colors.black87,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                         side: BorderSide(color: Colors.grey.shade300),
                       ),
                       padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    label: _isGoogleLoading
                      ? const Text('Conectando...')
                      : Text('Continuar con Google', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 32),

                // --- REGISTER REDIRECT ---
                Text.rich(
                  TextSpan(
                    text: '¿Aún no tienes una cuenta? ',
                    style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.black54)),
                    children: [
                      TextSpan(
                        text: 'Regístrate ahora',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          if (!(_isLoading || _isGoogleLoading)) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()));
                          }
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required FormFieldValidator<String> validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextFormField(
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
      );
  }
}
