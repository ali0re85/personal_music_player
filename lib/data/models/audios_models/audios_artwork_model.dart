import 'package:json_annotation/json_annotation.dart';

part 'audios_artwork_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudioArtworkModel {
  @JsonKey(name:'480x480')
  final String url;
  AudioArtworkModel({required this.url});

  factory AudioArtworkModel.fromJson(Map<String, dynamic> json) => _$AudioArtworkModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudioArtworkModelToJson(this);

  static const jsonSchema = _$AudioArtworkModelJsonSchema;
}