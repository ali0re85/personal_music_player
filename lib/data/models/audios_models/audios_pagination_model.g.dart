// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudiosPaginationModel _$AudiosPaginationModelFromJson(
  Map<String, dynamic> json,
) => AudiosPaginationModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => AudiosTrackModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AudiosPaginationModelToJson(
  AudiosPaginationModel instance,
) => <String, dynamic>{'data': instance.data};

const _$AudiosPaginationModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'data': {
      'type': 'array',
      'items': {r'$ref': r'#/$defs/AudiosTrackModel'},
    },
  },
  'required': ['data'],
  r'$defs': {
    'AudiosStreamModel': {
      'type': 'object',
      'properties': {
        'url': {'type': 'string'},
      },
      'required': ['url'],
    },
    'AudioArtworkModel': {
      'type': 'object',
      'properties': {
        '480x480': {'type': 'string'},
      },
      'required': ['480x480'],
    },
    'AudiosUserModel': {
      'type': 'object',
      'properties': {
        'name': {'type': 'string'},
      },
      'required': ['name'],
    },
    'AudiosTrackModel': {
      'type': 'object',
      'properties': {
        'track_id': {'type': 'integer'},
        'title': {'type': 'string'},
        'stream': {r'$ref': r'#/$defs/AudiosStreamModel'},
        'artwork': {r'$ref': r'#/$defs/AudioArtworkModel'},
        'duration': {'type': 'integer'},
        'user': {r'$ref': r'#/$defs/AudiosUserModel'},
      },
      'required': [
        'track_id',
        'title',
        'stream',
        'artwork',
        'duration',
        'user',
      ],
    },
  },
};
