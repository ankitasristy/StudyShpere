import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // CRITICAL IMPORT
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  String _email = '', _password = '';
  final _formKey = GlobalKey<FormState>();

  // This function now handles the Firebase connection
  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();

    // 1. Setup a "Listener" to catch the login success immediately
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        // If Firebase says a user exists, jump to Home Screen!
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });

    // 2. Trigger the actual login attempt
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      ).catchError((error) {
        // Show error if password/email is actually wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      print("Error during login call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Added to prevent keyboard overflow
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/logo.png', height: 90)),
                const SizedBox(height: 16),
                const Text('Log In',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)
                ),
                const SizedBox(height: 4),
                const Text('Welcome back! Enter your details.',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 28),
                const Text('Email',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)
                ),
                const SizedBox(height: 6),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('Enter your email'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                    return null;
                  },
                  onSaved: (v) => _email = v ?? '',
                ),
                const SizedBox(height: 16),
                const Text('Password',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)
                ),
                const SizedBox(height: 6),
                TextFormField(
                  obscureText: !_showPassword,
                  decoration: _inputDecoration('Enter your password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey, size: 20,
                      ),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                  onSaved: (v) => _password = v ?? '',
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A8A3D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Log In',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCCCCCC))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF5A8A3D), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red, width: 2)),
      filled: true,
      fillColor: const Color(0xFFF9F9F9),
    );
  }
}