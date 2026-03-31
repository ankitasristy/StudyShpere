import 'package:flutter/material.dart';
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

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }
234
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber//const Color(0xFF5A8A3D),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/logo.png', height: 90)),
              SizedBox(height: 16),
              Text('Log In',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)
              ),
              SizedBox(height: 4),
              Text('Welcome back! Enter your details.',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 28),
              Text('Email',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)
              ),
              SizedBox(height: 6),
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
              SizedBox(height: 16),
              Text('Password',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)
              ),
              SizedBox(height: 6),
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
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A8A3D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Log In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                  ),
                ),
              ),
            ],
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