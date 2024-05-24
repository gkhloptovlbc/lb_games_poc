import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_bloc.dart';

import '../../utils/base_bloc/bloc_command.dart';
import '../main_screen_commands.dart';
import '../main_screen_state.dart';

class LoseWidget extends StatefulWidget {
  const LoseWidget({super.key});

  @override
  State<LoseWidget> createState() => _LoseWidgetState();
}

class _LoseWidgetState extends State<LoseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _loseAnimationController;

  static final firstLineDuration = 1.seconds;
  static final secondLineDelay = firstLineDuration + 1.seconds;
  static final secondLineDuration = 1.seconds;
  static final catDelay = secondLineDelay + secondLineDuration + 1.seconds;
  static final catDuration = 1.seconds;
  static final thirdLineDelay = catDelay + catDuration + 1.seconds;
  static final thirdLineDuration = 1.seconds;
  static final actionButtonDelay = thirdLineDelay + thirdLineDuration + 1.seconds;
  static final actionButtonDuration = 1.seconds;

  @override
  void initState() {
    super.initState();
    _loseAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _loseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      fontFamily: 'Permanent Marker',
      fontSize: 30,
      height: 1,
      color: Colors.redAccent,
    );

    const tsb = TextStyle(
      fontFamily: 'Permanent Marker',
      fontSize: 14,
      height: 1,
      color: Colors.black,
    );

    return BlocCommandsListener<MainScreenBloc>(
      listener: _onBlocCommand,
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          final mediaQuery = MediaQuery.of(context);
          final catBlockHeight = mediaQuery.orientation == Orientation.portrait
              ? mediaQuery.size.width - 64
              : mediaQuery.size.height * 0.5;
          return IgnorePointer(
            ignoring: state.screenState != ScreenState.lose,
            child: Stack(
              children: [
                LoseBackground(),
                SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 32),
                        Text(
                          'You didn\'t win',
                          style: ts,
                          textAlign: TextAlign.center,
                        )
                            .animate(controller: _loseAnimationController, autoPlay: false)
                            .fadeIn(duration: firstLineDuration),
                        SizedBox(height: 32),
                        Text(
                          'Look at this cute kitty',
                          style: ts,
                          textAlign: TextAlign.center,
                        )
                            .animate(controller: _loseAnimationController, autoPlay: false)
                            .fadeIn(duration: secondLineDuration, delay: secondLineDelay),
                        SizedBox(height: 16),
                        SizedBox(
                          height: catBlockHeight,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: CachedNetworkImage(
                                  imageUrl: state.catImageUrl,
                                  fit: BoxFit.cover,
                                  cacheKey: Random().nextInt(1000).toString(), // Dirty hack to make cat random
                                ),
                              ),
                            ),
                          )
                              .animate(controller: _loseAnimationController, autoPlay: false)
                              .fadeIn(duration: catDuration, delay: catDelay),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: Text(
                            'And try again tomorrow!',
                            style: ts,
                            textAlign: TextAlign.center,
                          )
                              .animate(controller: _loseAnimationController, autoPlay: false)
                              .fadeIn(delay: thirdLineDelay, duration: thirdLineDuration),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    if (command is ShowLose) {
      _loseAnimationController.forward().ignore();
    }
  }
}

class LoseBackground extends StatefulWidget {
  const LoseBackground({
    super.key,
  });

  @override
  State<LoseBackground> createState() => _LoseBackgroundState();
}

class _LoseBackgroundState extends State<LoseBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundAnimationController;

  @override
  void initState() {
    super.initState();
    _backgroundAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocCommandsListener<MainScreenBloc>(
      listener: _onBlocCommand,
      child: Container(color: Color(0xFF222929))
          .animate(controller: _backgroundAnimationController, autoPlay: false)
          .fadeIn(duration: 300.ms),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    if (command is ShowLose) {
      _backgroundAnimationController.forward().ignore();
    }
  }
}
