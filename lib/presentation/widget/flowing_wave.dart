import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/audio_service.dart';

class FlowingWave extends StatefulWidget {
  const FlowingWave({
    super.key,
    required this.color,
    this.level,
    this.gain = 5,
    this.width = 110,
    this.height = 55,
  });

  final Color color;

  /// سطح صدا بین ۰ تا ۱ (از VisualizerService). اگه null باشه،
  /// موج با یک دامنه‌ی ثابت و ملایم حرکت می‌کنه.
  final ValueListenable<double>? level;

  /// ضریب حساسیت به صدا؛ اگه موج کم تکون می‌خوره زیادش کن.
  final double gain;
  final double width;
  final double height;

  @override
  State<FlowingWave> createState() => _FlowingWaveState();
}

class _FlowingWaveState extends State<FlowingWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  StreamSubscription<bool>? _playingSub;

  bool _playing = false;
  double _amp = 0; // دامنه‌ی صاف‌شده، ۰ تا ۱

  @override
  void initState() {
    super.initState();
    // ۱۰ ثانیه یک دور کامل؛ سرعت لایه‌ها ضریب صحیحی از این هست،
    // پس حلقه بدون پرش تکرار می‌شه
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(_tick)
          ..repeat();

    final audio = AudioService.instance;
    _playing = audio.isPlaying;
    _playingSub = audio.playingStream.listen((p) => _playing = p);
  }

  void _tick() {
    final double target;
    if (!_playing) {
      target = 0;
    } else if (widget.level == null) {
      target = 0.45;
    } else {
      target = (0.2 + widget.level!.value * widget.gain).clamp(0.0, 1.0);
    }

    // بالا رفتن سریع، پایین اومدن آهسته
    final k = target > _amp ? 0.35 : 0.06;
    _amp += (target - _amp) * k;
  }

  @override
  void dispose() {
    _playingSub?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final partner = hsl.withHue((hsl.hue + 60) % 360).toColor();

    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _WavePainter(
          t: _ctrl,
          amp: () => _amp,
          from: widget.color,
          to: partner,
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.t,
    required this.amp,
    required this.from,
    required this.to,
  }) : super(repaint: t);

  final Animation<double> t;
  final double Function() amp;
  final Color from;
  final Color to;

  // هر لایه: ضریب دامنه، تعداد موج روی عرض، سرعت (صحیح)، شفافیت، ضخامت
  static const _layers = [
    (amp: 1.00, freq: 1.5, speed: 1, alpha: 1.00, stroke: 2.4),
    (amp: 0.65, freq: 2.2, speed: -2, alpha: 0.55, stroke: 1.8),
    (amp: 0.40, freq: 3.1, speed: 3, alpha: 0.30, stroke: 1.4),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final a = amp();
    final midY = size.height / 2;
    final maxAmp = midY - 2;

    final shader = LinearGradient(colors: [from, to])
        .createShader(Offset.zero & size);

    for (final layer in _layers) {
      final phase = t.value * 2 * math.pi * layer.speed;
      final path = Path();

      for (double x = 0; x <= size.width; x += 2) {
        final u = x / size.width;
        // دو سر موج محو می‌شه و وسطش بیشترین دامنه رو داره
        final envelope = math.sin(math.pi * u);
        final y =
            midY +
            math.sin(u * layer.freq * 2 * math.pi + phase) *
                maxAmp *
                layer.amp *
                a *
                envelope;

        x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
      }

      final paint = Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = layer.stroke
        ..color = Colors.white.withValues(alpha: layer.alpha);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.from != from || old.to != to;
}
