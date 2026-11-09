part of 'playlists_bloc.dart';

@immutable
sealed class PlaylistsState {}

final class PlaylistsInitial extends PlaylistsState {}

final class PlaylistsSuccess extends PlaylistsState {
  final List<PlaylistEntity> playlists;

  PlaylistsSuccess(this.playlists);
}

final class PlaylistsError extends PlaylistsState {
  final String message;

  PlaylistsError(this.message);
}
