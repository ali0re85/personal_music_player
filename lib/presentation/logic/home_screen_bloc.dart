import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/services/media_service.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenSongsRequested>((event, emit) async {
      await _load(emit);
    });
  }

  final MediaService mediaService = MediaService();

  Future<void> _load(Emitter<HomeScreenState> emit) async {
    emit(HomeScreenLoading());

    try {
      final tracks = await mediaService.getSongs();

      if (tracks.isEmpty) {
        emit(HomeScreenEmpty());
      } else {
        emit(HomeScreenSuccess(tracks));
      }
    } catch (error) {
      emit(HomeScreenError(error.toString()));
    }
  }
}
