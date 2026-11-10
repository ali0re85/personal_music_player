import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/domain/entity/playlist_entity.dart';
import 'package:music_player/domain/repository/playlist_repository.dart';
import 'package:music_player/domain/entity/music_source.dart';

part 'playlists_event.dart';
part 'playlists_state.dart';

class PlaylistsBloc extends Bloc<PlaylistsEvent, PlaylistsState> {
  final PlaylistRepository _repository;

  PlaylistsBloc(this._repository) : super(PlaylistsInitial()) {
    on<PlaylistsStarted>(_onStarted);
    on<PlaylistCreated>(_onCreated);
    on<PlaylistRenamed>(_onRenamed);
    on<PlaylistDeleted>(_onDeleted);
    on<PlaylistTrackAdded>(_onTrackAdded);
    on<PlaylistTrackRemoved>(_onTrackRemoved);
  }

  Future<void> _onStarted(
    PlaylistsStarted event,
    Emitter<PlaylistsState> emit,
  ) {
    return emit.forEach<List<PlaylistEntity>>(
      _repository.watchPlaylists(),
      onData: (playlists) => PlaylistsSuccess(playlists),
      onError: (error, stackTrace) {
        debugPrint('Playlists stream error: $error');
        return PlaylistsError(error.toString());
      },
    );
  }

  Future<void> _onCreated(
    PlaylistCreated event,
    Emitter<PlaylistsState> emit,
  ) async {
    await _repository.createPlaylist(event.name);
  }

  Future<void> _onRenamed(
    PlaylistRenamed event,
    Emitter<PlaylistsState> emit,
  ) async {
    await _repository.renamePlaylist(event.playlistId, event.name);
  }

  Future<void> _onDeleted(
    PlaylistDeleted event,
    Emitter<PlaylistsState> emit,
  ) async {
    await _repository.deletePlaylist(event.playlistId);
  }

  Future<void> _onTrackAdded(
    PlaylistTrackAdded event,
    Emitter<PlaylistsState> emit,
  ) async {
    _repository.addTrack(event.playlistId, event.track, event.source);
  }

  Future<void> _onTrackRemoved(
    PlaylistTrackRemoved event,
    Emitter<PlaylistsState> emit,
  ) async {
    _repository.removeTrack(event.playlistId, event.trackId, event.source);
  }
}
