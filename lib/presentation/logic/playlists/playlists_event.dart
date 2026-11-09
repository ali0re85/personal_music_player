part of 'playlists_bloc.dart';

@immutable
sealed class PlaylistsEvent {}

final class PlaylistsStarted extends PlaylistsEvent {}

final class PlaylistCreated extends PlaylistsEvent {
  final String name;
  PlaylistCreated(this.name);
}

final class PlaylistRenamed extends PlaylistsEvent {
  final int playlistId;
  final String name;
  PlaylistRenamed(this.playlistId, this.name);
}

final class PlaylistDeleted extends PlaylistsEvent {
  final int playlistId;
  PlaylistDeleted(this.playlistId);
}

final class PlaylistTrackAdded extends PlaylistsEvent {
  final int playlistId;
  final MusicEntity track;
  final MusicSource source;
  PlaylistTrackAdded(this.playlistId, this.track, this.source);
}

final class PlaylistTrackRemoved extends PlaylistsEvent {
  final int playlistId;
  final int trackId;
  final MusicSource source;
  PlaylistTrackRemoved(this.playlistId, this.trackId, this.source);
}
