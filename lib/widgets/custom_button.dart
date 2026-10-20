import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Jenis visual tombol.
enum CustomButtonVariant { primary, secondary, outlined }

/// Tombol serbaguna yang ukurannya menyesuaikan lebar layar via [LayoutBuilder].
///
/// Mendukung tiga varian: [primary], [secondary], dan [outlined].
/// Lebar default 100% parent — bisa dikecilkan lewat [widthFactor].
///
/// Contoh pemakaian:
/// ```dart
/// CustomButton(
///   label: 'Mulai Kuis',
///   onPressed: () => ...,
/// )
/// CustomButton(
///   label: 'Ulangi',
///   variant: CustomButtonVariant.outlined,
///   widthFactor: 0.6,
///   icon: Icons.refresh,
/// )
/// ```
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.widthFactor = 1.0,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  }) : assert(
         widthFactor > 0 && widthFactor <= 1.0,
         'widthFactor harus berada di rentang (0, 1.0]',
       );

  /// Teks yang ditampilkan di dalam tombol.
  final String label;

  /// Callback saat tombol ditekan. Set `null` untuk menonaktifkan.
  final VoidCallback? onPressed;

  /// Varian visual tombol.
  final CustomButtonVariant variant;

  /// Faktor lebar tombol relatif terhadap parent (0.0 – 1.0).
  /// Default `1.0` = penuh lebar parent.
  final double widthFactor;

  /// Ikon opsional di sisi kiri label.
  final IconData? icon;

  /// Tampilkan indikator loading dan nonaktifkan tombol.
  final bool isLoading;

  /// Apakah tombol aktif/bisa diklik.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveCallback = (enabled && !isLoading) ? onPressed : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Hitung lebar tombol relatif terhadap constraint parent.
        final buttonWidth = constraints.maxWidth * widthFactor;

        return Center(
          child: SizedBox(
            width: buttonWidth,
            // Tinggi tombol responsif: min 48dp, tumbuh dengan font scaling.
            child: _buildButton(
              context: context,
              colorScheme: colorScheme,
              effectiveCallback: effectiveCallback,
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required ColorScheme colorScheme,
    required VoidCallback? effectiveCallback,
  }) {
    final labelStyle = GoogleFonts.poppins(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );

    final child = _buildChild(labelStyle, colorScheme);

    switch (variant) {
      case CustomButtonVariant.primary:
        return ElevatedButton(
          onPressed: effectiveCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );

      case CustomButtonVariant.secondary:
        return ElevatedButton(
          onPressed: effectiveCallback,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
            disabledBackgroundColor: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );

      case CustomButtonVariant.outlined:
        return OutlinedButton(
          onPressed: effectiveCallback,
          style: OutlinedButton.styleFrom(
            foregroundColor: colorScheme.primary,
            side: BorderSide(
              color: enabled
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.38),
              width: 1.5,
            ),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );
    }
  }

  Widget _buildChild(TextStyle labelStyle, ColorScheme colorScheme) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == CustomButtonVariant.outlined
                ? colorScheme.primary
                : colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: labelStyle),
        ],
      );
    }

    return Text(label, style: labelStyle);
  }
}
