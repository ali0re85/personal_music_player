import 'package:flutter/widgets.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/gen/assets.gen.dart';

extension TintedSvg on SvgGenImage {
  /// آیکون SVG با رنگ فعلی تم (onMedia)، که روی کاور تیره/روشن دیده بشه.
  Widget tinted(BuildContext context, {double? width, double? height}) {
    return svg(
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(context.appColors.onMedia, BlendMode.srcIn),
    );
  }
}
