import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';

class PlayerHeader extends StatelessWidget {
  const PlayerHeader({super.key});

  void _toggleLike(BuildContext context) {
    HapticFeedback.mediumImpact();

    context.read<MusicScreenBloc>().add(LikeToggled());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.deepPurpleAccent,
                Colors.cyanAccent,
              ],
            ),
          ),
          child: ClipOval(
            child: Assets.icons.profileImage.image(
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 14),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anjelina Joeli',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '@anjelina_joeli',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),

        BlocBuilder<MusicScreenBloc, MusicScreenState>(
          builder: (context, state) {
            final liked = state is MusicScreenLoaded && state.liked;

            return IconButton(
              tooltip: 'Like',
              onPressed: () => _toggleLike(context),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  key: ValueKey(liked),
                  color: liked ? Colors.redAccent : Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}