import 'dart:async';
import 'package:flutter/material.dart';

class StudyReminder {
  static void scheduleRevisionReminder(BuildContext context) {
    final navigator = Navigator.of(context);
    Timer(const Duration(seconds: 10), () {
      debugPrint("10 seconds are up! Showing the dialog...");
      showDialog(
        context: navigator.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text(' Reminder'),
            content: const Text(
              'Time for you to revise the previous topic!!',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF6B8E4E), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}