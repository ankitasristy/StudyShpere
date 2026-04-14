import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_sphere/splash_screen.dart';
import 'flashcard.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final Color secondaryColor = const Color(0xFF5A8A3D);
  final currentUser = FirebaseAuth.instance.currentUser;

  String _currentName = " ";
  String _currentMajor = "Computer Science";

  @override
  void initState() {
    super.initState();
    _currentName = currentUser?.displayName ?? currentUser?.email?.split('@')[0] ?? "User";
  }

  void _editName() {
    TextEditingController nameController = TextEditingController(text: _currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: nameController,
          cursorColor: secondaryColor,
          decoration: InputDecoration(
            hintText: "Enter your name",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondaryColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () async {
              setState(() => _currentName = nameController.text);
              await currentUser?.updateDisplayName(nameController.text);
              if (mounted) Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _editMajor() {
    TextEditingController majorController = TextEditingController(text: _currentMajor);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Major"),
        content: TextField(
          controller: majorController,
          cursorColor: secondaryColor,
          decoration: InputDecoration(
            hintText: "Enter your major",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondaryColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: secondaryColor)),
          ),
          TextButton(
            onPressed: () {
              setState(() => _currentMajor = majorController.text);
              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: secondaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: secondaryColor,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
<<<<<<< HEAD
              const SizedBox(height: 20),
              // User Name
              Text(
                currentUser!.email!,
                style: const TextStyle(
                  fontSize: 22,
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
                onPressed: () async {//attoja
                  try {
                    await FirebaseAuth.instance.signOut();
=======
            ),
            const SizedBox(height: 16),
            Text(
              _currentName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${currentUser?.email}",
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _editName,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Edit Name"),
              style: OutlinedButton.styleFrom(foregroundColor: secondaryColor),
            ),
            const SizedBox(height: 30),
            const Divider(),
>>>>>>> 2424a966852cf3f741a954d6d03c24de0962db1d

            _buildProfileOption(
              icon: Icons.school,
              title: "Major",
              subtitle: _currentMajor,
              showArrow: false,
              onTap: _editMajor,
            ),

            _buildProfileOption(
              icon: Icons.bookmark_outline,
              title: "Saved Resources",
              subtitle: "Flashcards and study materials",
              showArrow: true,
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlashcardScreen()),
                );
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A8A3D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _handleLogout(context),
                child: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool showArrow,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: secondaryColor,
            shape: BoxShape.circle
        ),
        child: Icon(icon, color: secondaryColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios, size: 14)
          : null,
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}