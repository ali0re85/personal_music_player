import 'package:music_player/domain/entity/music_pagination_entity.dart';

abstract class MusicRepository {
  Future<MusicPaginationEntity> getMusic({required int page,required int perPage, String? query});
}