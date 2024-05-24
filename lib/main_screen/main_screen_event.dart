import 'package:meta/meta.dart';

@immutable
abstract class MainScreenEvent {
  const MainScreenEvent();
}

class InitMainScreenBloc extends MainScreenEvent {
  const InitMainScreenBloc();
}

class StartTapped extends MainScreenEvent {
  const StartTapped();
}

class StartScreenGone extends MainScreenEvent {
  const StartScreenGone();
}

class PlayerWon extends MainScreenEvent {
  const PlayerWon();
}

class WinAnimationDone extends MainScreenEvent {
  const WinAnimationDone();
}

class PlayerLost extends MainScreenEvent {
  const PlayerLost();
}

class LoseAnimationDone extends MainScreenEvent {
  const LoseAnimationDone();
}

class WinAnimationReady extends MainScreenEvent {
  const WinAnimationReady();
}

class SetWin extends MainScreenEvent {
  final bool shouldWin;

  const SetWin(this.shouldWin);
}
