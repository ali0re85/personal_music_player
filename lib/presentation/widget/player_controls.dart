import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/presentation/logic/music_screen/music_screen_bloc.dart';
import 'package:music_player/presentation/widget/accent_builder.dart';
import 'package:music_player/presentation/widget/play_pause_button.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  void _next(BuildContext context) {
    HapticFeedback.selectionClick();
    context.read<MusicScreenBloc>().add(NextPressed());
  }

  void _previous(BuildContext context) {
    HapticFeedback.selectionClick();
    context.read<MusicScreenBloc>().add(PreviousPressed());
  }

  void _toggleLoop(BuildContext context) {
    HapticFeedback.selectionClick();
    context.read<MusicScreenBloc>().add(LoopToggled());
  }

  void _cycleSpeed(BuildContext context) {
    HapticFeedback.selectionClick();
    context.read<MusicScreenBloc>().add(SpeedCycled());
  }

  String _speedLabel(double speed) {
    return speed == speed.roundToDouble() ? '${speed.toInt()}x' : '${speed}x';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<MusicScreenBloc, MusicScreenState>(
      builder: (context, state) {
        final loopOne = state is MusicScreenLoaded && state.loopOne;
        final speed = state is MusicScreenLoaded ? state.speed : 1.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AccentBuilder(
              builder: (context, accent) => GlassButton(
                label: loopOne ? 'Repeat: on' : 'Repeat: off',
                width: 48,
                height: 48,
                iconSize: 22,
                onTap: () => _toggleLoop(context),
                icon: Icon(
                  loopOne ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat,
                  color: loopOne ? accent : colors.subtle,
                ),
              ),
            ),
            GlassButton(
              label: 'Previous',
              width: 56,
              height: 56,
              iconSize: 26,
              onTap: () => _previous(context),
              icon: Icon(CupertinoIcons.backward_fill, color: colors.onMedia),
            ),
            const PlayPauseButton(),
            GlassButton(
              label: 'Next',
              width: 56,
              height: 56,
              iconSize: 26,
              onTap: () => _next(context),
              icon: Icon(CupertinoIcons.forward_fill, color: colors.onMedia),
            ),
            GlassButton.custom(
              label: 'Playback speed',
              width: 56,
              height: 48,
              onTap: () => _cycleSpeed(context),
              child: Text(
                _speedLabel(speed),
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(fontSize: 13),
              ),
            ),
          ],
        );
      },
    );
  }
}
