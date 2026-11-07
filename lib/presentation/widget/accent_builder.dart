import 'package:flutter/material.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/app_theme.dart';

/// رنگ accent آهنگ فعلی رو میده و تغییرش رو نرم انیمیت می‌کنه.
/// فقط خودش rebuild میشه، نه کل صفحه.
class AccentBuilder extends StatelessWidget {
  const AccentBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, Color accent) builder;

  @override
  Widget build(BuildContext context) {
    final fallback = context.appColors.accent;

    return ValueListenableBuilder<Color?>(
      valueListenable: PlayerController.instance.accentNotifier,
      builder: (context, accent, _) {
        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: accent ?? fallback),
          duration: const Duration(milliseconds: 600),
          builder: (context, color, _) => builder(context, color ?? fallback),
        );
      },
    );
  }
}
