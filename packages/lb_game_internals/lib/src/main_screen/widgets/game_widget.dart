// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';


import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../main_screen_bloc.dart';
import '../main_screen_event.dart';
import '../main_screen_state.dart';
import 'prize_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class GameWidget extends StatefulWidget {
  const GameWidget({super.key, required this.prizeKey});

  final GlobalKey prizeKey;

  @override
  State<GameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  final StreamController<int> fwcontroller = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return FortuneWheel(
          selected: fwcontroller.stream,
          indicators: const [
            FortuneIndicator(
              alignment: Alignment.topCenter,
              child: TriangleIndicator(
                width: 20,
                height: 30,
                elevation: 8,
                color: Colors.lightGreenAccent,
              ),
            ),
          ],
          rotationCount: 10,
          animateFirst: false,
          hapticImpact: HapticImpact.light,
          items: _genItems(state.totalTiles, state.winningTile, widget.prizeKey),
          physics: CircularPanPhysics(
            duration: const Duration(seconds: 1),
            curve: Curves.decelerate,
          ),
          onFling: () => _play(context),
          onAnimationEnd: () async {
            final bloc = context.read<MainScreenBloc>();

            if (bloc.state.nextTile == bloc.state.winningTile) {
              bloc.add(const PlayerWon());
            } else {
              bloc.add(const PlayerLost());
            }
          },
        );
      },
    );
  }

  void _play(BuildContext context) {
    context.read<AudioController>().playSfx(SfxType.huhsh);
    final mss = context.read<MainScreenBloc>().state;
    fwcontroller.add(mss.nextTile);
  }

  List<FortuneItem> _genItems(int totalTiles, int winningTile, GlobalKey prizeKey) {
    const icons = [
      Icons.ac_unit,
      Icons.back_hand,
      Icons.cabin,
      Icons.dark_mode,
      Icons.eco,
      Icons.factory_outlined,
      Icons.g_translate,
      Icons.hardware,
      Icons.icecream,
      Icons.join_inner_sharp,
      Icons.kayaking,
      Icons.landscape,
      Icons.mail,
    ];

    const colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.amber,
      Colors.lime,
      Colors.indigo,
      Colors.brown,
    ];

    return List.generate(
      totalTiles,
      (index) => FortuneItem(
        child: _WheelItem(
          icon: index == winningTile ? PrizeWidget(key: prizeKey) : Icon(icons[index % icons.length]),
          value: index,
        ),
        style: FortuneItemStyle(
          color: colors[index % colors.length],
          borderColor: Colors.black,
          borderWidth: 2,
        ),
      ),
    );
  }
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({
    required this.icon,
    required this.value,
  });

  final Widget icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(8.0),
            child: icon,
          ),
        ),
        const SizedBox(width: 25),
      ],
    );
  }
}
