// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audios_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudiosTrackModel _$AudiosTrackModelFromJson(
  Map<String, dynamic> json,
) => AudiosTrackModel(
  title: json['title'] as String,
  stream: AudiosStreamModel.fromJson(json['stream'] as Map<String, dynamic>),
  artwork: AudioArtworkModel.fromJson(json['artwork'] as Map<String, dynamic>),
  duration: (json['duration'] as num).toInt(),
  trackId: (json['track_id'] as num).toInt(),
);

Map<String, dynamic> _$AudiosTrackModelToJson(AudiosTrackModel instance) =>
    <String, dynamic>{
      'track_id': instance.trackId,
      'title': instance.title,
      'stream': instance.stream,
      'artwork': instance.artwork,
      'duration': instance.duration,
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
  },
  'required': ['track_id', 'title', 'stream', 'artwork', 'duration'],
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
  },
};
