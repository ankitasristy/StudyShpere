import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizFeaturePage extends StatefulWidget {
  const QuizFeaturePage({Key? key}) : super(key: key);

  @override
  State<QuizFeaturePage> createState() => _QuizFeaturePageState();
}

class _QuizFeaturePageState extends State<QuizFeaturePage> {
  final Color secondaryColor = const Color(0xFF5A8A3D);

  int currentStep = 0; // 0=Subject, 1=Question, 2=Result
  String selectedSubject = "";
  int questionIndex = 0; // start from 0 for list indexing
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quiz",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: secondaryColor,
      ),
      body: Center(
        child: buildUI(),
      ),
    );
  }

  Widget buildUI() {
    if (currentStep == 0) return subjectUI();
    if (currentStep == 1) return firebaseQuestionLoader();
    return resultUI();
  }

  // ---------------- SUBJECT SELECTION ----------------
  Widget subjectUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        subjectButton("Java"),
        subjectButton("Flutter"),
      ],
    );
  }

  Widget subjectButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        ),
        onPressed: () {
          setState(() {
            selectedSubject = title;
            currentStep = 1;
            questionIndex = 0;
            score = 0;
          });
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  // ---------------- FIREBASE LOADER ----------------
  Widget firebaseQuestionLoader() {
    // If Flutter is selected, show placeholder
    if (selectedSubject == "Flutter") {
      return questionUIPlaceholder();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('questions')
          .where('subject', isEqualTo: selectedSubject)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text("Something went wrong");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return questionUIPlaceholder();

        // Safety check
        if (questionIndex >= docs.length) {
          return resultUI();
        }

        var data = docs[questionIndex].data() as Map<String, dynamic>;
        return questionUIFirebase(data, docs.length);
      },
    );
  }

  // ---------------- QUESTION UI FOR FIREBASE ----------------
  Widget questionUIFirebase(Map<String, dynamic> data, int totalQuestions) {
    List options = data['options'] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Subject: $selectedSubject",
              style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Question ${questionIndex + 1} / $totalQuestions"),
          const SizedBox(height: 20),
          Text(
            data['question'] ?? "No Question Text",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),

          // Dynamically create option buttons
          ...List.generate(options.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => checkAnswer(index, data['correctIndex'], totalQuestions),
                  child: Text(options[index]),
                ),
              ),
            );
          }),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
                onPressed: questionIndex > 0
                    ? () {
                  setState(() {
                    questionIndex--;
                  });
                }
                    : null,
                child: const Text("Prev", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- CHECK ANSWER ----------------
  void checkAnswer(int selected, dynamic correct, int totalQuestions) {
    if (selected == correct) {
      score++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Correct!"), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Wrong Answer!"), backgroundColor: Colors.red, duration: Duration(seconds: 1)),
      );
    }

    // Move to next question after short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        questionIndex++;
        if (questionIndex >= totalQuestions) {
          currentStep = 2; // Show result
        }
      });
    });
  }

  // ---------------- PLACEHOLDER FOR FLUTTER ----------------
  Widget questionUIPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Subject: $selectedSubject",
            style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const Text("Question 1 / 1"),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Question will come from Firebase"),
        ),
        const SizedBox(height: 20),
        optionButtonPlaceholder(),
        optionButtonPlaceholder(),
        optionButtonPlaceholder(),
        optionButtonPlaceholder(),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          onPressed: null,
          child: const Text("Next", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget optionButtonPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: OutlinedButton(
        onPressed: null,
        child: const Text("Option"),
      ),
    );
  }

  // ---------------- RESULT ----------------
  Widget resultUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Result", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text("Your Score: $score", style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          onPressed: () {
            setState(() {
              currentStep = 0;
              selectedSubject = "";
              questionIndex = 0;
              score = 0;
            });
          },
          child: const Text("Restart", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}