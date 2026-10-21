import 'package:json_annotation/json_annotation.dart';

part 'audios_stream_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudiosStreamModel {
  final String url;

  AudiosStreamModel({required this.url});

  factory AudiosStreamModel.fromJson(Map<String, dynamic> json) => _$AudiosStreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudiosStreamModelToJson(this);

  static const jsonSchema = _$AudiosStreamModelJsonSchema;
}