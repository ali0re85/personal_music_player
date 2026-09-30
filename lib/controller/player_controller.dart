import 'package:flutter/foundation.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerController {
  PlayerController._();

  static final PlayerController instance = PlayerController._();

  final AudioService _audioService = AudioService.instance;

  final List<Track> _tracks = [
    Track(
      id: 'maleficent_001',
      title: 'Powerful fairy living in the moors',
      artist: 'Maleficent',
      source: Assets.icons.imagineDragonsTakeItEasy,
      cover: Assets.icons.cover,
    ),
  ];

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Track? _currentTrack;
  Track? get currentTrack => _currentTrack;

  /// مینی پلیر به این گوش میده. null یعنی هنوز آهنگی انتخاب نشده.
  final ValueNotifier<Track?> currentTrackNotifier = ValueNotifier(null);

  List<Track> get tracks => List.unmodifiable(_tracks);

  Future<void> loadTrack(Track track, {bool autoPlay = true}) async {
    final index = _tracks.indexWhere((t) => t.id == track.id);
    if (index != -1) _currentIndex = index;

    _currentTrack = track;
    currentTrackNotifier.value = track;

    await _audioService.loadTrack(track, autoPlay: autoPlay);
  }

  void play() => _audioService.play();
  void pause() => _audioService.pause();
  void seek(Duration position) => _audioService.seek(position);

  Future<void> next() async {
    if (_tracks.isEmpty) return;
    final nextIndex = (_currentIndex + 1) % _tracks.length;
    await loadTrack(_tracks[nextIndex]);
  }

  Future<void> previous() async {
    if (_tracks.isEmpty) return;
    final previousIndex = (_currentIndex - 1 + _tracks.length) % _tracks.length;
    await loadTrack(_tracks[previousIndex]);
  }
}