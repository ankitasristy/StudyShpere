import 'timer.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
// Import the new timer file

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final TextEditingController _countController = TextEditingController();
  final PageController _pageController = PageController();

  List<TextEditingController> _inputControllers = [];
  List<String> _flashcards = [];

  bool _isInputMode = true;
  bool _showPomodoroChoice = false;
  bool _isTimerActive = false;
  int _currentPage = 0;

  final Color secondaryGreen = const Color(0xFF6B8E4E);

  void _generateInputFields() {
    int? count = int.tryParse(_countController.text);
    if (count != null && count > 0) {
      setState(() {
        _inputControllers = List.generate(count, (_) => TextEditingController());
      });
    }
  }

  void _askAboutPomodoro() {
    setState(() {
      _flashcards = _inputControllers
          .map((c) => c.text)
          .where((t) => t.trim().isNotEmpty)
          .toList();

      if (_flashcards.isNotEmpty) {
        _isInputMode = false;
        _showPomodoroChoice = true; // Show the YES/NO screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FLASHCARDS', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: secondaryGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isInputMode) return _buildInputForm();
    if (_showPomodoroChoice) return _buildPomodoroChoice();
    return _buildFlashcardView();
  }

  Widget _buildInputForm() {
    return Column(
      children: [
        TextField(
          controller: _countController,
          decoration: InputDecoration(
            labelText: 'Number of flashcards',
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: secondaryGreen, width: 2)),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (_) => _generateInputFields(),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _inputControllers.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _inputControllers[index],
                decoration: InputDecoration(labelText: 'Card ${index + 1}'),
              ),
            ),
          ),
        ),
        if (_inputControllers.isNotEmpty)
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _askAboutPomodoro,
              style: ElevatedButton.styleFrom(backgroundColor: secondaryGreen),
              child: const Text('Start Learning', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          )
      ],
    );
  }

  Widget _buildPomodoroChoice() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Enable Pomodoro Timer?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() { _isTimerActive = true; _showPomodoroChoice = false; }),
                style: ElevatedButton.styleFrom(backgroundColor: secondaryGreen),
                child: const Text("YES", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => setState(() { _isTimerActive = false; _showPomodoroChoice = false; }),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("NO", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFlashcardView() {
    return Column(
      children: [
        if (_isTimerActive) PomodoroTimer(onStop: () => setState(() => _isTimerActive = false)),
        const SizedBox(height: 10),
        Text('Card ${_currentPage + 1} of ${_flashcards.length}', style: TextStyle(color: secondaryGreen)),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad}),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _flashcards.length,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemBuilder: (context, index) => Center(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: secondaryGreen, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Text(_flashcards[index], style: TextStyle(fontSize: 28, color: secondaryGreen, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: _currentPage == 0 ? null : () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease), child: const Text("Prev")),
            ElevatedButton(onPressed: _currentPage == _flashcards.length - 1 ? null : () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease), child: const Text("Next")),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _countController.dispose();
    for (var c in _inputControllers) { c.dispose(); }
    super.dispose();
  }
}