import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/track_cover.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerCover extends StatelessWidget {
  const PlayerCover({super.key, required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return StreamBuilder<bool>(
      stream: audioService.playingStream,
      initialData: audioService.isPlaying,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: AnimatedScale(
              scale: playing ? 1.0 : 0.86,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: playing ? 0.55 : 0.3,
                        ),
                        blurRadius: playing ? 50 : 20,
                        offset: Offset(0, playing ? 24 : 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: TrackCover(track: track, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}