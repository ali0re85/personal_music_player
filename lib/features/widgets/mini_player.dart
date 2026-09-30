import 'package:flutter/material.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/music_screen.dart';
import 'package:music_player/services/audio_service.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Track?>(
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

  final Track track;

  void _open(BuildContext context) {
    Navigator.push(context, musicScreenRoute());
  }

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;
    final controller = PlayerController.instance;
    final cs = Theme.of(context).colorScheme;

    Future<void> next() async {
      if (controller.tracks.length <= 1) {
        audio.seek(Duration.zero);
        return;
      }
      await controller.next();
    }

    Future<void> previous() async {
      if (controller.tracks.length <= 1 ||
          audio.position > const Duration(seconds: 3)) {
        audio.seek(Duration.zero);
        return;
      }
      await controller.previous();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      onVerticalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) < -300) _open(context);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _RoundButton(icon: Icons.skip_previous_rounded, onTap: previous),
                const SizedBox(width: 10),
                _RoundButton(icon: Icons.skip_next_rounded, onTap: next),
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

  final Track track;

  @override
  Widget build(BuildContext context) {
    final audio = AudioService.instance;

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
                  child: track.cover.image(
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                Icon(
                  playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.white,
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
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black38,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 24, color: Colors.black87),
        ),
      ),
    );
  }
}