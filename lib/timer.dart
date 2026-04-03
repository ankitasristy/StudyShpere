import 'dart:async';
import 'package:flutter/material.dart';
import 'reminder.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _s = 10;
  Timer? _t;
  Timer? _reminderTimer; // New timer specifically for the repeat reminders

  void _toggle() {
    if (_t?.isActive ?? false) {
      _t?.cancel();
      // Start the repeating 10-second reminder immediately after stopping
      _startRepeatingReminder();
    } else {
      _reminderTimer?.cancel(); // Stop reminders if we start the timer again
      _s = 10;
      _t = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        setState(() => _s > 0 ? _s-- : _toggle());
      });
    }
    setState(() {});
  }

  void _startRepeatingReminder() {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(const Duration(seconds: 10), (t) {
      if (mounted) StudyReminder.show(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("$_s s", style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Color(0xFF5A8A3D))),
        ElevatedButton(
          onPressed: _toggle,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A8A3D)),
          child: Text(_t?.isActive == true ? "STOP" : "START", style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() { _t?.cancel(); _reminderTimer?.cancel(); super.dispose(); }
}