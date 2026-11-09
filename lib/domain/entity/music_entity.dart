import 'package:music_player/domain/entity/music_source.dart';

class MusicEntity {
  final String? coverImageFile;
  final String? coverImageUrl;
  final String title;
  final int duration;
  final String? uri;
  final String? url;
  final String? path;
  final int id;
  final String? artist;
  final MusicSource? source;
  MusicEntity({
    this.coverImageFile,
    this.coverImageUrl,
    required this.title,
    required this.duration,
    this.uri,
    this.url,
    this.path,
    required this.id,
    this.artist,
    this.source
  });
}
