import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';

Future<int?> showPlaylistPicker(
  BuildContext context,
  List<PlaylistEntity> playlists,
) async {
  if (playlists.isEmpty) {
    await GlassDialog.show<void>(
      context: context,
      title: 'No playlists yet',
      message: 'Create a playlist first.',
      actions: [
        GlassDialogAction(
          label: 'OK',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
    return null;
  }

  return GlassDialog.show<int>(
    context: context,
    title: 'Add to playlist',
    barrierDismissible: true,
    content: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 260),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final p in playlists)
            ListTile(
              title: Text(p.name, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${p.tracks.length} Tracks',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    ),
    actions: [
      GlassDialogAction(
        label: 'Cancel',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ],
  );
}
