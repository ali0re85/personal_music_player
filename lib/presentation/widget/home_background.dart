import 'package:flutter/material.dart';
import 'package:music_player/gen/assets.gen.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: Assets.brand.navaBg.image(fit: BoxFit.cover));
  }
}
