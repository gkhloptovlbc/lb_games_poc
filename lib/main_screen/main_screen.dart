import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_commands.dart';
import 'package:lb_games_poc/main_screen/widgets/lose_widget.dart';
import 'package:lb_games_poc/main_screen/widgets/play_widget.dart';
import 'package:lb_games_poc/main_screen/widgets/start_widget.dart';
import 'package:lb_games_poc/main_screen/widgets/win_widget.dart';
import 'package:lb_games_poc/utils/base_bloc/bloc_command.dart';

import '../settings/settings.dart';
import 'main_screen_bloc.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';

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
  late final AnimationController _loseAnimationController;
  final _prizeWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loseAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    return BlocCommandsListener<MainScreenBloc>(
      listener: _onBlocCommand,
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                PlayWidget(prizeWidgetKey: _prizeWidgetKey),
                LoseWidget().animate(controller: _loseAnimationController, autoPlay: false).fadeIn(duration: 1.seconds),
                WinWidget(prizeWidgetKey: _prizeWidgetKey),
                // StartWidget(),
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
        },
      ),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    final bloc = context.read<MainScreenBloc>();
    if (command is ShowLose) {
      _loseAnimationController.forward().then((_) => bloc.add(const LoseAnimationDone()));
    }
  }
}
