import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/custom_button.dart';
import '../widgets/option_card.dart';
import '../widgets/question_card.dart';
import 'result_screen.dart';

/// Layar utama kuis: menampilkan soal, opsi jawaban, dan progres.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D', 'E'];

  void _goToResult(BuildContext context) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => const ResultScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  OptionCardStatus _resolveStatus(QuizProvider provider, int optionIndex) {
    if (!provider.hasAnswered) return OptionCardStatus.idle;

    final isSelected = provider.selectedAnswerIndex == optionIndex;
    final isCorrect =
        provider.currentQuestion.correctAnswerIndex == optionIndex;

    if (isSelected && isCorrect) return OptionCardStatus.correct;
    if (isSelected && !isCorrect) return OptionCardStatus.wrong;
    if (!isSelected && isCorrect) return OptionCardStatus.revealed;

    return OptionCardStatus.idle;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.userName.isEmpty ? 'Kuis' : 'Halo, ${provider.userName}!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        automaticallyImplyLeading: false,
        actions: [
          // ── Toggle Light / Dark Mode ──────────────────────────────────
          IconButton(
            tooltip: provider.isDarkMode ? 'Light Mode' : 'Dark Mode',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey(provider.isDarkMode),
              ),
            ),
            onPressed: provider.toggleTheme,
          ),
          // ── Skor live ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${provider.score}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten soal (scrollable, dibatasi maxWidth) ───────────
            Expanded(
              child: AdaptiveLayout(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Kartu Pertanyaan ──
                      QuestionCard(
                        questionNumber: provider.currentQuestionNumber,
                        totalQuestions: provider.totalQuestions,
                        questionText: provider.currentQuestion.questionText,
                        progressValue: provider.progressPercent,
                      ),

                      const SizedBox(height: 20),

                      // ── Daftar Opsi Jawaban ──
                      ...List.generate(
                        provider.currentQuestion.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: OptionCard(
                            optionLabel: _optionLabels[index],
                            optionText: provider.currentQuestion.options[index],
                            status: _resolveStatus(provider, index),
                            isEnabled: !provider.hasAnswered,
                            onTap: () => provider.answerQuestion(index),
                          ),
                        ),
                      ),

                      // ── Penjelasan Jawaban ──
                      if (provider.hasAnswered &&
                          provider.currentQuestion.explanation != null)
                        _ExplanationBox(
                          explanation: provider.currentQuestion.explanation!,
                          isCorrect:
                              provider.answerStatus == AnswerStatus.correct,
                          colorScheme: colorScheme,
                        ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),

            // ── Tombol aksi bawah (juga dibatasi maxWidth) ────────────
            if (provider.hasAnswered)
              _BottomActionBar(
                provider: provider,
                onNext: () {
                  final moved = provider.nextQuestion();
                  if (!moved) _goToResult(context);
                },
                onFinish: () => _goToResult(context),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widget lokal ──────────────────────────────────────────────────────────

class _ExplanationBox extends StatelessWidget {
  const _ExplanationBox({
    required this.explanation,
    required this.isCorrect,
    required this.colorScheme,
  });

  final String explanation;
  final bool isCorrect;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final bgColor = isCorrect
        ? const Color(0xFF66BB6A).withValues(alpha: 0.1)
        : const Color(0xFFEF5350).withValues(alpha: 0.08);
    final borderColor = isCorrect
        ? const Color(0xFF66BB6A).withValues(alpha: 0.5)
        : const Color(0xFFEF5350).withValues(alpha: 0.4);
    final iconData = isCorrect
        ? Icons.check_circle_outline
        : Icons.info_outline_rounded;
    final iconColor = isCorrect
        ? const Color(0xFF66BB6A)
        : const Color(0xFFEF5350);

    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              explanation,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.provider,
    required this.onNext,
    required this.onFinish,
  });

  final QuizProvider provider;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    // Tombol bawah juga dibungkus AdaptiveLayout agar tidak melebar di tablet.
    return AdaptiveLayout(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: CustomButton(
            label: provider.isLastQuestion ? 'Lihat Hasil' : 'Soal Berikutnya',
            onPressed: provider.isLastQuestion ? onFinish : onNext,
            icon: provider.isLastQuestion
                ? Icons.emoji_events_rounded
                : Icons.arrow_forward_rounded,
          ),
        ),
      ),
    );
  }
}
