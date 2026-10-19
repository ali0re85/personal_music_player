import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/services/audio_service.dart';

/// تنها منبع حقیقت برای «لیست آهنگ‌ها» و «آهنگ فعلی».
/// هم صفحه‌ی پلیر و هم مینی‌پلیر از همین استفاده می‌کنن.
class PlayerController {
  PlayerController._() {
    // وقتی آهنگ تموم شد برو آهنگ بعدی (حتی اگه صفحه‌ی پلیر بسته باشه)
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

  /// مینی‌پلیر و صفحه‌ی پلیر به این گوش میدن. null یعنی هنوز آهنگی انتخاب نشده.
  final ValueNotifier<MusicEntity?> currentTrackNotifier = ValueNotifier(null);
  MusicEntity? get currentTrack => currentTrackNotifier.value;

  /// true یعنی لود آهنگ فعلی با خطا مواجه شد
  final ValueNotifier<bool> hasError = ValueNotifier(false);

  /// لیست آهنگ‌ها رو ست می‌کنه و آهنگ [index] رو پخش می‌کنه.
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

    await _playIndex((_currentIndex + 1) % _tracks.length);
  }

  Future<void> previous() async {
    if (_tracks.isEmpty) return;

    // اگه بیشتر از ۳ ثانیه از آهنگ گذشته یا فقط یه آهنگ داریم، از اول پخش کن
    if (_tracks.length == 1 ||
        _audioService.position > const Duration(seconds: 3)) {
      _audioService.seek(Duration.zero);
      return;
    }

    await _playIndex((_currentIndex - 1 + _tracks.length) % _tracks.length);
  }
}