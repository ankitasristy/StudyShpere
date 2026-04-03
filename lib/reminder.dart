import 'package:flutter/material.dart';

class StudyReminder {
  static void show(BuildContext context) {
    // We use a SnackBar or a non-blocking Dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Time to revise!"),
        backgroundColor: Color(0xFF2D5A1E),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void scheduleRevisionReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Revision mode active!"), backgroundColor: Color(0xFF5A8A3D)),
    );
  }
}