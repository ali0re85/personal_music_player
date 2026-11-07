import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/track_cover.dart';

/// Shared blurred-cover backdrop used behind every glass surface.
///
/// Liquid glass can only refract what is behind it. A heavy blur plus a
/// near-black scrim leaves nothing to bend, so the glass reads as a flat grey
/// panel. This backdrop keeps colour and contrast alive instead.
class CoverBackdrop extends StatelessWidget {
  const CoverBackdrop({
    super.key,
    required this.track,
    this.scrimTop = 0.10,
    this.scrimBottom = 0.30,
  });

  final MusicEntity track;
  final double scrimTop;
  final double scrimBottom;

  // Saturation 1.5 colour matrix.
  static const List<double> _saturate = [
    1.3575,
    -0.2865,
    -0.0710,
    0,
    0,
    -0.1425,
    1.2135,
    -0.0710,
    0,
    0,
    -0.1425,
    -0.2865,
    1.4290,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix(_saturate),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: 22,
                  sigmaY: 22,
                  tileMode: TileMode.mirror,
                ),
                child: Transform.scale(
                  scale: 1.25,
                  child: TrackCover(
                    track: track,
                    fit: BoxFit.cover,
                    cacheWidth: 160,
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.appColors.scrimAt(scrimTop),
                    context.appColors.scrimAt(scrimBottom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
