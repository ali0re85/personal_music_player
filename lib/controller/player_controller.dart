import 'dart:async';
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/palette_service.dart';

class PlayerController {
  PlayerController._() {
    _audioService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_tracks.length > 1) {
          next();
        } else {
          _audioService.pause();
          _audioService.seek(Duration.zero);
        }
      }
    });
  }

  static final PlayerController instance = PlayerController._();

  final AudioService _audioService = AudioService.instance;

  List<MusicEntity> _tracks = [];
  List<MusicEntity> get tracks => List.unmodifiable(_tracks);

  int _currentIndex = -1;
  int get currentIndex => _currentIndex;

  bool lastMoveWasNext = true;

  final ValueNotifier<MusicEntity?> currentTrackNotifier = ValueNotifier(null);
  MusicEntity? get currentTrack => currentTrackNotifier.value;

  final ValueNotifier<Color?> accentNotifier = ValueNotifier(null);
  final ValueNotifier<bool> backdropIsLightNotifier = ValueNotifier(false);

  Future<void> _updateLook(MusicEntity track) async {
    final look = await PaletteService.instance.getLook(track);

    if (currentTrack?.id != track.id) return;

    debugPrint(
      '🎨 "${track.title}": accent=${look?.accent} light=${look?.isLight}',
    );
    accentNotifier.value = look?.accent;
    backdropIsLightNotifier.value = look?.isLight ?? false;
  }

  final ValueNotifier<bool> hasError = ValueNotifier(false);

  Future<void> setQueue(
    List<MusicEntity> tracks,
    int index, {
    bool autoPlay = true,
  }) async {
    _tracks = List.of(tracks);
    await _playIndex(index, autoPlay: autoPlay);
  }

  Future<void> _playIndex(int index, {bool autoPlay = true}) async {
    if (index < 0 || index >= _tracks.length) return;

    _currentIndex = index;
    final track = _tracks[index];

    hasError.value = false;
    currentTrackNotifier.value = track;
    unawaited(_updateLook(track));

    try {
      await _audioService.loadTrack(track, autoPlay: autoPlay);
    } catch (e) {
      debugPrint('❌ Failed to load track "${track.title}": $e');
      hasError.value = true;
    }
  }

  void play() => _audioService.play();
  void pause() => _audioService.pause();
  void seek(Duration position) => _audioService.seek(position);

  Future<void> next() async {
    if (_tracks.isEmpty) return;

    if (_tracks.length == 1) {
      _audioService.seek(Duration.zero);
      return;
    }
    lastMoveWasNext = true;
    await _playIndex((_currentIndex + 1) % _tracks.length);
  }

  Future<void> previous() async {
    if (_tracks.isEmpty) return;

    if (_tracks.length == 1 ||
        _audioService.position > const Duration(seconds: 3)) {
      _audioService.seek(Duration.zero);
      return;
    }
    lastMoveWasNext = false;
    await _playIndex((_currentIndex - 1 + _tracks.length) % _tracks.length);
  }
}
