import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/widgets/interactive/glass_button.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/logic/music_screen/music_screen_bloc.dart';
import 'package:music_player/presentation/widget/accent_builder.dart';
import 'package:music_player/presentation/widget/flowing_wave.dart';
import 'package:music_player/presentation/widget/spinning_cover.dart';

class PlayerHeader extends StatelessWidget {
  final MusicEntity track;
  const PlayerHeader({super.key, required this.track});

  void _toggleLike(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<MusicScreenBloc>().add(LikeToggled());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        AccentBuilder(
          builder: (context, accent) {
            final hsl = HSLColor.fromColor(accent);
            final partner = hsl.withHue((hsl.hue + 60) % 360).toColor();

            return Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [accent, partner]),
              ),
              child: SpinningCover(track: track, size: 52),
            );
          },
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AccentBuilder(
                builder: (context, accent) => FlowingWave(color: accent),
              ),
              const SizedBox(height: 6),
              Text(
                track.url != null ? 'Online' : 'On this device',
                style: text.bodySmall,
              ),
            ],
          ),
        ),
        BlocBuilder<MusicScreenBloc, MusicScreenState>(
          builder: (context, state) {
            final liked = state is MusicScreenLoaded && state.liked;

            return GlassButton(
              width: 44,
              height: 44,
              onTap: () => _toggleLike(context),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  key: ValueKey(liked),
                  color: liked ? colors.liked : colors.onMedia,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
