import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/onboarding/academic_onboarding_screen.dart';
import 'package:myapp/screens/dashboard/dashboard_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    developer.log('Firebase initialized successfully', name: 'main');
  } catch (e, s) {
    developer.log('Firebase initialization failed', name: 'main', error: e, stackTrace: s);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF0D6EFD);
    return MaterialApp(
      title: 'ConectaEDU',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const DashboardScreen(),
        '/onboarding': (context) => const AcademicOnboardingScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          developer.log('Auth state stream error', name: 'AuthWrapper', error: snapshot.error, stackTrace: snapshot.stackTrace);
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          developer.log('Auth state waiting for connection', name: 'AuthWrapper');
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          developer.log('User is logged in: ${snapshot.data!.uid}', name: 'AuthWrapper');
          return const OnboardingCheck();
        }

        developer.log('User is not logged in', name: 'AuthWrapper');
        return const LoginScreen();
      },
    );
  }
}

class OnboardingCheck extends StatelessWidget {
  const OnboardingCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      developer.log('OnboardingCheck called with null user, returning to login', name: 'OnboardingCheck');
      return const LoginScreen(); 
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          developer.log('Firestore document fetch error', name: 'OnboardingCheck', error: snapshot.error, stackTrace: snapshot.stackTrace);
          return Scaffold(body: Center(child: Text('Error al cargar datos: ${snapshot.error}')));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final hasCompletedOnboarding = userData['hasCompletedOnboarding'] ?? false;

          if (hasCompletedOnboarding) {
            developer.log('User has completed onboarding, navigating to dashboard', name: 'OnboardingCheck');
            return const DashboardScreen();
          } else {
            developer.log('User has NOT completed onboarding, navigating to onboarding screen', name: 'OnboardingCheck');
            return const AcademicOnboardingScreen();
          }
        } else {
          developer.log('User document does not exist, navigating to onboarding screen', name: 'OnboardingCheck');
          return const AcademicOnboardingScreen();
        }
      },
    );
  }
}
