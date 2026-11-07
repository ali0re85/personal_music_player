import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_setup.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/core/theme/app_theme.dart';
import 'package:music_player/locator.dart';
import 'package:music_player/presentation/screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // اندروید
      statusBarBrightness: Brightness.dark, // iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  setupDependencyInjection();

  runApp(
    LiquidGlassWidgets.wrap(
      child: const MyApp(),
      brightnessResolver: Theme.maybeBrightnessOf,
      adaptiveQuality: kReleaseMode,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => ValueListenableBuilder<bool>(
        valueListenable: PlayerController.instance.backdropIsLightNotifier,
        builder: (context, isLight, _) => Theme(
          data: AppTheme.forBackdrop(isLight: isLight),
          child: Material(type: MaterialType.transparency, child: child!),
        ),
      ),
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
    );
  }
}
