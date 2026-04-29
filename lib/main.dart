import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/quest_viewmodel.dart';
import 'views/login/login_page.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => QuestViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
