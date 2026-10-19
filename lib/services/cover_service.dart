import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:music_player/domain/entity/music_entity.dart';

/// کاور آهنگ‌ها رو از تگ‌های داخل خود فایل (ID3 و ...) می‌خونه.
/// نتیجه کش میشه که با اسکرول لیست، هر فایل فقط یک بار خونده بشه.
class CoverService {
  CoverService._();

  static final CoverService instance = CoverService._();

  final Map<int, Future<Uint8List?>> _cache = {};

  /// بایت‌های عکس کاور، یا null اگه آهنگ کاور نداشت.
  Future<Uint8List?> getCover(MusicEntity track) {
    return _cache.putIfAbsent(track.id, () => _read(track));
  }

  Future<Uint8List?> _read(MusicEntity track) async {
    final path = track.path;
    if (path == null || path.isEmpty) return null;

    try {
      final file = File(path);
      if (!await file.exists()) return null;

      final metadata = readMetadata(file, getImage: true);
      if (metadata.pictures.isEmpty) return null;

      return metadata.pictures.first.bytes;
    } catch (e) {
      debugPrint('⚠️ Could not read cover for "${track.title}": $e');
      return null;
    }
  }
}