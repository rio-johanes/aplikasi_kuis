import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Provider akan ditambahkan di sini pada tahap berikutnya.
        // Contoh: ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kuis',
      debugShowCheckedModeBanner: false,

      // Terapkan Light dan Dark theme dari AppTheme.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // Ikuti preferensi sistem (light/dark) pengguna secara otomatis.
      themeMode: ThemeMode.system,

      home: const _PlaceholderScreen(),
    );
  }
}

/// Layar placeholder sementara.
/// Akan diganti dengan splash/home screen pada tahap berikutnya.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_rounded,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aplikasi Kuis',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tahap 2 — Tema & Model Data',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
