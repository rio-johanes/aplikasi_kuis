import 'package:flutter/material.dart';

/// Lebar maksimum konten agar tidak melebar penuh di tablet / web.
const double kContentMaxWidth = 600.0;

/// Wrapper responsive yang membatasi lebar konten di tengah layar.
///
/// Cara kerja:
/// - Pada layar sempit (HP): konten mengisi penuh lebar layar.
/// - Pada layar lebar (Tablet / Web): konten dibatasi [maxWidth] dan
///   dipusatkan secara horizontal, sehingga UI tetap rapi seperti di HP.
///
/// Gunakan ini sebagai pengganti langsung [SingleChildScrollView] atau
/// sebagai wrapper di dalam [Scaffold.body].
///
/// Contoh pemakaian (body scrollable):
/// ```dart
/// body: AdaptiveLayout(
///   child: SingleChildScrollView(...),
/// )
/// ```
///
/// Contoh pemakaian (body non-scrollable / Column):
/// ```dart
/// body: AdaptiveLayout(
///   scrollable: false,
///   child: Column(...),
/// )
/// ```
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.child,
    this.maxWidth = kContentMaxWidth,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
  });

  /// Widget konten yang dibungkus.
  final Widget child;

  /// Lebar maksimum konten. Default [kContentMaxWidth] = 600dp.
  final double maxWidth;

  /// Padding tambahan di luar ConstrainedBox (opsional).
  final EdgeInsets padding;

  /// Alignment konten dalam area yang tersisa saat layar lebih lebar.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Versi [AdaptiveLayout] yang sudah menyertakan [SingleChildScrollView]
/// di dalamnya — untuk body screen yang kontennya bisa discroll.
class AdaptiveScrollLayout extends StatelessWidget {
  const AdaptiveScrollLayout({
    super.key,
    required this.child,
    this.maxWidth = kContentMaxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.physics,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          physics: physics,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
