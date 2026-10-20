import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'welcome_screen.dart';

/// Layar hasil akhir kuis: menampilkan skor, predikat, dan tombol ulangi.
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playAgain(BuildContext context) {
    final provider = context.read<QuizProvider>();
    provider.resetQuiz();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const WelcomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-1.0, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    final score = provider.score;
    final total = provider.totalQuestions;
    final percentage = (score / total * 100).round();
    final predikat = _getPredikat(score, total);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: provider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.03),

                // ── Ilustrasi Hasil ───────────────────────────────────────
                ScaleTransition(
                  scale: _scaleAnim,
                  child: _ResultIllustration(
                    score: score,
                    total: total,
                    colorScheme: colorScheme,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // ── Sapaan Nama ───────────────────────────────────────────
                Text(
                  provider.userName.isEmpty
                      ? 'Kuis Selesai!'
                      : 'Hebat, ${provider.userName}!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  predikat.message,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.035),

                // ── Kartu Skor ────────────────────────────────────────────
                _ScoreCard(
                  score: score,
                  total: total,
                  percentage: percentage,
                  predikat: predikat,
                  colorScheme: colorScheme,
                ),

                SizedBox(height: screenHeight * 0.04),

                // ── Tombol Aksi ───────────────────────────────────────────
                CustomButton(
                  label: 'Main Lagi',
                  onPressed: () => _playAgain(context),
                  icon: Icons.replay_rounded,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Ganti Nama',
                  onPressed: () => _playAgain(context),
                  variant: CustomButtonVariant.outlined,
                  icon: Icons.person_outline_rounded,
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _Predikat _getPredikat(int score, int total) {
    final pct = score / total;
    if (pct >= 0.85) {
      return _Predikat(
        label: 'Luar Biasa!',
        emoji: '🏆',
        message: 'Nilai sempurna! Kamu benar-benar menguasai materi ini.',
        color: AppTheme.colorCorrect,
      );
    } else if (pct >= 0.60) {
      return _Predikat(
        label: 'Bagus!',
        emoji: '⭐',
        message: 'Kamu menjawab dengan baik. Terus tingkatkan ya!',
        color: const Color(0xFFFFA726),
      );
    } else {
      return _Predikat(
        label: 'Semangat!',
        emoji: '💪',
        message: 'Jangan menyerah. Coba lagi dan raih nilai yang lebih baik!',
        color: AppTheme.colorWrong,
      );
    }
  }
}

// ── Sub-widget dan data lokal ─────────────────────────────────────────────────

class _Predikat {
  const _Predikat({
    required this.label,
    required this.emoji,
    required this.message,
    required this.color,
  });
  final String label;
  final String emoji;
  final String message;
  final Color color;
}

/// Ilustrasi lingkaran berisi emoji dan skor besar.
class _ResultIllustration extends StatelessWidget {
  const _ResultIllustration({
    required this.score,
    required this.total,
    required this.colorScheme,
  });
  final int score;
  final int total;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$score',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          Text(
            'dari $total',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu ringkasan skor dengan progress bar persentase.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.score,
    required this.total,
    required this.percentage,
    required this.predikat,
    required this.colorScheme,
  });

  final int score;
  final int total;
  final int percentage;
  final _Predikat predikat;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Baris predikat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(predikat.emoji, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 10),
                    Text(
                      predikat.label,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: predikat.color,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: predikat.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percentage%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: predikat.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress bar persentase
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: percentage / 100),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(predikat.color),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Baris detail: Benar / Salah
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.check_circle_rounded,
                    color: AppTheme.colorCorrect,
                    label: 'Benar',
                    value: '$score',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatItem(
                    icon: Icons.cancel_rounded,
                    color: AppTheme.colorWrong,
                    label: 'Salah',
                    value: '${total - score}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
