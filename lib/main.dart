// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lb_game_internals/lb_game_internals.dart' deferred as lb_game_internals;
import 'package:logging/logging.dart';

void main() async {
  // Basic logging setup.
  Logger.root.level = kDebugMode ? Level.FINE : Level.INFO;
  Logger.root.onRecord.listen((record) {
    dev.log(
      record.message,
      time: record.time,
      level: record.level.value,
      name: record.loggerName,
    );
  });

  WidgetsFlutterBinding.ensureInitialized();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isGameLoaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_doLoadGameInternals());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wheel of Fortune PoC',
      home: _isGameLoaded ? const LoadedGameWidget() : const LoadingPlaceholder(),
    );
  }

  Future<void> _doLoadGameInternals() async {
    await lb_game_internals.loadLibrary();
    setState(() {
      _isGameLoaded = true;
    });
  }
}

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        Expanded(child: Center(child: Text('Loading game...'))),
        CircularProgressIndicator(),
      ],
    );
  }
}

class LoadedGameWidget extends StatelessWidget {
  const LoadedGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return lb_game_internals.AppHarness(
      child: Builder(builder: (context) {
        return lb_game_internals.MainScreen(key: Key('main screen'));
      }),
    );
  }
}
