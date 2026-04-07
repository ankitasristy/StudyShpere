import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:study_sphere/splash_screen.dart';

void main() async {
  // 1. Essential: This tells Flutter to get ready before starting the engine
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Try to connect to Firebase, but give up after 8 seconds
    // so the screen doesn't stay black forever.
    await Firebase.initializeApp().timeout(const Duration(seconds: 8));
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    // 3. If there is a mistake in your JSON or Gradle, it will show here
    // in the "Debug Console" instead of freezing the app.
    debugPrint("FIREBASE ERROR: $e");
  }

  // 4. Start the app UI
  runApp(const StudySphereApp());
}

class StudySphereApp extends StatelessWidget {
  const StudySphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudySphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // This sends the user to your Splash Screen first
      home: const SplashScreen(),
    );
  }
}