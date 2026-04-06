import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:study_sphere/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(const StudySphereApp());
  

}

class StudySphereApp extends StatelessWidget {
  const StudySphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}