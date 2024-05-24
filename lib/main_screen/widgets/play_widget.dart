import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_event.dart';
import 'package:lb_games_poc/main_screen/widgets/game_widget.dart';

import '../../audio/audio_controller.dart';
import '../../audio/sounds.dart';
import '../main_screen_state.dart';

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
      fontSize: 50,
      height: 1,
      color: Colors.red,
    );

    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return SafeArea(
          child: Container(
            color: Color(0xFFC0D6E4),
            child: Column(
              children: [
                Spacer(flex: 1),
                Transform.rotate(
                  angle: -0.07,
                  child: Text(
                    "Spin to win!",
                    style: ts,
                    textAlign: TextAlign.center,
                  ).animate().shimmer(duration: 1.5.seconds, color: Colors.blueGrey),
                ),
                SizedBox(height: 32),
                Expanded(
                  flex: 8,
                  child: (state.screenState == ScreenState.play || state.screenState == ScreenState.start)
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GameWidget(prizeKey: prizeWidgetKey)
                              .animate()
                              .rotate(duration: 1.seconds, begin: 0, end: 3, curve: Curves.easeIn)
                              .scale(begin: Offset(0.1, 0.1)),
                        )
                      : SizedBox.shrink(),
                ),
                Spacer(),
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      // icon: state.nextTile == state.winningTile ? Icon(Icons.thumb_up) : Icon(Icons.thumb_down),
                      icon: Icon(Icons.thumb_up)
                          .animate(autoPlay: false, target: state.nextTile == state.winningTile ? 0 : 1)
                          .flipV(duration: 300.milliseconds, begin: 0, end: 1),
                      color: state.nextTile == state.winningTile ? Colors.green : Colors.red,
                      iconSize: 50,
                      onPressed: () {
                        context.read<AudioController>().playSfx(SfxType.buttonTap);
                        context.read<MainScreenBloc>().add(SetWin(!(state.winningTile == state.nextTile)));
                      },
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Text("Music by Mr. Smith"),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
