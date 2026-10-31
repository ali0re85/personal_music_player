import 'package:music_player/data/data_source/offline/media_service.dart';
import 'package:music_player/data/models/track_pagination_model.dart';
import 'package:music_player/domain/entity/music_pagination_entity.dart';
import 'package:music_player/domain/repository/music_repository.dart';

class MusicRepositoryOffline implements MusicRepository {
  MediaService mediaService = MediaService();

  @override
  Future<MusicPaginationEntity> getMusic({
    required int page,
    required int perPage,
    String? query,
  }) async {
    final TrackPaginationModel trackPaginationModel = await mediaService
        .getSongs(page: page, perPage: perPage, query: query);
    return trackPaginationModel.toEntity();
  }
}
