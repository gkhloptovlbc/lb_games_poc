import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../main_screen_bloc.dart';
import '../main_screen_event.dart';
import '../main_screen_state.dart';
import 'game_widget.dart';

class PlayWidget extends StatelessWidget {
  const PlayWidget({
    super.key,
    required this.prizeWidgetKey,
  });

  final GlobalKey prizeWidgetKey;

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(
      fontFamily: 'Permanent Marker',
      package: 'lb_game_internals',
      fontSize: 50,
      height: 1,
      color: Colors.red,
    );

    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            color: const Color(0xFFC0D6E4),
            child: Column(
              children: [
                const Spacer(flex: 1),
                Transform.rotate(
                  angle: -0.07,
                  child: const Text(
                    "Spin to win!",
                    style: ts,
                    textAlign: TextAlign.center,
                  ).animate().shimmer(duration: 1.5.seconds, color: Colors.blueGrey),
                ),
                const SizedBox(height: 32),
                Expanded(
                  flex: 8,
                  child: (state.screenState == ScreenState.play || state.screenState == ScreenState.start)
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GameWidget(prizeKey: prizeWidgetKey)
                              .animate()
                              .rotate(duration: 1.seconds, begin: 0, end: 3, curve: Curves.easeIn)
                              .scale(begin: const Offset(0.1, 0.1)),
                        )
                      : const SizedBox.shrink(),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      icon: const Icon(Icons.thumb_up)
                          .animate(autoPlay: false, target: state.nextTile == state.winningTile ? 0 : 1)
                          .flipV(duration: 300.milliseconds, begin: 0, end: 1),
                      color: state.nextTile == state.winningTile ? Colors.green : Colors.red,
                      iconSize: 32,
                      onPressed: () {
                        context.read<AudioController>().playSfx(SfxType.buttonTap);
                        context.read<MainScreenBloc>().add(SetWin(!(state.winningTile == state.nextTile)));
                      },
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                const Text("Music by Mr. Smith"),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
