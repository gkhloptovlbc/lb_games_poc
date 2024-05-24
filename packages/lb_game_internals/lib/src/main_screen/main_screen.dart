import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_game_internals/src/main_screen/widgets/lose_widget.dart';
import 'package:lb_game_internals/src/main_screen/widgets/play_widget.dart';
import 'package:lb_game_internals/src/main_screen/widgets/win_widget.dart';


import '../settings/settings.dart';
import 'main_screen_bloc.dart';
import 'main_screen_event.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainScreenBloc>(
      create: (context) {
        return MainScreenBloc()..add(const InitMainScreenBloc());
      },
      child: const MainScreenContent(),
    );
  }
}

class MainScreenContent extends StatefulWidget {
  const MainScreenContent({super.key});

  @override
  State<MainScreenContent> createState() => _MainScreenContentState();
}

class _MainScreenContentState extends State<MainScreenContent> with TickerProviderStateMixin {
  final _prizeWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return Scaffold(
      body: Stack(
        // fit: StackFit.expand,
        children: <Widget>[
          PlayWidget(prizeWidgetKey: _prizeWidgetKey),
          const LoseWidget(),
          WinWidget(prizeWidgetKey: _prizeWidgetKey),
          Positioned(
            bottom: 16,
            right: 16,
            child: ValueListenableBuilder<bool>(
              valueListenable: settingsController.audioOn,
              builder: (context, audioOn, child) {
                return IconButton(
                  iconSize: 32,
                  color: Colors.white,
                  onPressed: settingsController.toggleAudioOn,
                  icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
