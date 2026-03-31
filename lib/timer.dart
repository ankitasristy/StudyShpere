import 'dart:async';
import 'package:flutter/material.dart';
import 'reminder.dart';

class PomodoroTimer extends StatefulWidget {
  final VoidCallback onStop;
  const PomodoroTimer({super.key, required this.onStop});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int _secondsRemaining = 10;
  bool _isBreak = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _isBreak = !_isBreak;
            _secondsRemaining = _isBreak ? 5 : 10;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _isBreak ? const Color(0xFFFFD1DC) : Colors.lightBlue;
    final Color textColor = _isBreak ? Colors.redAccent : Colors.white;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Text(
                _isBreak ? 'BREAK' : 'STUDY',
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontStyle: _isBreak ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              Text(
                '$_secondsRemaining s',
                style: TextStyle(fontSize: 28, color: textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // THIS IS THE BUTTON YOU CLICK
        TextButton(
          onPressed: () {
            // 1. Hide the timer widget immediately
            widget.onStop();
            // 2. Start the 10-second countdown for the reminder alert
            StudyReminder.scheduleRevisionReminder(context);
          },
          child: const Text('STOP TIMER', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}