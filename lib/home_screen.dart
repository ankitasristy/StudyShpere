import 'package:flutter/material.dart';
import 'quiz_feature_page.dart';
import 'wrong_answer_page.dart';
import 'user_profile_page.dart';
import 'flashcard.dart';
import 'reminder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _pages = [
    const _HomePage(),
    const FlashcardScreen(),
    const Center(child: Text('Reminders', style: TextStyle(fontSize: 18, color: Colors.grey))),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A8A3D),
        title: const Text('StudySphere', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) {
          if (i == 2) {
            StudyReminder.scheduleRevisionReminder(context);
            return;
          }
          setState(() => _selectedIndex = i);
        },
        selectedItemColor: const Color(0xFF5A8A3D),
        unselectedItemColor: const Color(0xFF5A8A3D),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.style_outlined), activeIcon: Icon(Icons.style), label: 'Flashcards'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text('Features', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF2D5A1E))),
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardScreen())),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.style_outlined, color: Color(0xFF5A8A3D)),
                        Text('Flashcards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashcardScreen(useTimer:true))),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.timer_outlined, color: Color(0xFF5A8A3D)),
                        Text('Pomodoro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Start session', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizFeaturePage())),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.quiz_outlined, color: Color(0xFF5A8A3D)),
                        Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WrongAnswerPage())),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.receipt_outlined, color: Color(0xFF5A8A3D)),
                        Text('Wrong Answers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}