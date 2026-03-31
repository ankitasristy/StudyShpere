import 'package:flutter/material.dart';
import 'quiz_feature_page.dart';
import 'wrong_answer_page.dart';
import 'user_profile_page.dart';
import 'flashcard.dart';
import 'reminder.dart';
import 'timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _pages = [
    _HomePage(),
    FlashcardScreen(),
    Center(child: Text('Reminders', style: TextStyle(fontSize: 18, color: Colors.grey))),
    UserProfilePage(),
  ];

  void _navigate(Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5A8A3D),
        title: Text('StudySphere', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF5A8A3D)),
              child: Text('More', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.quiz_outlined, color: Color(0xFF5A8A3D)),
              title: Text('Quiz'),
              onTap: () => _navigate(QuizFeaturePage()),
            ),
            ListTile(
              leading: Icon(Icons.receipt_outlined, color: Color(0xFF5A8A3D)),
              title: Text('Wrong Answers'),
              onTap: () => _navigate(WrongAnswerPage()),
            ),
          ],
        ),
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
        unselectedItemColor: Colors.grey,
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
          Text('Good Morning', style: TextStyle(fontSize: 13, color: Colors.grey)),
          Text('Noshin Mahi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D5A1E))),
          SizedBox(height: 20),

          // Progress (Only for ui)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF5A8A3D), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Progress", style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 6),
                Text('72% Daily Goal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.72,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(99),
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 12),
                Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('5', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Day Streak', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ]),
                  SizedBox(width: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Sessions', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ]),
                  SizedBox(width: 20),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('14', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Cards Done', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ]),
                ]),
              ],
            ),
          ),

          SizedBox(height: 24),
          Text('Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D5A1E))),
          SizedBox(height: 12),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardScreen())),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.style_outlined, color: Color(0xFF5A8A3D)),
                        Text('Flashcards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('12 cards due', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ]),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PomodoroTimer(onStop: () {}))),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.timer_outlined, color: Color(0xFF5A8A3D)),
                        Text('Pomodoro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('Start session', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ]),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizFeaturePage())),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.quiz_outlined, color: Color(0xFF5A8A3D)),
                        Text('Quiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('3 pending', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      ]),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WrongAnswerPage())),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(Icons.receipt_outlined, color: Color(0xFF5A8A3D)),
                        Text('Wrong Answers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text('8 to review', style: TextStyle(fontSize: 15, color: Colors.grey)),
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