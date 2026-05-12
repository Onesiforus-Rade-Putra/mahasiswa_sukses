import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'quiz/quiz_page.dart';
import 'forum/forum_page.dart';
import 'widgets/custom_bottom_navbar.dart';
import 'leaderboard/leaderboard_page.dart';
import 'setting/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onChangeTab: _changeTab),
      const ForumPage(),
      const QuizPage(),
      const LeaderboardPage(),
      const SettingPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
