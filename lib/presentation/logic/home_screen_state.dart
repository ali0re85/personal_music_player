part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenState {}

final class HomeScreenInitial extends HomeScreenState {}

final class HomeScreenLoading extends HomeScreenState {}

final class HomeScreenSuccess extends HomeScreenState {
  final List<Track> tracks;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  HomeScreenSuccess(
    this.tracks, {
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  HomeScreenSuccess copyWith({
    List<Track>? tracks,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return HomeScreenSuccess(
      tracks ?? this.tracks,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class HomeScreenEmpty extends HomeScreenState {}

final class HomeScreenError extends HomeScreenState {
  final String errorMessage;

  HomeScreenError(this.errorMessage);
}
