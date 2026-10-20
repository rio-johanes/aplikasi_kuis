import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kartu yang menampilkan teks pertanyaan dan indikator progres kuis.
///
/// Menggunakan [StatelessWidget] karena tidak memiliki state lokal —
/// semua data diterima dari luar via parameter.
///
/// Ukuran font dan padding menyesuaikan lebar layar via [MediaQuery].
///
/// Contoh pemakaian:
/// ```dart
/// QuestionCard(
///   questionNumber: 3,
///   totalQuestions: 10,
///   questionText: 'Siapa penemu teori relativitas?',
///   progressValue: 0.3,
/// )
/// ```
class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
    required this.progressValue,
    this.categoryLabel,
  });

  /// Nomor soal saat ini (1-based).
  final int questionNumber;

  /// Total jumlah soal dalam kuis.
  final int totalQuestions;

  /// Teks pertanyaan yang ditampilkan.
  final String questionText;

  /// Nilai progres (0.0 – 1.0) untuk progress bar.
  final double progressValue;

  /// Label kategori opsional (mis: "Sains", "Flutter").
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Responsif: gunakan MediaQuery untuk font dan padding dinamis.
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final questionFontSize = isSmallScreen ? 15.0 : 17.0;
    final cardPadding = isSmallScreen ? 16.0 : 20.0;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Baris atas: Nomor soal + label kategori ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Chip nomor soal
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Soal $questionNumber / $totalQuestions',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                // Label kategori (opsional)
                if (categoryLabel != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoryLabel!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Progress Bar ──
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progressValue),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ── Teks Pertanyaan ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                questionText,
                // Key penting agar AnimatedSwitcher mendeteksi perubahan teks.
                key: ValueKey<String>(questionText),
                style: GoogleFonts.poppins(
                  fontSize: questionFontSize,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
