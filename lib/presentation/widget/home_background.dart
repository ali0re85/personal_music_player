import 'package:flutter/material.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/cover_backdrop.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MusicEntity?>(
      valueListenable: PlayerController.instance.currentTrackNotifier,
      builder: (context, track, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          child: track == null
              ? const _GradientBackground(key: ValueKey('gradient'))
              : _BlurredCoverBackground(key: ValueKey(track.id), track: track),
        );
      },
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: context.appColors.fallbackBackdrop,
          ),
        ),
      ),
    );
  }
}

class _BlurredCoverBackground extends StatelessWidget {
  const _BlurredCoverBackground({super.key, required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) => CoverBackdrop(track: track);
}
