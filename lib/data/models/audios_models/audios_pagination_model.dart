import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/data/models/audios_models/audios_track_model.dart';
import 'package:music_player/domain/entity/music_pagination_entity.dart';

part 'audios_pagination_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudiosPaginationModel {
  final List<AudiosTrackModel> data;

  AudiosPaginationModel({required this.data});

  factory AudiosPaginationModel.fromJson(Map<String, dynamic> json) =>
      _$AudiosPaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudiosPaginationModelToJson(this);

  static const jsonSchema = _$AudiosPaginationModelJsonSchema;

  MusicPaginationEntity toEntity() => MusicPaginationEntity(
    items: data.where((e) => e.stream != null).map((e) => e.toEntity()).toList(),
    page: 1,
    perPage: 100,
    count: 100000,
    pageCount: 1000,
  );
}
