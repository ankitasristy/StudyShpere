import 'package:flutter/material.dart';

class WrongAnswerPage extends StatefulWidget {
  const WrongAnswerPage({Key? key}) : super(key: key);

  @override
  State<WrongAnswerPage> createState() => _WrongAnswerPageState();
}

class _WrongAnswerPageState extends State<WrongAnswerPage> {
  final Color secondaryColor = const Color(0xFF6B8E4E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Wrong Answers",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
      ),
      body: wrongAnswerListUI(),
    );
  }

  Widget wrongAnswerListUI() {
    // Placeholder: show 3 empty cards to demo UI
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3, // just for UI demonstration
      itemBuilder: (context, index) {
        return wrongAnswerCard();
      },
    );
  }

  Widget wrongAnswerCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question placeholder
            const Text(
              "Question will come from Firebase",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),

            // Wrong Answer placeholder
            const Text(
              "Your Answer: (User's wrong answer)",
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 4),

            // Correct Answer placeholder
            const Text(
              "Correct Answer: (Correct answer from Firebase)",
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
            const SizedBox(height: 10),

            // Delete button placeholder
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  // Firebase delete functionality will be implemented later
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}