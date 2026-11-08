import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key, required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) {
    // hue از روی id آهنگ، پس برای هر آهنگ ثابته
    final hue = (track.id * 47 % 360).toDouble();
    final a = HSLColor.fromAHSL(1, hue, 0.55, 0.38).toColor();
    final b = HSLColor.fromAHSL(1, (hue + 35) % 360, 0.60, 0.22).toColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide;
        final iconSize = side.isFinite ? side * 0.4 : 24.0;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [a, b],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.music_note_rounded,
              size: iconSize,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        );
      },
    );
  }
}