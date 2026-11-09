import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:music_player/gen/assets.gen.dart';
import 'package:music_player/presentation/logic/home_screen/home_screen_bloc.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _isSearching = false;
  void _closeSearch() {
    context.read<HomeScreenBloc>().add(HomeScreenSearchChanged(''));
    setState(() => _isSearching = false);
  }

  static const double _size = 44;
  static const double _gap = 24;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: _size,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // the search pill can grow until it reaches the left edge
            final expandedWidth = constraints.maxWidth - _size - _gap;

            return Stack(
              children: [
                // logo + title, fades out while searching
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedOpacity(
                    opacity: _isSearching ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.brand.logoFa.image(height: 32),
                        const SizedBox(width: 10),
                        Assets.brand.logoEn.image(height: 24),
                      ],
                    ),
                  ),
                ),

                // categories icon, always on the right
                Align(
                  alignment: Alignment.centerRight,
                  child: GlassButton(
                    width: _size,
                    height: _size,
                    iconSize: 24,
                    icon: Assets.icons.categories2.svg(width: 24, height: 24),
                    onTap: () {},
                  ),
                ),

                // search icon, grows to the left when tapped
                Positioned(
                  right: _size + _gap,
                  top: 0,
                  child: GestureDetector(
                    // only opens when collapsed; closing is done by the close button
                    onTap: _isSearching
                        ? null
                        : () => setState(() => _isSearching = true),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: _isSearching ? expandedWidth : _size,
                      height: _size,
                      child: GlassContainer(
                        shape: LiquidRoundedSuperellipse(borderRadius: 22),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: OverflowBox(
                            alignment: Alignment.centerLeft,
                            minWidth: 0,
                            maxWidth: expandedWidth,
                            child: SizedBox(
                              width: expandedWidth,
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Assets.icons.search2.svg(
                                    width: 24,
                                    height: 24,
                                  ),
                                  if (_isSearching) ...[
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        autofocus: true,
                                        onChanged: (text) {
                                          context.read<HomeScreenBloc>().add(
                                            HomeScreenSearchChanged(text),
                                          );
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Search songs',
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: _closeSearch,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
