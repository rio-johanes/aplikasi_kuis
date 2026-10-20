import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'screens/quiz_screen.dart';
import 'screens/result_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuizProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ── Named route constants ──────────────────────────────────────────────────
  static const String routeWelcome = '/';
  static const String routeQuiz = '/quiz';
  static const String routeResult = '/result';

  @override
  Widget build(BuildContext context) {
    // Hanya rebuild MaterialApp saat themeMode berubah.
    final themeMode = context.select<QuizProvider, ThemeMode>(
      (p) => p.themeMode,
    );

    return MaterialApp(
      title: 'Aplikasi Kuis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Rute awal aplikasi.
      initialRoute: routeWelcome,

      // Tabel rute bernama — navigasi bisa menggunakan
      // Navigator.pushNamed(context, MyApp.routeQuiz) dari mana saja.
      routes: {
        routeWelcome: (_) => const WelcomeScreen(),
        routeQuiz: (_) => const QuizScreen(),
        routeResult: (_) => const ResultScreen(),
      },
    );
  }
}
