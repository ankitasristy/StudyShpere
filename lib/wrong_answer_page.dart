import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WrongAnswerPage extends StatefulWidget {
  const WrongAnswerPage({super.key});

  @override
  State<WrongAnswerPage> createState() => _WrongAnswerPageState();
}

class _WrongAnswerPageState extends State<WrongAnswerPage> {
  final Color secondaryColor = const Color(0xFF5A8A3D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Review Mistakes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: wrongAnswerListUI(),
    );
  }

  Widget wrongAnswerListUI() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('wrong_answers')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: secondaryColor.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text("No mistakes yet! Keep it up.",
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var data = docs[index].data() as Map<String, dynamic>;
              return wrongAnswerCard(data, docs[index].id);
            },
          ),
        );
      },
    );
  }

  Widget wrongAnswerCard(Map<String, dynamic> data, String docId) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "QUESTION",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => FirebaseFirestore.instance
                      .collection('wrong_answers')
                      .doc(docId)
                      .delete(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              data['question'] ?? "No Question Title",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const Divider(height: 24),
            _buildAnswerRow("Your Answer:", data['userAnswer'], Colors.red[700]!),
            const SizedBox(height: 8),
            _buildAnswerRow("Correct Answer:", data['correctAnswer'], secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerRow(String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ),
      ],
    );
  }
}