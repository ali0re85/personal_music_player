import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/player_controls.dart';
import 'package:music_player/presentation/widget/player_seek_bar.dart';
import 'package:music_player/presentation/widget/player_track_info.dart';

/// پنل شیشه‌ای پایین
class PlayerPanel extends StatelessWidget {
  const PlayerPanel({super.key, required this.track, required this.hasError});

  final MusicEntity track;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlayerTrackInfo(track: track, hasError: hasError),
              const SizedBox(height: 8),
              const PlayerSeekBar(),
              const SizedBox(height: 4),
              const PlayerControls(),
            ],
          ),
        ),
      ),
    );
  }
}