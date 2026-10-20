import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // QuizProvider mengelola seluruh state kuis:
        // nama user, skor, indeks soal aktif, dan tema.
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan themeMode dari QuizProvider.
    // Setiap kali toggleTheme() dipanggil, MaterialApp rebuild
    // dan tema berubah secara dinamis tanpa restart aplikasi.
    final themeMode = context.select<QuizProvider, ThemeMode>(
      (provider) => provider.themeMode,
    );

    return MaterialApp(
      title: 'Aplikasi Kuis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      // themeMode dikontrol oleh QuizProvider — bukan lagi ThemeMode.system.
      themeMode: themeMode,

      home: const _PlaceholderScreen(),
    );
  }
}

/// Layar placeholder sementara.
/// Akan diganti dengan layar nyata (splash/home) pada tahap berikutnya.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Kuis'),
        actions: [
          // Tombol toggle tema — membuktikan dynamic theme berjalan.
          IconButton(
            tooltip: provider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),
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
              'Tahap 3 — State Management',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),

            // Info state dari provider — verifikasi state tidak hilang saat rotasi.
            _StateInfoCard(provider: provider),
          ],
        ),
      ),
    );
  }
}

/// Widget kecil untuk menampilkan isi state provider saat ini.
/// Berguna untuk verifikasi bahwa state persist saat rotasi layar.
class _StateInfoCard extends StatelessWidget {
  const _StateInfoCard({required this.provider});

  final QuizProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'State Provider (Debug)',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(),
            _InfoRow(
              label: 'Nama User',
              value: provider.userName.isEmpty
                  ? '(belum diisi)'
                  : provider.userName,
            ),
            _InfoRow(
              label: 'Skor',
              value: '${provider.score} / ${provider.totalQuestions}',
            ),
            _InfoRow(
              label: 'Soal Aktif',
              value:
                  '${provider.currentQuestionNumber} / ${provider.totalQuestions}',
            ),
            _InfoRow(
              label: 'Tema',
              value: provider.isDarkMode ? 'Dark Mode' : 'Light Mode',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
