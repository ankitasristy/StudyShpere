import 'package:flutter/material.dart';
import 'timer.dart';

class FlashcardScreen extends StatefulWidget {
  final bool useTimer;
  const FlashcardScreen({super.key, this.useTimer = false});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // Static final ensures cards stay in memory even when you leave the page
  static final List<String> _cards = [];
  final TextEditingController _ctrl = TextEditingController();
  bool _isStudy = false;
  int _index = 0;
  final Color g = const Color(0xFF5A8A3D);

  @override
  void initState() {
    super.initState();
    // If opened via Pomodoro button, go straight to study mode
    if (widget.useTimer) _isStudy = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.useTimer ? "POMODORO" : "FLASHCARDS",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: g,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Timer only appears in Pomodoro mode
            if (widget.useTimer && _isStudy) ...[
              const PomodoroTimer(),
              const SizedBox(height: 20),
            ],
            Expanded(child: _isStudy ? _studyView() : _inputView()),
          ],
        ),
      ),
    );
  }

  Widget _inputView() {
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          decoration: InputDecoration(labelText: "Enter Card Text", labelStyle: TextStyle(color: g)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: g),
          onPressed: () => setState(() {
            if (_ctrl.text.isNotEmpty) _cards.add(_ctrl.text);
            _ctrl.clear();
          }),
          child: const Text("Add Card", style: TextStyle(color: Colors.white)),
        ),
        Expanded(
          child: ListView(
            children: _cards.map((c) => ListTile(
              title: Text(c, style: TextStyle(color: g)),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _cards.remove(c)),
              ),
            )).toList(),
          ),
        ),
        if (_cards.isNotEmpty)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: g),
            onPressed: () => setState(() => _isStudy = true),
            child: const Text("Start Studying", style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }

  Widget _studyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity, height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: g, width: 3),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Text(
              _cards.isEmpty ? "No cards added!" : _cards[_index],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, color: g, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          if (_cards.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: g),
                  onPressed: _index > 0 ? () => setState(() => _index--) : null,
                  child: const Text("Prev", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: g),
                  onPressed: _index < _cards.length - 1 ? () => setState(() => _index++) : null,
                  child: const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => setState(() => _isStudy = false),
            child: Text("Back to Editor", style: TextStyle(color: g)),
          ),
        ],
      ),
    );
  }
}