import 'package:media_manager/media_manager.dart';
import 'package:music_player/data/models/track.dart';

class MediaService {
  final MediaManager _mediaManager = MediaManager();

  Future<List<Track>> getSongs() async {
    final granted = await _mediaManager.requestStoragePermission();

    if (!granted) {
      throw StateError('Storage permission denied');
    }

    // Get the total number of audio files.
    final totalCount = await _mediaManager.getMediaCount(type: MediaType.audio);

    if (totalCount == 0) {
      return [];
    }

    const pageSize = 100;
    final pageCount = (totalCount / pageSize).ceil();

    final tracks = <Track>[];

    // Fetch all pages instead of loading only the first 100 songs.
    for (var page = 0; page < pageCount; page++) {
      final mediaItems = await _mediaManager.getMediaPage(
        type: MediaType.audio,
        page: page,
        pageSize: pageSize,
      );

      if (mediaItems.isEmpty) {
        break;
      }

      tracks.addAll(
        mediaItems.map(
          (item) => Track(
            id: item.id,
            title: item.name,
            uri: item.uri,
            path: item.path,
            duration: item.duration,
          ),
        ),
      );
    }

    return tracks;
  }
}
