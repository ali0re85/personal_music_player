import 'package:flutter/material.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/widget/accent_builder.dart';
import 'package:music_player/presentation/widget/track_cover.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({super.key, required this.track, required this.onTap});

  final MusicEntity track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MusicEntity?>(
      valueListenable: PlayerController.instance.currentTrackNotifier,
      builder: (context, current, _) {
        final isCurrent = current?.id == track.id;

        return isCurrent
            ? AccentBuilder(
                builder: (context, accent) => _tile(context, accent),
              )
            : _tile(context, null);
      },
    );
  }

  Widget _tile(BuildContext context, Color? accent) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(color: context.appColors.scrimAt(0.35), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: TrackCover(track: track, width: 56, height: 56),
        ),
      ),
      title: Text(
        track.title,
        style: accent == null
            ? null
            : TextStyle(color: accent, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(track.artist ?? ''),
    );
  }
}
