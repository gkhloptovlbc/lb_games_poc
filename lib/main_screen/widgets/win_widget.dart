import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/audio/audio_controller.dart';
import 'package:lb_games_poc/main_screen/main_screen_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_commands.dart';
import 'package:lb_games_poc/main_screen/main_screen_event.dart';
import 'package:lb_games_poc/main_screen/widgets/prize_widget.dart';
import 'package:lb_games_poc/style/confetti.dart';
import 'package:lb_games_poc/utils/base_bloc/bloc_command.dart';

import '../../audio/sounds.dart';
import '../main_screen_state.dart';

class WinWidget extends StatefulWidget {
  const WinWidget({super.key, required this.prizeWidgetKey});

  final GlobalKey prizeWidgetKey;

  @override
  State<WinWidget> createState() => _WinWidgetState();
}

class _WinWidgetState extends State<WinWidget> {
  late final Offset _beginOffset;
  late final double _beginScale;
  final GlobalKey _winZoneKey = GlobalKey();
  bool _showConfetti = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    // _winAnimationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    // _winAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocCommandsListener<MainScreenBloc>(
      listener: _onBlocCommand,
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state.screenState != ScreenState.win,
            child: Stack(
              children: [
                WinBackground(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacer(flex: 1),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: SizedBox(
                          key: _winZoneKey,
                          child: (state.screenState == ScreenState.win || state.screenState == ScreenState.winAnimation)
                              ? PrizeWidget(key: widget.prizeWidgetKey)
                                  .animate(onComplete: _onPrizeAnimationComplete)
                                  // .rotate(duration: 1.seconds, begin: 0, end: 2, curve: Curves.easeOut)
                                  .shake(duration: 1.seconds, hz: 3)
                                  .scale(
                                    duration: 1.seconds,
                                    begin: Offset(_beginScale, _beginScale),
                                  )
                                  .move(begin: _beginOffset)
                              : SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: _showText
                          ? Center(
                              child: Transform.rotate(
                                angle: -0.1,
                                child: const Text(
                                  'Congratulations!\n\nYou won a free\ncar wash!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Permanent Marker',
                                    fontSize: 40,
                                    height: 1,
                                    color: Colors.greenAccent,
                                  ),
                                )
                                    .animate()
                                    .slide(delay: 2.seconds, duration: 1.seconds)
                                    .fadeIn()
                                    .then()
                                    .shimmer(duration: 2.seconds, color: Colors.blueAccent),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Spacer(),
                  ],
                ),
                if (_showConfetti) Confetti()
              ],
            ),
          );
        },
      ),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    if (command is PrepareWinAnimation) {
      _prepareWinAnimation(context);
    }
  }

  void _prepareWinAnimation(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();

    final prizeWidget = widget.prizeWidgetKey.currentContext!.findRenderObject() as RenderBox;
    final initialPrizePosition = prizeWidget.localToGlobal(Offset.zero);
    final initialPrizeSize = prizeWidget.size;

    final winZoneWidget = _winZoneKey.currentContext!.findRenderObject() as RenderBox;
    final winZoneSize = winZoneWidget.size;
    final winZonePosition = winZoneWidget.localToGlobal(Offset.zero);

    _beginScale = min(
      initialPrizeSize.width / winZoneSize.width,
      initialPrizeSize.height / winZoneSize.height,
    );

    final initialCenter = initialPrizeSize.center(initialPrizePosition);
    final endCenter = winZoneSize.center(winZonePosition);

    _beginOffset = initialCenter - endCenter;

    bloc.add(WinAnimationReady());
  }

  void _onPrizeAnimationComplete(AnimationController controller) async {
    final bloc = context.read<MainScreenBloc>();
    final audioController = context.read<AudioController>();
    setState(() {
      _showConfetti = true;
      _showText = true;
    });

    audioController.playSfx(SfxType.congrats);

    await Future<void>.delayed(2.seconds);
    setState(() {
      _showConfetti = false;
    });
    bloc.add(const WinAnimationDone());
  }
}

class WinBackground extends StatefulWidget {
  const WinBackground({
    super.key,
  });

  @override
  State<WinBackground> createState() => _WinBackgroundState();
}

class _WinBackgroundState extends State<WinBackground> with SingleTickerProviderStateMixin {
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.black.withOpacity(0.8)),
      ).animate(controller: _backgroundAnimationController, autoPlay: false).fadeIn(duration: 300.ms),
    );
  }

  void _onBlocCommand(BuildContext context, BlocCommand command) {
    if (command is ShowWin) {
      _backgroundAnimationController.forward().ignore();
    }
  }
}
