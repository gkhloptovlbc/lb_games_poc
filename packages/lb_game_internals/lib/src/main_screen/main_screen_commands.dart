
import '../utils/base_bloc/bloc_command.dart';

class ShowGame extends BlocCommand {
  const ShowGame();
}

class PrepareWinAnimation extends BlocCommand {
  const PrepareWinAnimation();
}

class ShowWin extends BlocCommand {
  const ShowWin();
}

class ShowLose extends BlocCommand {
  const ShowLose();
}
