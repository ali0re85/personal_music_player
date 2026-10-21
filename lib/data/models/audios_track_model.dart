import 'package:json_annotation/json_annotation.dart';
import 'package:music_player/data/models/audios_artwork_model.dart';
import 'package:music_player/data/models/audios_stream_model.dart';

part 'audios_track_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudiosTrackModel {
  final String title;
  final AudiosStreamModel stream;
  final AudioArtworkModel artwork;

  AudiosTrackModel({required this.title, required this.stream,required this.artwork});

  factory AudiosTrackModel.fromJson(Map<String, dynamic> json) => _$AudiosTrackModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudiosTrackModelToJson(this);

  static const jsonSchema = _$AudiosTrackModelJsonSchema;
}