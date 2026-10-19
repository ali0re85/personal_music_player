import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/domain/repository/music_repository.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {

  final MusicRepository musicRepository;

  HomeScreenBloc({required this.musicRepository}) : super(HomeScreenInitial()) {
    on<HomeScreenSongsRequested>((event, emit) async {
      await _load(emit);
    });

    on<HomeScreenNextPageRequested>((event, emit) async {
      await _loadNextPage(emit);
    });
  }

  Future<void> _load(Emitter<HomeScreenState> emit) async {
    emit(HomeScreenLoading());

    try {
      final result = await musicRepository.getMusic(page: 0, perPage: 100);
      final tracks = result.items;

      if (tracks.isEmpty) {
        emit(HomeScreenEmpty());
      } else {
        emit(
          HomeScreenSuccess(
            totalCount: result.count,
            tracks,
            page: 0,
            hasMore: result.page < result.pageCount - 1,
          ),
        );
      }
    } catch (error) {
      emit(HomeScreenError(error.toString()));
    }
  }

  Future<void> _loadNextPage(Emitter<HomeScreenState> emit) async {
    final current = state;

    if (current is! HomeScreenSuccess) return;

    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.page + 1;
      final result = await musicRepository.getMusic(page: nextPage, perPage: 100);

      emit(
        current.copyWith(
          tracks: [...current.tracks, ...result.items],
          page: nextPage,
          hasMore: nextPage < result.pageCount - 1,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}
