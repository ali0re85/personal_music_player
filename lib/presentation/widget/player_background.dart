import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/cover_backdrop.dart';

/// Blurred, colour-rich backdrop behind the player glass.
/// The scrim is deliberately light: the glass panel sits on the lower part of
/// the screen, and a near-black bottom (the old 0.88) made it invisible.
class PlayerBackground extends StatelessWidget {
  const PlayerBackground({super.key, required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      child: CoverBackdrop(
        key: ValueKey(track.id),
        track: track,
        scrimTop: 0.12,
        scrimBottom: 0.35,
      ),
    );
  }
}
