// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudiosStreamModel _$AudiosStreamModelFromJson(Map<String, dynamic> json) =>
    AudiosStreamModel(url: json['url'] as String);

Map<String, dynamic> _$AudiosStreamModelToJson(AudiosStreamModel instance) =>
    <String, dynamic>{'url': instance.url};

const _$AudiosStreamModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'url': {'type': 'string'},
  },
  'required': ['url'],
};
