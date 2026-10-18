import 'package:flutter/material.dart';
import 'package:music_player/data/models/track.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo({
    super.key,
    required this.track,
    required this.hasError,
  });

  final Track track;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              hasError ? 'Could not load this track.' : track.uri,
              style: TextStyle(
                color: hasError ? Colors.redAccent : Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}