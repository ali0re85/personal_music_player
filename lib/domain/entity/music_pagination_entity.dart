import 'package:music_player/domain/entity/music_entity.dart';

class MusicPaginationEntity {
  final List<MusicEntity> items;
  final int page;
  final int perPage;
  final int count;

  new({required this.items, required this.page, required this.perPage, required this.count});
}