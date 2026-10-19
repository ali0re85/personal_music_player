part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenEvent {}

class HomeScreenSongsRequested extends HomeScreenEvent {}

class HomeScreenNextPageRequested extends HomeScreenEvent{}