import 'package:music_player/domain/entity/music_entity.dart';

class PlaylistEntity {
  final int id;
  final String name;
  final List<MusicEntity> tracks;
  final DateTime createdAt;

  PlaylistEntity({
    required this.id,
    required this.name,
    required this.tracks,
    required this.createdAt,
  });
}
