import 'package:flutter/material.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo({
    super.key,
    required this.track,
    required this.hasError,
  });

  final MusicEntity track;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Column(
          key: ValueKey(track.id),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              track.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              hasError ? 'Could not load this track.' : (track.artist ?? ''),
              style: text.bodySmall?.copyWith(
                fontSize: 13,
                color: hasError ? colors.error : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
