import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Status visual sebuah kartu opsi jawaban.
enum OptionCardStatus {
  /// Belum ada jawaban dipilih — tampilan default.
  idle,

  /// Opsi ini dipilih dan merupakan jawaban yang benar.
  correct,

  /// Opsi ini dipilih dan merupakan jawaban yang salah.
  wrong,

  /// Opsi ini BUKAN yang dipilih, tapi merupakan jawaban yang benar.
  /// Ditampilkan setelah user salah memilih agar user tahu jawaban benarnya.
  revealed,
}

/// Kartu pilihan jawaban dengan animasi warna saat dipilih.
///
/// Menggunakan [StatefulWidget] karena memiliki animasi lokal
/// ([AnimationController] untuk efek scale saat ditekan).
///
/// Status warna dikontrol dari luar via [status] — tidak menyimpan state
/// "terpilih" di sini agar sumber kebenaran tetap di [QuizProvider].
///
/// Contoh pemakaian:
/// ```dart
/// OptionCard(
///   optionLabel: 'A',
///   optionText: 'Albert Einstein',
///   status: OptionCardStatus.correct,
///   onTap: () => provider.answerQuestion(0),
///   isEnabled: !provider.hasAnswered,
/// )
/// ```
class OptionCard extends StatefulWidget {
  const OptionCard({
    super.key,
    required this.optionLabel,
    required this.optionText,
    required this.onTap,
    this.status = OptionCardStatus.idle,
    this.isEnabled = true,
  });

  /// Huruf/label opsi, mis: 'A', 'B', 'C', 'D'.
  final String optionLabel;

  /// Teks isi jawaban.
  final String optionText;

  /// Callback saat kartu ditekan.
  final VoidCallback onTap;

  /// Status visual kartu (idle / correct / wrong / revealed).
  final OptionCardStatus status;

  /// Apakah kartu bisa ditekan. `false` setelah user menjawab.
  final bool isEnabled;

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );

    // Animasi scale: 1.0 → 0.97 saat ditekan, balik ke 1.0 saat dilepas.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (!widget.isEnabled) return;
    _scaleController.reverse(); // 1.0 → 0.97
  }

  void _onTapUp(TapUpDetails _) {
    _scaleController.forward(); // 0.97 → 1.0
  }

  void _onTapCancel() {
    _scaleController.forward();
  }

  // ── Tentukan warna berdasarkan status ──────────────────────────────────────

  _OptionColors _resolveColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (widget.status) {
      case OptionCardStatus.correct:
        return _OptionColors(
          background: AppTheme.colorCorrect.withValues(alpha: 0.15),
          border: AppTheme.colorCorrect,
          labelBackground: AppTheme.colorCorrect,
          labelForeground: Colors.white,
          textColor: AppTheme.colorCorrect,
          icon: Icons.check_circle_rounded,
        );

      case OptionCardStatus.wrong:
        return _OptionColors(
          background: AppTheme.colorWrong.withValues(alpha: 0.12),
          border: AppTheme.colorWrong,
          labelBackground: AppTheme.colorWrong,
          labelForeground: Colors.white,
          textColor: AppTheme.colorWrong,
          icon: Icons.cancel_rounded,
        );

      case OptionCardStatus.revealed:
        // Jawaban benar yang tidak dipilih user — highlight tipis hijau
        return _OptionColors(
          background: AppTheme.colorCorrect.withValues(alpha: 0.08),
          border: AppTheme.colorCorrect.withValues(alpha: 0.5),
          labelBackground: AppTheme.colorCorrect.withValues(alpha: 0.15),
          labelForeground: AppTheme.colorCorrect,
          textColor: colorScheme.onSurface,
          icon: Icons.lightbulb_rounded,
        );

      case OptionCardStatus.idle:
        return _OptionColors(
          background: colorScheme.surface,
          border: colorScheme.outline.withValues(alpha: 0.3),
          labelBackground: colorScheme.primary.withValues(alpha: 0.12),
          labelForeground: colorScheme.primary,
          textColor: colorScheme.onSurface,
          icon: null,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isEnabled ? widget.onTap : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.8),
            boxShadow: [
              BoxShadow(
                color: colors.border.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              // ── Label Huruf (A/B/C/D) ──
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.labelBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.optionLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.labelForeground,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Teks Jawaban ──
              Expanded(
                child: Text(
                  widget.optionText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colors.textColor,
                    height: 1.4,
                  ),
                ),
              ),

              // ── Ikon Status (muncul setelah menjawab) ──
              if (colors.icon != null) ...[
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    colors.icon,
                    key: ValueKey(colors.icon),
                    color: colors.border,
                    size: 22,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Data warna yang di-resolve dari [OptionCardStatus].
class _OptionColors {
  const _OptionColors({
    required this.background,
    required this.border,
    required this.labelBackground,
    required this.labelForeground,
    required this.textColor,
    required this.icon,
  });

  final Color background;
  final Color border;
  final Color labelBackground;
  final Color labelForeground;
  final Color textColor;
  final IconData? icon;
}
