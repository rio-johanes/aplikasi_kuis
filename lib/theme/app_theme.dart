import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kelas pusat untuk semua konfigurasi tema aplikasi.
/// Mendukung Light Mode dan Dark Mode.
abstract class AppTheme {
  // ── Palet Warna ──────────────────────────────────────────────────────────

  // Light Mode — palet biru-ungu dengan aksen kuning hangat
  static const Color _lightPrimary = Color(0xFF5C6BC0); // Indigo cerah
  static const Color _lightSecondary = Color(0xFF7E57C2); // Purple pastel
  static const Color _lightAccent = Color(0xFFFFA726); // Amber hangat
  static const Color _lightBackground = Color(0xFFF5F6FA); // Abu sangat terang
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnBackground = Color(0xFF1A1A2E);
  static const Color _lightOnSurface = Color(0xFF2C2C54);

  // Dark Mode — palet navy dalam dengan aksen teal
  static const Color _darkPrimary = Color(0xFF7986CB); // Indigo pucat
  static const Color _darkSecondary = Color(0xFF9575CD); // Purple muda
  static const Color _darkAccent = Color(0xFFFFCA28); // Kuning lembut
  static const Color _darkBackground = Color(0xFF0F0F23); // Navy sangat gelap
  static const Color _darkSurface = Color(0xFF1A1A35); // Navy gelap
  static const Color _darkOnPrimary = Color(0xFF0F0F23);
  static const Color _darkOnBackground = Color(0xFFE8EAF6);
  static const Color _darkOnSurface = Color(0xFFE8EAF6);

  // Warna semantik (sama di kedua tema)
  static const Color colorCorrect = Color(0xFF66BB6A); // Hijau jawaban benar
  static const Color colorWrong = Color(0xFFEF5350); // Merah jawaban salah
  static const Color colorNeutral = Color(0xFFBDBDBD); // Abu-abu netral

  // ── TextTheme Helper ──────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(TextTheme base) {
    return GoogleFonts.poppinsTextTheme(base);
  }

  // ── Light Theme ───────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _lightPrimary,
      onPrimary: _lightOnPrimary,
      secondary: _lightSecondary,
      onSecondary: _lightOnPrimary,
      tertiary: _lightAccent,
      onTertiary: _lightOnBackground,
      error: colorWrong,
      onError: _lightOnPrimary,
      surface: _lightSurface,
      onSurface: _lightOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _lightBackground,
      textTheme: _buildTextTheme(ThemeData.light().textTheme),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: _lightOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimary,
          side: const BorderSide(color: _lightPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 3,
        shadowColor: _lightPrimary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // ── Dark Theme ────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: _darkOnPrimary,
      secondary: _darkSecondary,
      onSecondary: _darkOnPrimary,
      tertiary: _darkAccent,
      onTertiary: _darkOnBackground,
      error: colorWrong,
      onError: _darkOnBackground,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,
      textTheme: _buildTextTheme(ThemeData.dark().textTheme),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnBackground,
        elevation: 0,
        centerTitle: true,
      ),

      // ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: const BorderSide(color: _darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 3,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
