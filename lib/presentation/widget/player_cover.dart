import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/domain/entity/music_entity.dart';
import 'package:music_player/presentation/logic/music_screen_bloc.dart';
import 'package:music_player/presentation/widget/track_cover.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerCover extends StatefulWidget {
  const PlayerCover({super.key, required this.track});

  final MusicEntity track;

  @override
  State<PlayerCover> createState() => _PlayerCoverState();
}

class _PlayerCoverState extends State<PlayerCover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drag = AnimationController.unbounded(
    vsync: this,
  );

  bool _pending = false;

  @override
  void dispose() {
    _drag.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerCover oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.track.id != widget.track.id) {
      _drag.stop();
      _drag.value = 0;
      _pending = false;
    }
  }

  void _onDragStart(DragStartDetails details) {
    if (_pending) return;
    _drag.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_pending) return;
    _drag.value += details.delta.dx;
  }

  void _onDragEnd(DragEndDetails details) {
    if (_pending) return;

    final width = MediaQuery.sizeOf(context).width;
    final velocity = details.primaryVelocity ?? 0;
    final dx = _drag.value;

    final byDistance = dx.abs() > width * 0.25;
    final byFling = velocity.abs() > 700;

    if (!byDistance && !byFling) {
      _springBack();
      return;
    }

    final goNext = byFling ? velocity < 0 : dx < 0;
    _commit(goNext);
  }

  void _onDragCancel() {
    if (_pending) return;
    _springBack();
  }

  void _springBack() {
    _drag.animateTo(
      0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
    );
  }

  Future<void> _commit(bool goNext) async {
    final bloc = context.read<MusicScreenBloc>();

    if (PlayerController.instance.tracks.length <= 1) {
      bloc.add(goNext ? NextPressed() : PreviousPressed());
      _springBack();
      return;
    }

    final startId = widget.track.id;
    _pending = true;

    bloc.add(goNext ? NextPressed() : PreviousPressed());

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    if (_pending && widget.track.id == startId) {
      _pending = false;
      _springBack();
    }
  }

  Widget _buildCard(bool playing, double dx) {
    return Transform.translate(
      offset: Offset(dx, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: playing ? 0.55 : 0.3),
              blurRadius: playing ? 50 : 20,
              offset: Offset(0, playing ? 24 : 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: TrackCover(track: widget.track, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = AudioService.instance;

    return StreamBuilder<bool>(
      stream: audioService.playingStream,
      initialData: audioService.isPlaying,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: AnimatedScale(
              scale: playing ? 1.0 : 0.86,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                onHorizontalDragCancel: _onDragCancel,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedBuilder(
                    animation: _drag,
                    builder: (context, _) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 550),
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          final isIncoming =
                              child.key == ValueKey(widget.track.id);
                          final isNext =
                              PlayerController.instance.lastMoveWasNext;

                          final dx = isIncoming
                              ? (isNext ? 1.0 : -1.0)
                              : (isNext ? -1.0 : 1.0);

                          final curved = animation.drive(
                            CurveTween(curve: Curves.easeOutCubic),
                          );

                          return AnimatedBuilder(
                            animation: curved,
                            child: child,
                            builder: (context, child) {
                              final p = 1 - curved.value;

                              return Opacity(
                                opacity: curved.value.clamp(0.0, 1.0),
                                child: FractionalTranslation(
                                  translation: Offset(dx * p * 1.1, 0),
                                  child: Transform.scale(
                                    scale: 1 - 0.2 * p,
                                    child: Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(-dx * p * 0.6),
                                      child: child,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: SizedBox.expand(
                          key: ValueKey(widget.track.id),
                          child: _buildCard(playing, _drag.value),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
