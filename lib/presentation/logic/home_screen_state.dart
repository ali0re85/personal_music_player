part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenState {}

final class HomeScreenInitial extends HomeScreenState {}

final class HomeScreenLoading extends HomeScreenState {}

final class HomeScreenSuccess extends HomeScreenState {
  final List<Track> tracks;

  HomeScreenSuccess(this.tracks);
}

final class HomeScreenEmpty extends HomeScreenState {}

final class HomeScreenError extends HomeScreenState {
  final String errorMessage;

  HomeScreenError(this.errorMessage);
}
