// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudiosTrackModel _$AudiosTrackModelFromJson(Map<String, dynamic> json) =>
    AudiosTrackModel(
      title: json['title'] as String,
      stream: json['stream'] == null
          ? null
          : AudiosStreamModel.fromJson(json['stream'] as Map<String, dynamic>),
      artwork: json['artwork'] == null
          ? null
          : AudioArtworkModel.fromJson(json['artwork'] as Map<String, dynamic>),
      duration: (json['duration'] as num).toInt(),
      trackId: (json['track_id'] as num).toInt(),
      user: json['user'] == null
          ? null
          : AudiosUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AudiosTrackModelToJson(AudiosTrackModel instance) =>
    <String, dynamic>{
      'track_id': instance.trackId,
      'title': instance.title,
      'stream': instance.stream,
      'artwork': instance.artwork,
      'duration': instance.duration,
      'user': instance.user,
    };

const _$AudiosTrackModelJsonSchema = {
  r'$schema': 'https://json-schema.org/draft/2020-12/schema',
  'type': 'object',
  'properties': {
    'track_id': {'type': 'integer'},
    'title': {'type': 'string'},
    'stream': {r'$ref': r'#/$defs/AudiosStreamModel'},
    'artwork': {r'$ref': r'#/$defs/AudioArtworkModel'},
    'duration': {'type': 'integer'},
    'user': {r'$ref': r'#/$defs/AudiosUserModel'},
  },
  'required': ['track_id', 'title', 'stream', 'artwork', 'duration', 'user'],
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
  },
};
