import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final Color secondaryColor = const Color(0xFF6B8E4E); // secondary color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // primary color
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.white, // AppBar title font color
          ),
        ),
        backgroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: secondaryColor,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              // User Name
              const Text(
                "Hello, User!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // keep font color black
                ),
              ),
              const SizedBox(height: 50),
              // Log Out Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor, // matches app
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Add log out functionality here
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.white, // font color white
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}