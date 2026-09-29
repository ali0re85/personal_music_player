import 'package:music_player/gen/assets.gen.dart';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.source,
    required this.cover,
  });

  final String id;
  final String title;
  final String artist;
  final String source;
  final AssetGenImage cover;
}
