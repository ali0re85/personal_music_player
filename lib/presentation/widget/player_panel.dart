import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/player_controls.dart';
import 'package:music_player/presentation/widget/player_seek_bar.dart';
import 'package:music_player/presentation/widget/player_track_info.dart';

class PlayerPanel extends StatelessWidget {
  const PlayerPanel({super.key, required this.track, required this.hasError});

  final MusicEntity track;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlayerTrackInfo(track: track, hasError: hasError),
        const SizedBox(height: 16),
        const PlayerSeekBar(),
        const SizedBox(height: 16),
        const PlayerControls(),
      ],
    );
  }
}
