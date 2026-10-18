import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';
import 'package:music_player/services/audio_service.dart';

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({super.key});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService.instance;

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  StreamSubscription<bool>? _sub;

  @override
  void initState() {
    super.initState();

    // آیکون play/pause با وضعیت واقعی پلیر هماهنگ می‌شود
    _sub = _audioService.playingStream.listen((playing) {
      if (playing) {
        _playPauseController.forward();
      } else {
        _playPauseController.reverse();
      }
    });

    _playPauseController.value = _audioService.isPlaying ? 1 : 0;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _playPauseController.dispose();

    super.dispose();
  }

  void _togglePlay() {
    HapticFeedback.lightImpact();

    context.read<MusicScreenBloc>().add(PlayPausePressed());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _audioService.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        final busy =
            state != null &&
            (state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.22),
                blurRadius: 24,
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _togglePlay,
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: busy
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        )
                      : AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _playPauseController,
                          size: 34,
                          color: Colors.black,
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
