import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    // MultiProvider di-wrap di root agar semua provider
    // bisa diakses oleh seluruh widget tree.
    MultiProvider(
      providers: [
        // Provider-provider akan ditambahkan di sini pada tahap berikutnya.
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        // Menggunakan Google Fonts sebagai font default aplikasi.
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      // Halaman awal sementara — akan diganti dengan splash/home screen
      // pada tahap berikutnya.
      home: const _PlaceholderScreen(),
    );
  }
}

/// Layar placeholder sementara selama tahap inisialisasi.
/// Akan dihapus dan diganti dengan screen asli pada tahap berikutnya.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Aplikasi Kuis',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
      ),
    );
  }
}
