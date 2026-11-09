import 'package:drift/drift.dart';

class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class PlaylistTracks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get playlistId =>
      integer().references(Playlists, #id, onDelete: KeyAction.cascade)();

  IntColumn get trackId => integer()();
  TextColumn get source => text()();

  TextColumn get title => text()();
  TextColumn get artist => text().nullable()();
  IntColumn get duration => integer()();

  TextColumn get url => text().nullable()();
  TextColumn get uri => text().nullable()();
  TextColumn get path => text().nullable()();

  TextColumn get coverImageUrl => text().nullable()();
  TextColumn get coverImageFile => text().nullable()();

  IntColumn get position => integer()();
}
