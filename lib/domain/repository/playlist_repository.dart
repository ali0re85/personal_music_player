import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';
import 'package:music_player/domain/entity/music_source.dart';

abstract class PlaylistRepository {
  Stream<List<PlaylistEntity>> watchPlaylists();

  Future<void> createPlaylist(String name);
  Future<void> renamePlaylist(int playlistId, String name);
  Future<void> deletePlaylist(int playlistId);

  Future<void> addTrack(int playlistId, MusicEntity track, MusicSource source);
  Future<void> removeTrack(int playlistId, int trackId, MusicSource source);
}
