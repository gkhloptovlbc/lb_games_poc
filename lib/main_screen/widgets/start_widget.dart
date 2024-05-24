import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_commands.dart';
import 'package:lb_games_poc/main_screen/main_screen_event.dart';
import 'package:lb_games_poc/main_screen/main_screen_state.dart';
import 'package:lb_games_poc/utils/base_bloc/bloc_command.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({super.key});

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _startAnimationController;

  @override
  void initState() {
    super.initState();
    _startAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _startAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocCommandsListener<MainScreenBloc>(
      listener: _onBlocCommand,
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          if (state.screenState != ScreenState.start) {
            return SizedBox.shrink();
          }

          return Container(
            color: Colors.blueAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Start!'),
                ElevatedButton(
                  onPressed: () {
                    context.read<MainScreenBloc>().add(StartTapped());
                  },
                  child: Text('Start'),
                ),
              ],
            ),
          );
        },
      ).animate(controller: _startAnimationController, autoPlay: false).fadeOut(duration: 0.1.seconds),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    if (command is ShowGame) {
      _startAnimationController.forward().then((value) => context.read<MainScreenBloc>().add(StartScreenGone()));
    }
  }
}
