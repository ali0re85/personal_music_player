import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/track_cover.dart';

/// پس‌زمینه‌ی محو شده از روی کاور
class PlayerBackground extends StatelessWidget {
  const PlayerBackground({super.key, required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: SizedBox.expand(
          key: ValueKey(track.id),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Transform.scale(
                  scale: 1.4,
                  child: TrackCover(track: track, fit: BoxFit.cover),
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
