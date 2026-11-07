import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/tinted_svg.dart';
import 'package:music_player/domain/repository/music_repository.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/presentation/logic/home_screen_bloc.dart';
import 'package:music_player/presentation/widget/home_background.dart';
import 'package:music_player/presentation/widget/home_header.dart';
import 'package:music_player/presentation/widget/mini_player.dart';
import 'package:music_player/presentation/widget/music_screen_route.dart';
import 'package:music_player/presentation/widget/source_toggle.dart';
import 'package:music_player/presentation/widget/track_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenBloc(
        offlineRepository: locator<MusicRepository>(instanceName: 'offline'),
        onlineRepository: locator<MusicRepository>(instanceName: 'online'),
      )..add(HomeScreenSongsRequested()),

      child: GlassScaffold(
        background: const HomeBackground(),
        statusBarStyle: GlassStatusBarStyle.light,
        bottomBar: const SafeArea(top: false, child: MiniPlayer()),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const HomeHeader(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Play Lists',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GlassButton(
                      width: 44,
                      height: 44,
                      iconSize: 24,
                      icon: Assets.icons.add.tinted(
                        context,
                        width: 24,
                        height: 24,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 178,
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    if (state is HomeScreenInitial ||
                        state is HomeScreenLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GlassContainer(
                              width: 112,
                              height: 112,
                              padding: const EdgeInsets.all(6),
                              shape: const LiquidRoundedSuperellipse(
                                borderRadius: 20,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Assets.icons.cover.image(
                                  width: 96,
                                  height: 96,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Play List',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '100 Tracks',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Songs',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        BlocSelector<HomeScreenBloc, HomeScreenState, int?>(
                          selector: (state) => state is HomeScreenSuccess
                              ? state.totalCount
                              : null,
                          builder: (context, count) {
                            if (count == null) return const SizedBox.shrink();

                            return Text(
                              '$count',
                              style: Theme.of(context).textTheme.titleMedium,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Assets.icons.vector.tinted(
                          context,
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                    BlocBuilder<HomeScreenBloc, HomeScreenState>(
                      buildWhen: (prev, curr) => prev.source != curr.source,
                      builder: (context, state) => SourceToggle(
                        selected: state.source,
                        onChanged: (s) => context.read<HomeScreenBloc>().add(
                          HomeScreenSourceChanged(s),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  builder: (context, state) {
                    switch (state) {
                      case HomeScreenInitial():
                      case HomeScreenLoading():
                        return const Center(child: CircularProgressIndicator());

                      case HomeScreenEmpty():
                        return const Center(child: Text('No songs found'));

                      case HomeScreenError():
                        return Center(child: Text(state.errorMessage));

                      case HomeScreenSuccess():
                        final tracks = state.tracks;

                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            final metrics = notification.metrics;
                            if (metrics.pixels >=
                                metrics.maxScrollExtent - 200) {
                              context.read<HomeScreenBloc>().add(
                                HomeScreenNextPageRequested(),
                              );
                            }
                            return false;
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: 12,
                              bottom:
                                  120 + MediaQuery.paddingOf(context).bottom,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                tracks.length + (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == tracks.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final track = tracks[index];

                              return TrackTile(
                                track: track,
                                onTap: () {
                                  final controller = PlayerController.instance;

                                  if (controller.currentTrack?.id != track.id) {
                                    controller.setQueue(tracks, index);
                                  }

                                  Navigator.push(context, musicScreenRoute());
                                },
                              );
                            },
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
