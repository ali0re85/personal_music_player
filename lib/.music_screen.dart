import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/data/models/track.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/services/audio_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  static const List<double> _speeds = [1.0, 1.25, 1.5, 2.0, 0.75];

  final PlayerController _playerController = PlayerController.instance;

  final AudioService _audioService = AudioService.instance;

  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  final List<StreamSubscription<dynamic>> _subs = [];

  int _speedIndex = 0;
  bool _liked = false;
  bool _loopOne = false;
  bool _hasError = false;

  /// مقدار موقت اسلایدر هنگام کشیدن
  double? _dragValue;

  Track get _currentTrack =>
      _playerController.currentTrack ??
      _playerController.tracks[_playerController.currentIndex];

  @override
  void initState() {
    super.initState();

    // آیکون play/pause با وضعیت واقعی پلیر هماهنگ می‌شود
    _subs.add(
      _audioService.playingStream.listen((playing) {
        if (playing) {
          _playPauseController.forward();
        } else {
          _playPauseController.reverse();
        }
      }),
    );

    // وقتی آهنگ تمام شد
    _subs.add(
      _audioService.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && !_loopOne) {
          if (_playerController.tracks.length > 1) {
            _next();
          } else {
            _audioService.pause();
            _audioService.seek(Duration.zero);
          }
        }
      }),
    );

    _loadTrack(0);
  }

  @override
  void dispose() {
    for (final sub in _subs) {
      sub.cancel();
    }

    _playPauseController.dispose();
    _audioService.pause();
    _audioService.seek(Duration.zero);

    super.dispose();
  }

  // ───────────────────────── منطق پخش ─────────────────────────

  Future<void> _loadTrack(int index, {bool autoPlay = true}) async {
    setState(() {
      _hasError = false;
      _dragValue = null;
    });

    try {
      final track = _playerController.tracks[index];

      await _playerController.loadTrack(track, autoPlay: autoPlay);

      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  void _togglePlay() {
    HapticFeedback.lightImpact();

    if (_audioService.isPlaying) {
      _audioService.pause();
    } else {
      _audioService.play();
    }
  }

  Future<void> _next() async {
    HapticFeedback.selectionClick();

    if (_playerController.tracks.length == 1) {
      _audioService.seek(Duration.zero);
      return;
    }

    await _playerController.next();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _previous() async {
    HapticFeedback.selectionClick();

    if (_playerController.tracks.length == 1 ||
        _audioService.position > const Duration(seconds: 3)) {
      _audioService.seek(Duration.zero);
      return;
    }

    await _playerController.previous();

    if (mounted) {
      setState(() {});
    }
  }

  void _toggleLoop() {
    HapticFeedback.selectionClick();

    setState(() {
      _loopOne = !_loopOne;
    });

    _audioService.setLoopMode(_loopOne ? LoopMode.one : LoopMode.off);
  }

  void _cycleSpeed() {
    HapticFeedback.selectionClick();

    setState(() {
      _speedIndex = (_speedIndex + 1) % _speeds.length;
    });

    _audioService.setSpeed(_speeds[_speedIndex]);
  }

  void _toggleLike() {
    HapticFeedback.mediumImpact();

    setState(() {
      _liked = !_liked;
    });
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    return h > 0
        ? '$h:${m.toString().padLeft(2, '0')}:$s'
        : '${d.inMinutes}:$s';
  }

  String _speedLabel(double speed) {
    return speed == speed.roundToDouble() ? '${speed.toInt()}x' : '${speed}x';
  }

  // ───────────────────────── UI ─────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),

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
                    _buildHeader(),
                    Expanded(child: _buildCover()),
                    _buildPlayerPanel(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// پس‌زمینه‌ی محو شده از روی کاور
  Widget _buildBackground() {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: SizedBox.expand(
          key: ValueKey(_playerController.currentIndex),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Transform.scale(
                  scale: 1.4,
                  child: Image(
                    image: _currentTrack.cover.provider(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.55),
                      Colors.black.withValues(alpha: 0.88),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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

        IconButton(
          tooltip: 'Like',
          onPressed: _toggleLike,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              _liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              key: ValueKey(_liked),
              color: _liked ? Colors.redAccent : Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// کاور
  Widget _buildCover() {
    return StreamBuilder<bool>(
      stream: _audioService.playingStream,
      initialData: false,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: AnimatedScale(
              scale: playing ? 1.0 : 0.86,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: playing ? 0.55 : 0.3,
                        ),
                        blurRadius: playing ? 50 : 20,
                        offset: Offset(0, playing ? 24 : 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image(
                      image: _currentTrack.cover.provider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// پنل شیشه‌ای پایین
  Widget _buildPlayerPanel() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTrackInfo(),
              const SizedBox(height: 8),
              _buildSeekBar(),
              const SizedBox(height: 4),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo() {
    return SizedBox(
      width: double.infinity,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Column(
          key: ValueKey(_playerController.currentIndex),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentTrack.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _hasError
                  ? 'Could not load this track. Check the asset path.'
                  : _currentTrack.artist,
              style: TextStyle(
                color: _hasError ? Colors.redAccent : Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekBar() {
    return StreamBuilder<Duration?>(
      stream: _audioService.durationStream,
      builder: (context, durationSnap) {
        final total = durationSnap.data ?? Duration.zero;

        final maxMs = total.inMilliseconds.toDouble();

        return StreamBuilder<Duration>(
          stream: _audioService.positionStream,
          builder: (context, positionSnap) {
            final position = positionSnap.data ?? Duration.zero;

            final currentMs = _dragValue ?? position.inMilliseconds.toDouble();

            final value = maxMs > 0
                ? currentMs.clamp(0, maxMs).toDouble()
                : 0.0;

            final shown = Duration(milliseconds: value.round());

            return Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                      elevation: 0,
                      pressedElevation: 0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max: maxMs > 0 ? maxMs : 1,
                    value: value,
                    onChanged: maxMs > 0
                        ? (v) {
                            setState(() {
                              _dragValue = v;
                            });
                          }
                        : null,
                    onChangeEnd: (v) async {
                      _audioService.seek(Duration(milliseconds: v.round()));

                      if (mounted) {
                        setState(() {
                          _dragValue = null;
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _format(shown),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        _format(total),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: _loopOne ? 'Repeat: on' : 'Repeat: off',
          onPressed: _toggleLoop,
          icon: Icon(
            _loopOne ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat,
            color: _loopOne ? Colors.white : Colors.white54,
          ),
        ),

        IconButton(
          tooltip: 'Previous',
          onPressed: _previous,
          iconSize: 30,
          icon: const Icon(CupertinoIcons.backward_fill, color: Colors.white),
        ),

        _buildPlayButton(),

        IconButton(
          tooltip: 'Next',
          onPressed: _next,
          iconSize: 30,
          icon: const Icon(CupertinoIcons.forward_fill, color: Colors.white),
        ),

        TextButton(
          onPressed: _cycleSpeed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.white12,
            shape: const StadiumBorder(),
            minimumSize: const Size(48, 34),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: Text(
            _speedLabel(_speeds[_speedIndex]),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return StreamBuilder<PlayerState>(
      stream: _audioService.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;

        final busy =
            state != null &&
            (state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.22),
                blurRadius: 24,
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _togglePlay,
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: busy
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        )
                      : AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _playPauseController,
                          size: 34,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    )
  }
}
