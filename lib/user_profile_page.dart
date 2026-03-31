import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final Color green = const Color(0xFF6B8E4E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar + Name
            CircleAvatar(
              radius: 50,
              backgroundColor: green,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text("Hello, User!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Stats placeholder
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: const [
                    Text("Quizzes Attempted: /", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text("Wrong Answers: /", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text("Edit Profile"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text("View Progress"),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}