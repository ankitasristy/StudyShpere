import 'package:flutter/material.dart';

class QuizFeaturePage extends StatefulWidget {
  const QuizFeaturePage({super.key});

  @override
  State<QuizFeaturePage> createState() => _QuizFeaturePageState();
}

class _QuizFeaturePageState extends State<QuizFeaturePage> {
  final Color green = const Color(0xFF6B8E4E);

  // Step control: 0=Subject,1=Count,2=Question,3=Result
  int currentStep = 0;

  String selectedSubject = "";
  int selectedCount = 5;
  int questionIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        centerTitle: true,
        backgroundColor: green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: buildStepUI(),
      ),
    );
  }

  Widget buildStepUI() {
    switch (currentStep) {
      case 0:
        return subjectSelectionUI();
      case 1:
        return questionCountUI();
      case 2:
        return questionUI();
      case 3:
        return resultUI();
      default:
        return Container();
    }
  }

  // SUBJECT SELECTION
  Widget subjectSelectionUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Subject", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        subjectCard("Java"),
        subjectCard("Flutter"),
        subjectCard("C Programming"),
      ],
    );
  }

  Widget subjectCard(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          setState(() {
            selectedSubject = title;
            currentStep = 1;
          });
        },
      ),
    );
  }

  //  QUESTION COUNT SELECTION
  Widget questionCountUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Subject: $selectedSubject", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        const Text("How many questions?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            countButton(5),
            countButton(10),
            countButton(15),
          ],
        ),
      ],
    );
  }

  Widget countButton(int count) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      ),
      onPressed: () {
        setState(() {
          selectedCount = count;
          currentStep = 2;
          questionIndex = 1;
        });
      },
      child: Text("$count",style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
    );
  }

  // QUESTION UI
  Widget questionUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Question $questionIndex / $selectedCount", style: const TextStyle(fontSize: 16)),//show progress
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: green),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Question will be loaded from Firebase",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 30),
        optionBox("Option A"),
        optionBox("Option B"),
        optionBox("Option C"),
        optionBox("Option D"),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: green),
              onPressed: questionIndex > 1
                  ? () {
                setState(() {
                  questionIndex--;
                });
              }
                  : null,
              child: const Text("Prev",style: TextStyle(color:Colors.black),),
            ),
            // Next Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: green),
              onPressed: () {
                if (questionIndex < selectedCount) {
                  setState(() {
                    questionIndex++;
                  });
                } else {
                  setState(() {
                    currentStep = 3; // Show result
                  });
                }
              },
              child: const Text("Next",style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ],
    );
  }

  Widget optionBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: green),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }

  // RESULT UI
  Widget resultUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: green, width: 8),
            ),
            child: const Center(
              child: Text("/", style: TextStyle(fontSize: 40)), // Placeholder for score
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: green),
            onPressed: () {
              setState(() {
                currentStep = 0;
                selectedSubject = "";
                selectedCount = 5;
                questionIndex = 1;
              });
            },
            child: const Text("Restart Quiz",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}