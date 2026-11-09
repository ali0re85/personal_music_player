import 'package:get_it/get_it.dart';
import 'package:music_player/data/database/app_database.dart';
import 'package:music_player/data/repository/music_repository_offline.dart';
import 'package:music_player/data/repository/music_repository_online.dart';
import 'package:music_player/domain/repository/music_repository.dart';
import 'package:music_player/domain/repository/playlist_repository.dart';
import 'package:music_player/data/repository/playlist_repository_impl.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryOnline(),
    instanceName: 'online',
  );
  locator.registerLazySingleton<MusicRepository>(
    () => MusicRepositoryOffline(),
    instanceName: 'offline',
  );
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());
  locator.registerLazySingleton<PlaylistRepository>(
    () => PlaylistRepositoryImpl(locator<AppDatabase>()),
  );
}
