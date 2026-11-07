import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/accent_builder.dart';
import 'package:music_player/presentation/widget/track_cover.dart';
import 'package:music_player/presentation/widget/music_screen_route.dart';
import 'package:music_player/services/audio_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MusicEntity?>(
      valueListenable: PlayerController.instance.currentTrackNotifier,
      builder: (context, track, _) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          alignment: Alignment.bottomCenter,
          child: track == null
              ? const SizedBox(width: double.infinity)
              : _MiniPlayerCard(track: track),
        );
      },
    );
  }
}

class _MiniPlayerCard extends StatelessWidget {
  const _MiniPlayerCard({required this.track});

  final MusicEntity track;

  void _open(BuildContext context) {
    Navigator.push(context, musicScreenRoute());
  }

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < -300) _open(context);
      },
      child: GlassContainer(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        shape: LiquidRoundedSuperellipse(borderRadius: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AccentBuilder(
              builder: (context, accent) => Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _CoverPlayButton(track: track),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artist ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RoundButton(
                  icon: Icons.skip_previous_rounded,
                  onTap: controller.previous,
                ),
                const SizedBox(width: 10),
                _RoundButton(
                  icon: Icons.skip_next_rounded,
                  onTap: controller.next,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// کاور گرد که آیکن پلی/پاز روش هست و با کلیک، پخش رو کنترل می‌کنه.
class _CoverPlayButton extends StatelessWidget {
  const _CoverPlayButton({required this.track});

  final MusicEntity track;

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;
    final colors = context.appColors;

    return StreamBuilder<bool>(
      stream: audio.playingStream,
      initialData: audio.isPlaying,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        return GestureDetector(
          onTap: () => playing ? audio.pause() : audio.play(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: TrackCover(track: track, width: 56, height: 56),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.scrimAt(0.35),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: RepaintBoundary(child: _ProgressRing()),
                ),
                Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: AppColors.dark.onMedia,
                  size: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 30, color: context.appColors.onMedia),
    );
  }
}

/// حلقه دور کاور که همراه آهنگ پر میشه (مثل سیک‌بار، ولی فقط نمایشی).
class _ProgressRing extends StatelessWidget {
  const _ProgressRing();

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;
    final trackColor = context.appColors.track;

    return AccentBuilder(
      builder: (context, accent) => StreamBuilder<Duration?>(
        stream: audio.durationStream,
        initialData: audio.player.duration,
        builder: (context, durationSnap) {
          final totalMs = durationSnap.data?.inMilliseconds ?? 0;

          return StreamBuilder<Duration>(
            stream: audio.positionStream,
            initialData: audio.player.position,
            builder: (context, positionSnap) {
              final posMs = positionSnap.data?.inMilliseconds ?? 0;
              final progress = totalMs > 0
                  ? (posMs / totalMs).clamp(0.0, 1.0)
                  : 0.0;

              return CustomPaint(
                painter: _RingPainter(
                  progress: progress,
                  color: accent,
                  trackColor: trackColor,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  static const _stroke = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(_stroke / 2);

    // حلقه کم‌رنگ پس‌زمینه (کل مسیر)
    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..color = trackColor,
    );

    if (progress <= 0) return;

    // بخش پخش‌شده، از ساعت ۱۲ ساعت‌گرد
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor;
}
