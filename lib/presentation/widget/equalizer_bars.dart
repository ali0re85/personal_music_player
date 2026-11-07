import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:music_player/services/audio_service.dart';

class EqualizerBars extends StatefulWidget {
  const EqualizerBars({
    super.key,
    required this.color,
    this.barCount = 5,
    this.height = 18,
  });

  final Color color;
  final int barCount;
  final double height;

  @override
  State<EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<EqualizerBars>
    with TickerProviderStateMixin {
  // موج: میله‌ها رو بالا و پایین می‌بره
  late final AnimationController _wave;
  // سطح: ۰ یعنی میله‌ها صاف (pause)، ۱ یعنی کامل می‌رقصن
  late final AnimationController _level;
  StreamSubscription<bool>? _playingSub;

  @override
  void initState() {
    super.initState();
    _wave = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _level = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    // وقتی میله‌ها کامل صاف شدن، دیگه لازم نیست موج بچرخه
    _level.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) _wave.stop();
    });

    final audio = AudioService.instance;
    _apply(audio.isPlaying);
    _playingSub = audio.playingStream.listen(_apply);
  }

  void _apply(bool playing) {
    if (playing) {
      _wave.repeat();
      _level.forward();
    } else {
      _level.reverse();
    }
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _wave.dispose();
    _level.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.barCount * 6.0 - 3, widget.height),
        painter: _BarsPainter(
          wave: _wave,
          level: _level,
          color: widget.color,
          barCount: widget.barCount,
        ),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.wave,
    required this.level,
    required this.color,
    required this.barCount,
  }) : super(repaint: Listenable.merge([wave, level]));

  final Animation<double> wave;
  final Animation<double> level;
  final Color color;
  final int barCount;

  static const double _barWidth = 3;
  static const double _gap = 3;
  static const double _minHeight = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var i = 0; i < barCount; i++) {
      // هر میله فاز و سرعت خودش رو داره تا همزمان بالا و پایین نرن
      final phase = i * 0.37;
      final speed = 1 + (i % 3) * 0.5;
      final t = math.sin((wave.value * speed + phase) * 2 * math.pi).abs();

      final h = _minHeight + (size.height - _minHeight) * t * level.value;
      final x = i * (_barWidth + _gap);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - h, _barWidth, h),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.color != color || old.barCount != barCount;
}
