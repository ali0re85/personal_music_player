import 'package:flutter/material.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/features/widgets/mini_player.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/music_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: const MiniPlayer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Assets.icons.logo.svg(),
                  SizedBox(width: 8),
                  Text(
                    'Music Player',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
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
                          offset: Offset(1, 1.5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Assets.icons.search.svg(width: 24, height: 24),
                    ),
                  ),
                  SizedBox(width: 24),
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
                          offset: Offset(1, 1.5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Assets.icons.categories.svg(width: 24, height: 24),
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
                          offset: Offset(1, 1.5),
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
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,

                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                separatorBuilder: (context, index) => SizedBox(width: 10),
                itemCount: 10,

                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
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
                      SizedBox(height: 10),
                      Text(
                        'Play List',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '100 Tracks',
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
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
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text('Songs', style: Theme.of(context).textTheme.titleMedium),
                  Spacer(),
                  Text('11', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(width: 8),
                  Assets.icons.vector.svg(width: 24, height: 24),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 12),
                physics: BouncingScrollPhysics(),
                itemCount: 11,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      final tracks = PlayerController.instance.tracks;
                      Navigator.push(
                        context,
                        musicScreenRoute(track: tracks[index % tracks.length]),
                      );
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
                        child: Assets.icons.cover.image(width: 56, height: 56),
                      ),
                    ),
                    title: Text('Song Name'),
                    subtitle: Text('Singer Name'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
