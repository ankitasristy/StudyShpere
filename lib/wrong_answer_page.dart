import 'package:flutter/material.dart';

class WrongAnswerPage extends StatefulWidget {
  const WrongAnswerPage({super.key});

  @override
  State<WrongAnswerPage> createState() => _WrongAnswerPageState();
}

class _WrongAnswerPageState extends State<WrongAnswerPage> {
  final Color green = const Color(0xFF6B8E4E);

  // Sample UI placeholders (no data)
  List<int> placeholderQuestions = List.generate(5, (index) => index + 1); // just 5 placeholder items

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wrong Answers"),
        centerTitle: true,
        backgroundColor: green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: placeholderQuestions.isEmpty
            ? const Center(child: Text("No wrong answers yet", style: TextStyle(fontSize: 18)))
            : ListView.builder(
          itemCount: placeholderQuestions.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                title: const Text("Question will appear here"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 5),
                    Text("Option A"),
                    Text("Option B"),
                    Text("Option C"),
                    Text("Option D"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      placeholderQuestions.removeAt(index); // UI-only delete
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}