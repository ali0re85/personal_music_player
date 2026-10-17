import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/music_screen/bloc/music_screen_bloc.dart';
import 'package:music_player/music_screen/widgets/player_background.dart';
import 'package:music_player/music_screen/widgets/player_cover.dart';
import 'package:music_player/music_screen/widgets/player_header.dart';
import 'package:music_player/music_screen/widgets/player_panel.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.currentTrackNotifier,
        controller.hasError,
      ]),
      builder: (context, _) {
        final track = controller.currentTrack;

        if (track == null) {
          return const Scaffold(backgroundColor: Colors.black);
        }

        return _buildScaffold(track, controller.hasError.value);
      },
    );
  }

  Widget _buildScaffold(Track track, bool hasError) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PlayerBackground(track: track),

          SafeArea(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) {
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 32 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    const PlayerHeader(),
                    Expanded(child: PlayerCover(track: track)),
                    PlayerPanel(track: track, hasError: hasError),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// مسیر باز شدن صفحه‌ی پلینگ با انیمیشن slide-up.
/// از home_screen.dart و mini_player.dart صدا زده میشه.
Route<void> musicScreenRoute() {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
      create: (_) => MusicScreenBloc(),
      child: const MainScreen(),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
