import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/services/cover_service.dart';

/// نتیجه تحلیل کاور: رنگ accent و اینکه بک‌گراند روشنه یا تیره.
class TrackLook {
  const TrackLook({this.accent, required this.isLight});

  final Color? accent;
  final bool isLight;
}

class PaletteService {
  PaletteService._();

  static final PaletteService instance = PaletteService._();

  // بالاتر = کاور باید روشن‌تر باشه تا متن تیره بشه.
  static const _lightThreshold = 0.4;
  // میزان اسکریم مشکی روی کاور بلور (تقریباً همون CoverBackdrop).
  static const _scrimAlpha = 0.2;

  final Map<int, Future<TrackLook?>> _cache = {};

  /// null یعنی کاور نداره یا خوندنش خطا داد.
  Future<TrackLook?> getLook(MusicEntity track) {
    return _cache.putIfAbsent(track.id, () => _analyze(track));
  }

  Future<ImageProvider?> _provider(MusicEntity track) async {
    final url = track.coverImageUrl;
    if (url != null) return NetworkImage(url);

    final bytes = await CoverService.instance.getCover(track);
    return bytes == null ? null : MemoryImage(bytes);
  }

  Future<TrackLook?> _analyze(MusicEntity track) async {
    try {
      final source = await _provider(track);
      if (source == null) return null;

      final image = ResizeImage(source, width: 100);
      final isLight = await _isLight(image);

      final scheme = await ColorScheme.fromImageProvider(
        provider: image,
        brightness: isLight ? Brightness.light : Brightness.dark,
      );

      return TrackLook(
        accent: _vivid(scheme.primary, isLight: isLight),
        isLight: isLight,
      );
    } catch (e) {
      debugPrint('⚠️ Could not analyze cover for "${track.title}": $e');
      return null;
    }
  }

  Future<ui.Image> _resolve(ImageProvider provider) {
    final completer = Completer<ui.Image>();
    final stream = provider.resolve(ImageConfiguration.empty);

    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        // clone می‌کنیم که کش تصویر رو dispose نکنه
        if (!completer.isCompleted) completer.complete(info.image.clone());
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

  /// میانگین رنگ کاور رو حساب می‌کنه و می‌گه بک‌گراند روشنه یا نه.
  Future<bool> _isLight(ImageProvider image) async {
    final decoded = await _resolve(image);

    try {
      final ByteData? data = await decoded.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      if (data == null) return false;

      final pixels = data.lengthInBytes ~/ 4;
      if (pixels == 0) return false;

      var r = 0.0, g = 0.0, b = 0.0;
      for (var i = 0; i < pixels; i++) {
        r += data.getUint8(i * 4);
        g += data.getUint8(i * 4 + 1);
        b += data.getUint8(i * 4 + 2);
      }

      final average = Color.fromARGB(
        255,
        (r / pixels).round(),
        (g / pixels).round(),
        (b / pixels).round(),
      );

      // بک‌گراند واقعی: کاور بلور + اسکریم مشکی
      final shown = Color.alphaBlend(
        Colors.black.withValues(alpha: _scrimAlpha),
        average,
      );

      return shown.computeLuminance() > _lightThreshold;
    } finally {
      decoded.dispose();
    }
  }

  /// رنگ Material رو جون‌دار می‌کنه؛ روی بک‌گراند روشن تیره‌ترش می‌کنه.
  Color _vivid(Color color, {required bool isLight}) {
    final hsl = HSLColor.fromColor(color);

    // کاور سیاه‌وسفید: رنگ خنثی رو بی‌خودی رنگی نکن.
    if (hsl.saturation < 0.1) return color;

    final minL = isLight ? 0.30 : 0.60;
    final maxL = isLight ? 0.45 : 0.72;

    return hsl
        .withSaturation((hsl.saturation * 1.25).clamp(0.55, 1.0))
        .withLightness(hsl.lightness.clamp(minL, maxL))
        .toColor();
  }
}
