import 'package:media_manager/media_manager.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/data/models/track_pagination_model.dart';

class MediaService {
  final MediaManager _mediaManager = MediaManager();

  Future<TrackPaginationModel> getSongs({
    required int page,
    required int perPage,
    String? query,
  }) async {
    final granted = await _mediaManager.requestStoragePermission();

    if (!granted) {
      throw StateError('Storage permission denied');
    }

    // Get the total number of audio files.
    final totalCount = await _mediaManager.getMediaCount(type: MediaType.audio);

    final pageCount = (totalCount / perPage).ceil();

    if (totalCount == 0) {
      return TrackPaginationModel(
        items: [],
        page: page,
        perPage: perPage,
        count: totalCount,
        pageCount: pageCount,
      );
    }
    if (query != null && query.trim().isNotEmpty) {
      return _search(
        query: query,
        page: page,
        perPage: perPage,
        totalCount: totalCount,
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
      pageSize: perPage,
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

  Future<TrackPaginationModel> _search({
    required String query,
    required int page,
    required int perPage,
    required int totalCount,
  }) async {
    final allPages = (totalCount / perPage).ceil();
    final q = query.trim().toLowerCase();
    final matches = <Track>[];

    for (var p = 0; p < allPages; p++) {
      final items = await _mediaManager.getMediaPage(
        type: MediaType.audio,
        page: p,
        pageSize: perPage,
      );

      for (final item in items) {
        if (item.name.toLowerCase().contains(q)) {
          matches.add(
            Track(
              id: item.id,
              title: item.name,
              uri: item.uri,
              path: item.path,
              duration: item.duration,
            ),
          );
        }
      }
    }

    final pageCount = (matches.length / perPage).ceil();
    final pageItems = matches.skip(page * perPage).take(perPage).toList();

    return TrackPaginationModel(
      items: pageItems,
      page: page,
      perPage: perPage,
      count: matches.length,
      pageCount: pageCount,
    );
  }
}
