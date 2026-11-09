import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';

Future<int?> showPlaylistPicker(
  BuildContext context,
  List<PlaylistEntity> playlists,
) {
  return showModalBottomSheet<int>(
    context: context,
    builder: (context) => SafeArea(
      child: playlists.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: Text('Create a playlist first'),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text('Add to playlist'),
                ),
                for (final p in playlists)
                  ListTile(
                    title: Text(p.name),
                    subtitle: Text('${p.tracks.length} Tracks'),
                    onTap: () => Navigator.pop(context, p.id),
                  ),
              ],
            ),
    ),
  );
}
