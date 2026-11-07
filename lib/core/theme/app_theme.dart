import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.onMedia,
    required this.accent,
    required this.liked,
    required this.error,
    required this.scrim,
    required this.fallbackBackdrop,
  });

  final Color onMedia;
  final Color accent;
  final Color liked;
  final Color error;
  final Color scrim;
  final List<Color> fallbackBackdrop;

  // Opacity steps derived from one base colour (replaces white70/54/38/24).
  Color get muted => onMedia.withValues(alpha: 0.70);
  Color get subtle => onMedia.withValues(alpha: 0.54);
  Color get faint => onMedia.withValues(alpha: 0.38);
  Color get track => onMedia.withValues(alpha: 0.24);
  Color scrimAt(double alpha) => scrim.withValues(alpha: alpha);

  static const dark = AppColors(
    onMedia: Colors.white,
    accent: Color(0xFFB39DDB),
    liked: Colors.redAccent,
    error: Colors.redAccent,
    scrim: Colors.black,
    fallbackBackdrop: [Color(0xFF7E57C2), Color(0xFF4527A0), Color(0xFF1A237E)],
  );

  static final light = dark.copyWith(
    onMedia: const Color(0xFF121212),
    accent: const Color(0xFF5E35B1),
  );
  @override
  AppColors copyWith({
    Color? onMedia,
    Color? liked,
    Color? error,
    Color? scrim,
    Color? accent,
    List<Color>? avatarRing,
    List<Color>? fallbackBackdrop,
  }) {
    return AppColors(
      onMedia: onMedia ?? this.onMedia,
      liked: liked ?? this.liked,
      error: error ?? this.error,
      scrim: scrim ?? this.scrim,
      accent: accent ?? this.accent,
      fallbackBackdrop: fallbackBackdrop ?? this.fallbackBackdrop,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      onMedia: Color.lerp(onMedia, other.onMedia, t)!,
      liked: Color.lerp(liked, other.liked, t)!,
      error: Color.lerp(error, other.error, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      fallbackBackdrop: t < 0.5 ? fallbackBackdrop : other.fallbackBackdrop,
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

abstract final class AppTheme {
  // یک بار ساخته میشن، که هر بار تغییر آهنگ تم از نو ساخته نشه.
  static final ThemeData _dark = _build(AppColors.dark, Brightness.dark);
  static final ThemeData _light = _build(AppColors.light, Brightness.light);

  static ThemeData dark() => _dark;

  /// تم مناسب بک‌گراند فعلی: روی کاور روشن محتوای تیره، روی تیره محتوای سفید.
  static ThemeData forBackdrop({required bool isLight}) =>
      isLight ? _light : _dark;

  static ThemeData _build(AppColors c, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: brightness,
      ),
      extensions: [c],
      iconTheme: IconThemeData(color: c.onMedia),
      listTileTheme: ListTileThemeData(
        textColor: c.onMedia,
        subtitleTextStyle: TextStyle(color: c.muted),
      ),
      textTheme: TextTheme(
        // player track title
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          height: 1.2,
          color: c.onMedia,
        ),
        // section titles ("Play Lists", "Songs", app name)
        titleMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: c.onMedia,
        ),
        // names / mini player title
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: c.onMedia,
        ),
        bodyMedium: TextStyle(color: c.onMedia),
        // secondary text (artist, handle, counts)
        bodySmall: TextStyle(fontSize: 12, color: c.muted),
        // time labels
        labelSmall: TextStyle(
          fontSize: 12,
          color: c.muted,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
