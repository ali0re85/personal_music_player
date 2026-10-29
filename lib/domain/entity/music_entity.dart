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
  });
}
