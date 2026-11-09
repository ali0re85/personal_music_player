import 'package:drift/drift.dart';
import 'package:music_player/data/database/app_database.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';
import 'package:music_player/domain/repository/playlist_repository.dart';
import 'package:music_player/domain/entity/music_source.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final AppDatabase _db;

  PlaylistRepositoryImpl(this._db);

  @override
  Future<void> createPlaylist(String name) async {
    await _db.into(_db.playlists).insert(PlaylistsCompanion.insert(name: name));
  }

  @override
  Future<void> addTrack(
    int playlistId,
    MusicEntity track,
    MusicSource source,
  ) async {
    final rows = await (_db.select(
      _db.playlistTracks,
    )..where((t) => t.playlistId.equals(playlistId))).get();
    final exsits = rows.any(
      (r) => r.trackId == track.id && r.source == source.name,
    );
    if (exsits) return;
    final nextPosition =
        rows.fold<int>(-1, (m, r) => r.position > m ? r.position : m) + 1;
    await _db
        .into(_db.playlistTracks)
        .insert(
          PlaylistTracksCompanion.insert(
            playlistId: playlistId,
            trackId: track.id,
            source: source.name,
            title: track.title,
            duration: track.duration,
            position: nextPosition,
            artist: Value(track.artist),
            url: Value(track.url),
            uri: Value(track.uri),
            coverImageFile: Value(track.coverImageFile),
            coverImageUrl: Value(track.coverImageUrl),
            path: Value(track.path),
          ),
        );
  }

  @override
  Future<void> deletePlaylist(int playlistId) async {
    await (_db.delete(
      _db.playlists,
    )..where((t) => t.id.equals(playlistId))).go();
  }

  @override
  Future<void> removeTrack(
    int playlistId,
    int trackId,
    MusicSource source,
  ) async {
    await (_db.delete(_db.playlistTracks)..where(
          (t) =>
              t.playlistId.equals(playlistId) &
              t.trackId.equals(trackId) &
              t.source.equals(source.name),
        ))
        .go();
  }

  @override
  Future<void> renamePlaylist(int playlistId, String name) async {
    await (_db.update(_db.playlists)..where((t) => t.id.equals(playlistId)))
        .write(PlaylistsCompanion(name: Value(name)));
  }

  @override
  Stream<List<PlaylistEntity>> watchPlaylists() {
    final query =
        _db.select(_db.playlists).join([
          leftOuterJoin(
            _db.playlistTracks,
            _db.playlistTracks.playlistId.equalsExp(_db.playlists.id),
          ),
        ])..orderBy([
          OrderingTerm.desc(_db.playlists.id),
          OrderingTerm.asc(_db.playlistTracks.position),
        ]);

    return query.watch().map((rows) {
      final playlists = <int, Playlist>{};
      final tracks = <int, List<MusicEntity>>{};

      for (final row in rows) {
        final playlist = row.readTable(_db.playlists);
        final track = row.readTableOrNull(_db.playlistTracks);

        playlists[playlist.id] = playlist;
        final list = tracks.putIfAbsent(playlist.id, () => []);
        if (track != null) list.add(_toMusicEntity(track));
      }

      return playlists.values
          .map(
            (p) => PlaylistEntity(
              id: p.id,
              name: p.name,
              tracks: tracks[p.id]!,
              createdAt: p.createdAt,
            ),
          )
          .toList();
    });
  }

  MusicEntity _toMusicEntity(PlaylistTrack row) {
    return MusicEntity(
      id: row.trackId,
      title: row.title,
      duration: row.duration,
      artist: row.artist,
      coverImageFile: row.coverImageFile,
      coverImageUrl: row.coverImageUrl,
      path: row.path,
      uri: row.uri,
      url: row.url,
      source: MusicSource.values.byName(row.source),
    );
  }
}
