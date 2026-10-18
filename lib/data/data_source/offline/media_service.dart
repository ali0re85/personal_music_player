import 'package:media_manager/media_manager.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/data/models/track_pagination_model.dart';

class MediaService {
  final MediaManager _mediaManager = MediaManager();

  Future<TrackPaginationModel> getSongs({
    required int page,
    required int perPage,
  }) async {
    final granted = await _mediaManager.requestStoragePermission();

    if (!granted) {
      throw StateError('Storage permission denied');
    }

    // Get the total number of audio files.
    final totalCount = await _mediaManager.getMediaCount(type: MediaType.audio);

    const pageSize = 100;
    final pageCount = (totalCount / pageSize).ceil();

    if (totalCount == 0) {
      return TrackPaginationModel(
        items: [],
        page: page,
        perPage: perPage,
        count: totalCount,
        pageCount: pageCount,
      );
    }

    final tracks = <Track>[];

    // Fetch all pages instead of loading only the first 100 songs.
    // for (var page = 0; page < pageCount; page++) {

    //   if (mediaItems.isEmpty) {
    //     break;
    //   }

    // }

    final mediaItems = await _mediaManager.getMediaPage(
      type: MediaType.audio,
      page: page,
      pageSize: pageSize,
    );

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

    return TrackPaginationModel(
      items: tracks,
      page: page,
      perPage: perPage,
      count: totalCount,
      pageCount: pageCount,
    );
  }
}
