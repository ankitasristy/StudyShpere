import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WrongAnswerPage extends StatefulWidget {
  const WrongAnswerPage({Key? key}) : super(key: key);

  @override
  State<WrongAnswerPage> createState() => _WrongAnswerPageState();
}

class _WrongAnswerPageState extends State<WrongAnswerPage> {
  final Color secondaryColor = const Color(0xFF5A8A3D);

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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: wrongAnswerListUI(),
    );
  }

  Widget wrongAnswerListUI() {
    return StreamBuilder<QuerySnapshot>(
      // This looks at the collection we just saved to
      stream: FirebaseFirestore.instance
          .collection('wrong_answers')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            return wrongAnswerCard(data, docs[index].id);
          },
        );
      },
    );
  }

  Widget wrongAnswerCard(Map<String, dynamic> data, String docId) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: Text(data['question'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("Your Answer: ${data['userAnswer']}",
                style: const TextStyle(color: Colors.red)),
            Text("Correct: ${data['correctAnswer']}",
                style: const TextStyle(color: Colors.green)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.grey),
          onPressed: () =>
              FirebaseFirestore.instance
                  .collection('wrong_answers')
                  .doc(docId)
                  .delete(),
        ),
      ),
    );
  }
}