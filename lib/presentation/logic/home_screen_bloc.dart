import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/domain/repository/music_repository.dart';
import 'package:music_player/presentation/logic/music_source.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final MusicRepository offlineRepository;
  final MusicRepository onlineRepository;
  String? _query;
  MusicSource _source = MusicSource.local;

  HomeScreenBloc({
    required this.offlineRepository,
    required this.onlineRepository,
  }) : super(HomeScreenInitial(source: MusicSource.local)) {
    on<HomeScreenSongsRequested>((event, emit) async {
      await _load(emit);
    });

    on<HomeScreenNextPageRequested>((event, emit) async {
      await _loadNextPage(emit);
    });
    on<HomeScreenSearchChanged>(
      (event, emit) async {
        final text = event.query.trim();
        final newQuery = text.isEmpty ? null : text;

        if (newQuery == _query) return; 

        _query = newQuery;
        await _load(emit);
      },
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 400)).switchMap(mapper),
    );
    on<HomeScreenSourceChanged>(
      (event, emit) async {
        if (event.source == _source) return;
        _source = event.source;
        await _load(emit);
      },
      transformer: (events, mapper) =>
          events.distinct((a, b) => a.source == b.source).switchMap(mapper),
    );
  }

  Future<void> _load(Emitter<HomeScreenState> emit) async {
    emit(HomeScreenLoading(source: _source));

    try {
      final result = await _repository.getMusic(
        page: 0,
        perPage: 100,
        query: _query,
      );
      final tracks = result.items;

      if (tracks.isEmpty) {
        emit(HomeScreenEmpty(source: _source));
      } else {
        emit(
          HomeScreenSuccess(
            totalCount: result.count,
            tracks,
            page: 0,
            hasMore: result.hasMore,
            source: _source,
          ),
        );
      }
    } catch (error) {
      emit(HomeScreenError(error.toString(), source: _source));
    }
  }

  Future<void> _loadNextPage(Emitter<HomeScreenState> emit) async {
    final current = state;

    if (current is! HomeScreenSuccess) return;

    if (!current.hasMore || current.isLoadingMore) return;

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.page + 1;
      final result = await _repository.getMusic(
        page: nextPage,
        perPage: 100,
        query: _query,
      );

      emit(
        current.copyWith(
          tracks: [...current.tracks, ...result.items],
          page: nextPage,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  MusicRepository get _repository =>
      _source == MusicSource.local ? offlineRepository : onlineRepository;
}
