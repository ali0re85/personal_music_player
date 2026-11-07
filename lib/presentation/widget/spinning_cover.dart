import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/track_cover.dart';
import 'package:music_player/services/audio_service.dart';

class SpinningCover extends StatefulWidget {
  const SpinningCover({super.key, required this.track, this.size = 52});

  final MusicEntity track;
  final double size;

  @override
  State<SpinningCover> createState() => _SpinningCoverState();
}

class _SpinningCoverState extends State<SpinningCover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  StreamSubscription<bool>? _playingSub;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // هر ۸ ثانیه یک دور
    );

    final audio = AudioService.instance;
    if (audio.isPlaying) _controller.repeat();

    _playingSub = audio.playingStream.listen((playing) {
      if (playing) {
        _controller.repeat(); // از زاویه‌ی فعلی ادامه می‌ده
      } else {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final hole = size * 0.2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RepaintBoundary(
            child: RotationTransition(
              turns: _controller,
              child: ClipOval(
                child: TrackCover(
                  track: widget.track,
                  width: size,
                  height: size,
                  cacheWidth: 200,
                ),
              ),
            ),
          ),
          // سوراخ وسط صفحه، نمی‌چرخه
          Container(
            width: hole,
            height: hole,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.75),
              border: Border.all(color: Colors.white24, width: 1),
            ),
          ),
        ],
      ),
    );
  }
}
