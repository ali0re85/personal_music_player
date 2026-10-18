import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';
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
    return BlocBuilder<MusicScreenBloc, MusicScreenState>(
      builder: (context, state) {
        final loopOne = state is MusicScreenLoaded && state.loopOne;
        final speed = state is MusicScreenLoaded ? state.speed : 1.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              tooltip: loopOne ? 'Repeat: on' : 'Repeat: off',
              onPressed: () => _toggleLoop(context),
              icon: Icon(
                loopOne ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat,
                color: loopOne ? Colors.white : Colors.white54,
              ),
            ),

            IconButton(
              tooltip: 'Previous',
              onPressed: () => _previous(context),
              iconSize: 30,
              icon: const Icon(
                CupertinoIcons.backward_fill,
                color: Colors.white,
              ),
            ),

            const PlayPauseButton(),

            IconButton(
              tooltip: 'Next',
              onPressed: () => _next(context),
              iconSize: 30,
              icon: const Icon(
                CupertinoIcons.forward_fill,
                color: Colors.white,
              ),
            ),

            TextButton(
              onPressed: () => _cycleSpeed(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.white12,
                shape: const StadiumBorder(),
                minimumSize: const Size(48, 34),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                _speedLabel(speed),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}