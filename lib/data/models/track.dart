import 'package:music_player/domain/entity/music_entity.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.uri,
    this.path,
    required this.duration,
    this.cover,
  });

  final int id;
  final String title;
  final String uri;
  final String? path;
  final int duration;
  final String? cover;

  MusicEntity toEntity() => MusicEntity(
    title: title,
    duration: duration,
    coverImageFile: cover,
    uri: uri,
    path: path,
    id: id,
    
  );
}
