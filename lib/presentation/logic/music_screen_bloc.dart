import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';  
import 'package:meta/meta.dart';
import 'package:music_player/controller/player_controller.dart'; 
import 'package:music_player/services/audio_service.dart';      

part 'music_screen_event.dart';
part 'music_screen_state.dart';

class MusicScreenBloc extends Bloc<MusicScreenEvent, MusicScreenState> {
  MusicScreenBloc() : super(MusicScreenLoaded()) {   // Initial شد Loaded
    on<LikeToggled>(_onLikeToggled);
    on<LoopToggled>(_onLoopToggled);
    on<SpeedCycled>(_onSpeedCycled);
    on<SeekDragged>(_onSeekDragged);
    on<SeekEnded>(_onSeekEnded);
    on<NextPressed>(_onNextPressed);
    on<PreviousPressed>(_onPreviousPressed);
    on<PlayPausePressed>(_onPlayPausePressed);
  }

  final AudioService _audioService = AudioService.instance;
  final PlayerController _controller = PlayerController.instance;

  void _onLikeToggled(LikeToggled event, Emitter<MusicScreenState> emit) {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    emit(current.copyWith(liked: !current.liked));
  }

  void _onLoopToggled(LoopToggled event, Emitter<MusicScreenState> emit) {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    final loopOne = !current.loopOne;
    _audioService.setLoopMode(loopOne ? LoopMode.one : LoopMode.off);

    emit(current.copyWith(loopOne: loopOne));
  }

  void _onSpeedCycled(SpeedCycled event, Emitter<MusicScreenState> emit) {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    final index = (current.speedIndex + 1) % MusicScreenLoaded.speeds.length;
    _audioService.setSpeed(MusicScreenLoaded.speeds[index]);

    emit(current.copyWith(speedIndex: index));
  }

  void _onSeekDragged(SeekDragged event, Emitter<MusicScreenState> emit) {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    emit(current.copyWith(isDragging: true, dragValue: event.value));
  }

  void _onSeekEnded(SeekEnded event, Emitter<MusicScreenState> emit) {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    _audioService.seek(Duration(milliseconds: event.value.round()));

    emit(current.copyWith(isDragging: false));
  }

  Future<void> _onNextPressed(
    NextPressed event,
    Emitter<MusicScreenState> emit,
  ) async {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    emit(current.copyWith(isDragging: false));
    await _controller.next();
  }

  Future<void> _onPreviousPressed(
    PreviousPressed event,
    Emitter<MusicScreenState> emit,
  ) async {
    final current = state;
    if (current is! MusicScreenLoaded) return;

    emit(current.copyWith(isDragging: false));
    await _controller.previous();
  }

  void _onPlayPausePressed(
    PlayPausePressed event,
    Emitter<MusicScreenState> emit,
  ) {
    if (_audioService.isPlaying) {
      _audioService.pause();
    } else {
      _audioService.play();
    }
  }
}