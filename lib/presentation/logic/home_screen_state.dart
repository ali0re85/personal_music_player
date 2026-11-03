part of 'home_screen_bloc.dart';

@immutable
sealed class HomeScreenState {
  final MusicSource source;
 const HomeScreenState({required this.source});
}

final class HomeScreenInitial extends HomeScreenState {
  const HomeScreenInitial({required super.source});
}

final class HomeScreenLoading extends HomeScreenState {
  const HomeScreenLoading({required super.source});
}

final class HomeScreenSuccess extends HomeScreenState {
  final List<MusicEntity> tracks;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final int? totalCount;

  const HomeScreenSuccess(
    this.tracks, {
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
   this.totalCount,
   required super.source
  });

  HomeScreenSuccess copyWith({
    List<MusicEntity>? tracks,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    int? totalCount,
  }) {
    return HomeScreenSuccess(
      tracks ?? this.tracks,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalCount: totalCount ?? this.totalCount,
      source: source
    );
  }
}

final class HomeScreenEmpty extends HomeScreenState {
  const HomeScreenEmpty({required super.source});
}

final class HomeScreenError extends HomeScreenState {
  final String errorMessage;

  const HomeScreenError( this.errorMessage,{required super.source});
}
