import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'timer.dart';

class FlashcardScreen extends StatefulWidget {
  final bool useTimer;
  const FlashcardScreen({super.key, this.useTimer = false});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _isStudy = false;
  int _index = 0;
  final Color g = const Color(0xFF5A8A3D);

  // This points exactly to YOUR folder in the cloud
  CollectionReference get _userCards => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('flashcards');

  @override
  void initState() {
    super.initState();
    if (widget.useTimer) _isStudy = true;
  }

  Future<void> _addCard() async {
    if (_ctrl.text.trim().isNotEmpty) {
      await _userCards.add({
        'text': _ctrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      _ctrl.clear();
    }
  }

  Future<void> _deleteCard(String docId) async {
    await _userCards.doc(docId).delete();
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
            if (widget.useTimer && _isStudy) ...[
              const PomodoroTimer(),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _userCards.orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return const Center(child: Text("Connection Error"));
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                  return _isStudy ? _studyView(docs) : _inputView(docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputView(List<QueryDocumentSnapshot> docs) {
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          decoration: InputDecoration(
            labelText: "Enter Card Text",
            labelStyle: TextStyle(color: g),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: g),
          onPressed: _addCard,
          child: const Text("Add Card", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['text'] ?? '', style: TextStyle(color: g)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCard(docs[index].id),
                ),
              );
            },
          ),
        ),
        if (docs.isNotEmpty)
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: g),
            onPressed: () => setState(() => _isStudy = true),
            child: const Text("Start Studying", style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }

  Widget _studyView(List<QueryDocumentSnapshot> docs) {
    if (docs.isEmpty) {
      return Center(
        child: TextButton(
          onPressed: () => setState(() => _isStudy = false),
          child: const Text("No cards! Click to add some."),
        ),
      );
    }

    if (_index >= docs.length) _index = 0;
    final currentCard = docs[_index].data() as Map<String, dynamic>;

    return Column(
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
            currentCard['text'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: g, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: g),
              onPressed: _index > 0 ? () => setState(() => _index--) : null,
              child: const Text("Prev", style: TextStyle(color: Colors.white)),
            ),
            Text("${_index + 1} / ${docs.length}"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: g),
              onPressed: _index < docs.length - 1 ? () => setState(() => _index++) : null,
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
    );
  }
}