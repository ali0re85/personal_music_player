part of 'music_screen_bloc.dart';

@immutable
sealed class MusicScreenEvent {}

class LikeToggled extends MusicScreenEvent {}

class LoopToggled extends MusicScreenEvent {}

class SpeedCycled extends MusicScreenEvent {}

class SeekDragged extends MusicScreenEvent {
  SeekDragged(this.value);

  final double value;
}

class SeekEnded extends MusicScreenEvent {
  SeekEnded(this.value);

  final double value;
}

class NextPressed extends MusicScreenEvent {}

class PreviousPressed extends MusicScreenEvent {}

class PlayPausePressed extends MusicScreenEvent {}