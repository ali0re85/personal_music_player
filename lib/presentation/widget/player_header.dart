import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/widgets/interactive/glass_button.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';
import 'package:music_player/presentation/widget/accent_builder.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({super.key});

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
              child: ClipOval(
                child: Assets.icons.profileImage.image(
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anjelina Joeli',
                style: text.titleSmall?.copyWith(fontSize: 16),
              ),
              Text('@anjelina_joeli', style: text.bodySmall),
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
