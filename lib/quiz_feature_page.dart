import 'package:flutter/material.dart';

class QuizFeaturePage extends StatefulWidget {
  const QuizFeaturePage({Key? key}) : super(key: key);

  @override
  State<QuizFeaturePage> createState() => _QuizFeaturePageState();
}

class _QuizFeaturePageState extends State<QuizFeaturePage> {
  final Color secondaryColor = const Color(0xFF5A8A3D);

  int currentStep = 0; // 0=Subject, 1=Question, 2=Result
  String selectedSubject = "";
  int questionIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz",style: TextStyle(color: Colors.white,
        fontSize: 20,fontWeight: FontWeight.bold,),
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
    if (currentStep == 1) return questionUI();
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
            questionIndex = 1;
          });
        },
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  // ---------------- QUESTION ----------------
  Widget questionUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Subject: $selectedSubject"),
        const SizedBox(height: 10),
        Text("Question $questionIndex / 5"),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text("Question will come from Firebase"),
        ),
        const SizedBox(height: 20),
        optionButton(),
        optionButton(),
        optionButton(),
        optionButton(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // PREV BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: questionIndex > 1
                  ? () {
                setState(() {
                  questionIndex--;
                });
              }
                  : null, // disabled on first question
              child: const Text("Prev", style: TextStyle(color: Colors.white)),
            ),

            // NEXT BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              onPressed: () {
                if (questionIndex < 5) {
                  setState(() {
                    questionIndex++;
                  });
                } else {
                  setState(() {
                    currentStep = 2; // show result
                  });
                }
              },
              child: const Text("Next", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Widget optionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      child: OutlinedButton(
        onPressed: () {},
        child: const Text("Option"),
      ),
    );
  }

  // ---------------- RESULT ----------------
  Widget resultUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Result",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Text("Score will appear here"),
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
              questionIndex = 1;
            });
          },
          child: const Text("Restart", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}