import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:music_player/data/database/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Playlists, PlaylistTracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'nava_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
