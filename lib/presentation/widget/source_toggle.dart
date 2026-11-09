import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/domain/entity/music_source.dart';

class SourceToggle extends StatelessWidget {
  final MusicSource selected;
  final ValueChanged<MusicSource> onChanged;

  const SourceToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 40,
      child: GlassSegmentedControl(
        height: 40,
        quality: GlassQuality.premium,
        segments: const [
          GlassSegment(label: 'Local'),
          GlassSegment(label: 'Online'),
        ],
        selectedIndex: selected == MusicSource.local ? 0 : 1,
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          foreground: Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE9DDFF), Color(0xFF9B6BFF), Color(0xFF7C3AED)],
            ).createShader(const Rect.fromLTWH(0, 0, 60, 20)),
        ),
        unselectedTextStyle: const TextStyle(color: Colors.white70),
        onSegmentSelected: (i) =>
            onChanged(i == 0 ? MusicSource.local : MusicSource.online),
        indicatorSettings: LiquidGlassSettings(
          thickness: 30,
          blur: 3,
          refractiveIndex: 1.59,
        ),
        indicatorPinchStrength: 0.6,
        indicatorExpansion: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
      ),
    );
  }
}
