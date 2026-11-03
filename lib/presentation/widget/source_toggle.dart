import 'package:flutter/material.dart';
import 'package:music_player/presentation/logic/music_source.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final isLocal = selected == MusicSource.local;

    return Container(
      width: 140,
      height: 36,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: isLocal ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(MusicSource.local),
                  child: Center(
                    child: Text(
                      'Local',
                      style: TextStyle(
                        color: isLocal ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(MusicSource.online),
                  child: Center(
                    child: Text(
                      'Online',
                      style: TextStyle(
                        color: !isLocal ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
