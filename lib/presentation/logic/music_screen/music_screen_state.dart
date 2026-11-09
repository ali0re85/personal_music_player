part of 'music_screen_bloc.dart';

@immutable
sealed class MusicScreenState {}

final class MusicScreenInitial extends MusicScreenState {}

final class MusicScreenLoaded extends MusicScreenState {
  MusicScreenLoaded({
    this.liked = false,
    this.loopOne = false,
    this.speedIndex = 0,
    this.isDragging = false,
    this.dragValue = 0,
  });

  static const List<double> speeds = [1.0, 1.25, 1.5, 2.0, 0.75];

  final bool liked;
  final bool loopOne;
  final int speedIndex;

  final bool isDragging;

  final double dragValue;

  double get speed => speeds[speedIndex];

  MusicScreenLoaded copyWith({
    bool? liked,
    bool? loopOne,
    int? speedIndex,
    bool? isDragging,
    double? dragValue,
  }) {
    return MusicScreenLoaded(
      liked: liked ?? this.liked,
      loopOne: loopOne ?? this.loopOne,
      speedIndex: speedIndex ?? this.speedIndex,
      isDragging: isDragging ?? this.isDragging,
      dragValue: dragValue ?? this.dragValue,
    );
  }
}
