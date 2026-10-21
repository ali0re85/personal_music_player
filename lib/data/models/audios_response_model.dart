import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/data/models/audios_track_model.dart';

part 'audios_response_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudiosResponseModel {
  @JsonKey(name: 'data')
  final List<AudiosTrackModel> items;
  AudiosResponseModel({required this.items});

  factory AudiosResponseModel.fromJson(Map<String, dynamic> json) => _$AudiosResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudiosResponseModelToJson(this);

  static const jsonSchema = _$AudiosResponseModelJsonSchema;
}