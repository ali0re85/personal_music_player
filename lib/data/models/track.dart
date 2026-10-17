
class Track {
  const Track({
    required this.id,
    required this.title,
    required this.uri,
    this.path,
    required this.duration,
    this.cover
    
  });

  final int id;
  final String title;
  final String uri;
  final String? path;
  final int duration;
  final String? cover;
}
