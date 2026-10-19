
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/presentation/widget/track_cover.dart';
import 'package:music_player/presentation/widget/mini_player.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/presentation/logic/home_screen_bloc.dart';
import 'package:music_player/presentation/widget/music_screen_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenBloc()..add(HomeScreenSongsRequested()),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // اندروید
          statusBarBrightness: Brightness.light, // iOS
        ),
        child: Scaffold(
          bottomNavigationBar: const SafeArea(top: false, child: MiniPlayer()),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Assets.icons.logo.svg(),
                      const SizedBox(width: 8),
                      Text(
                        'Music Player',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.5),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: const Offset(1, 1.5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Assets.icons.search.svg(width: 24, height: 24),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.5),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: const Offset(1, 1.5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Assets.icons.categories.svg(
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Play Lists',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.5),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: const Offset(1, 1.5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Assets.icons.add.svg(width: 24, height: 24),
                        ),
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
                              Container(
                                width: 112,
                                height: 112,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 5,
                                    ),
                                  ],
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
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey.shade600),
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
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Songs',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        builder: (context, state) {
                          final count = state is HomeScreenSuccess
                              ? context.read<HomeScreenBloc>().totalCount
                              : 0;

                          return Text(
                            count.toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Assets.icons.vector.svg(width: 24, height: 24),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                    builder: (context, state) {
                      switch (state) {
                        case HomeScreenInitial():
                        case HomeScreenLoading():
                          return const Center(
                            child: CircularProgressIndicator(),
                          );

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
                              padding: const EdgeInsets.only(top: 12),
                              physics: const BouncingScrollPhysics(),
                              itemCount:
                                  tracks.length + (state.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == tracks.length) {
                                  return Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final track = tracks[index];

                                return ListTile(
                                  onTap: () {
                                    final controller =
                                        PlayerController.instance;

                                    if (controller.currentTrack?.id !=
                                        track.id) {
                                      controller.setQueue(tracks, index);
                                    }

                                    Navigator.push(context, musicScreenRoute());
                                  },
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: TrackCover(
                                        track: track,
                                        width: 56,
                                        height: 56,
                                      ),
                                    ),
                                  ),
                                  title: Text(track.title),
                                  subtitle: Text(track.id.toString()),
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
      ),
    );
  }
}
