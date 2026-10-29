import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/services/cover_service.dart';

class TrackCover extends StatelessWidget {
  const TrackCover({
    super.key,
    required this.track,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final MusicEntity track;
  final double? width;
  final double? height;
  final BoxFit fit;

  Widget _fallback() {
    return Assets.icons.cover.image(width: width, height: height, fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = track.coverImageUrl;
    if (coverUrl != null) {
      return Image.network(
        coverUrl,
        cacheWidth: 800,
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }
    return FutureBuilder<Uint8List?>(
      key: ValueKey(track.id),
      future: CoverService.instance.getCover(track),
      builder: (context, snapshot) {
        final bytes = snapshot.data;

        if (bytes == null) return _fallback();

        return Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          cacheWidth: 800,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _fallback(),
        );
      },
    );
  }
}
