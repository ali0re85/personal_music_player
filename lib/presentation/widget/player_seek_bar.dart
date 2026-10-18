import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerSeekBar extends StatelessWidget {
  const PlayerSeekBar({super.key});

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return h > 0
        ? '$h:${m.toString().padLeft(2, '0')}:$s'
        : '${d.inMinutes}:$s';
  }

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return BlocBuilder<MusicScreenBloc, MusicScreenState>(
      builder: (context, blocState) {
        final isDragging =
            blocState is MusicScreenLoaded && blocState.isDragging;
        final dragValue = blocState is MusicScreenLoaded
            ? blocState.dragValue
            : 0.0;

        return StreamBuilder<Duration?>(
          stream: audioService.durationStream,
          initialData: audioService.player.duration,
          builder: (context, durationSnap) {
            final total = durationSnap.data ?? Duration.zero;

            final maxMs = total.inMilliseconds.toDouble();

            return StreamBuilder<Duration>(
              stream: audioService.positionStream,
              builder: (context, positionSnap) {
                final position = positionSnap.data ?? Duration.zero;

                final currentMs = isDragging
                    ? dragValue
                    : position.inMilliseconds.toDouble();

                final value = maxMs > 0
                    ? currentMs.clamp(0, maxMs).toDouble()
                    : 0.0;

                final shown = Duration(milliseconds: value.round());

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white24,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                          elevation: 0,
                          pressedElevation: 0,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 16,
                        ),
                      ),
                      child: Slider(
                        min: 0,
                        max: maxMs > 0 ? maxMs : 1,
                        value: value,
                        onChanged: maxMs > 0
                            ? (v) => context.read<MusicScreenBloc>().add(
                                SeekDragged(v),
                              )
                            : null,
                        onChangeEnd: (v) =>
                            context.read<MusicScreenBloc>().add(SeekEnded(v)),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _format(shown),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          Text(
                            _format(total),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}