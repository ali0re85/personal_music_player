// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudiosUserModel _$AudiosUserModelFromJson(Map<String, dynamic> json) =>
    AudiosUserModel(name: json['name'] as String);

Map<String, dynamic> _$AudiosUserModelToJson(AudiosUserModel instance) =>
    <String, dynamic>{'name': instance.name};

const _$AudiosUserModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'name': {'type': 'string'},
  },
  'required': ['name'],
};
