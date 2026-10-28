import 'package:get_it/get_it.dart';
import 'package:music_player/data/repository/music_repository_online.dart';
import 'package:music_player/domain/repository/music_repository.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerSingleton<MusicRepository>(MusicRepositoryOnline());
}