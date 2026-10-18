import 'package:music_player/data/models/track.dart';
import 'package:music_player/domain/entity/music_pagination_entity.dart';

class TrackPaginationModel {
  final List<Track> items;
  final int page;
  final int perPage;
  final int count;
  final int pageCount;

  new({
    required this.items,
    required this.page,
    required this.perPage,
    required this.count,
    required this.pageCount,
  });

  MusicPaginationEntity toEntity() => MusicPaginationEntity(
    items: items.map((e) => e.toEntity()).toList(),
    page: page,
    perPage: perPage,
    count: count,
    pageCount: pageCount,
  );
}
