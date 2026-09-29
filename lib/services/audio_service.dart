import 'package:just_audio/just_audio.dart';
import 'package:music_player/data/models/track.dart';

class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  final AudioPlayer player = AudioPlayer();

  Future<void> loadTrack(Track track, {bool autoPlay = true}) async {
    await player.setAsset(track.source);

    if (autoPlay) {
      player.play();
    }
  }

  Stream<bool> get playingStream => player.playingStream;

  Stream<Duration> get positionStream => player.positionStream;

  Stream<Duration?> get durationStream => player.durationStream;

  Stream<PlayerState> get playerStateStream => player.playerStateStream;

  void play() {
    player.play();
  }

  void pause() {
    player.pause();
  }

  void seek(Duration position) {
    player.seek(position);
  }

  void dispose() {
    player.dispose();
  }

  Future<void> setAsset(String asset) async {
    await player.setAsset(asset);
  }

  bool get isPlaying => player.playing;

  Duration get position => player.position;

  Future<void> setLoopMode(LoopMode mode) async {
    await player.setLoopMode(mode);
  }

  Future<void> setSpeed(double speed) async {
    await player.setSpeed(speed);
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> seekToStart() async {
    await player.seek(Duration.zero);
  }
}
