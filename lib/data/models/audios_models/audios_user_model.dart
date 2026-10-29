import 'package:json_annotation/json_annotation.dart';

part 'audios_user_model.g.dart';

@JsonSerializable(createJsonSchema: true)
class AudiosUserModel {
  final String name;

  AudiosUserModel({required this.name});

  factory AudiosUserModel.fromJson(Map<String, dynamic> json) =>
      _$AudiosUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AudiosUserModelToJson(this);

  static const jsonSchema = _$AudiosUserModelJsonSchema;
}
