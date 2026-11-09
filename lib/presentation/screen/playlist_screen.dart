import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';
import 'package:music_player/presentation/logic/playlists/playlists_bloc.dart';
import 'package:music_player/presentation/widget/create_playlist_dialog.dart';
import 'package:music_player/presentation/widget/gradient_text.dart';
import 'package:music_player/presentation/widget/home_background.dart';
import 'package:music_player/presentation/widget/mini_player.dart';
import 'package:music_player/presentation/widget/music_screen_route.dart';
import 'package:music_player/presentation/widget/track_title.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key, required this.playlistId});

  final int playlistId;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      background: const HomeBackground(),
      statusBarStyle: GlassStatusBarStyle.light,
      bottomBar: const SafeArea(top: false, child: MiniPlayer()),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PlaylistsBloc, PlaylistsState>(
          builder: (context, state) {
            if (state is! PlaylistsSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            final playlist = state.playlists
                .where((p) => p.id == playlistId)
                .firstOrNull;
            if (playlist == null) return const SizedBox.shrink();

            final tracks = playlist.tracks;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    children: [
                      GlassButton(
                        width: 44,
                        height: 44,
                        iconSize: 20,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onTap: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientText(
                          playlist.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text('${tracks.length} Tracks'),
                      const SizedBox(width: 12),
                      GlassButton(
                        width: 44,
                        height: 44,
                        iconSize: 20,
                        icon: const Icon(Icons.more_horiz_rounded),
                        onTap: () => _showMenu(context, playlist),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: tracks.isEmpty
                      ? const Center(
                          child: Text('Long-press a song to add it here'),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom: 120 + MediaQuery.paddingOf(context).bottom,
                          ),
                          itemCount: tracks.length,
                          itemBuilder: (context, index) {
                            final track = tracks[index];

                            return TrackTile(
                              track: track,
                              onLongPress: () async {
                                final source = track.source;
                                if (source == null) return;

                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Remove from playlist?'),
                                    content: Text(track.title),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed != true || !context.mounted)
                                  return;

                                context.read<PlaylistsBloc>().add(
                                  PlaylistTrackRemoved(
                                    playlistId,
                                    track.id,
                                    source,
                                  ),
                                );
                              },
                              onTap: () {
                                final controller = PlayerController.instance;

                                if (controller.currentTrack?.id != track.id) {
                                  controller.setQueue(tracks, index);
                                }

                                Navigator.push(context, musicScreenRoute());
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context, PlaylistEntity playlist) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Rename'),
              onTap: () => Navigator.pop(sheetContext, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded),
              title: const Text('Delete playlist'),
              onTap: () => Navigator.pop(sheetContext, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;

    if (action == 'rename') {
      final name = await showRenamePlaylistDialog(context, playlist.name);
      if (name == null || !context.mounted) return;
      context.read<PlaylistsBloc>().add(PlaylistRenamed(playlist.id, name));
    } else if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Delete playlist?'),
          content: Text(playlist.name),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;

      context.read<PlaylistsBloc>().add(PlaylistDeleted(playlist.id));
      Navigator.pop(context);
    }
  }
}
