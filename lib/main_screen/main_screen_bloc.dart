import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lb_games_poc/main_screen/main_screen_commands.dart';
import 'package:lb_games_poc/utils/base_bloc/base_bloc.dart';

import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends BaseBloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(const MainScreenState.initial()) {
    on<InitMainScreenBloc>(_initMainScreenBloc);
    on<StartTapped>(_startTapped);
    on<StartScreenGone>(_startScreenGone);
    on<PlayerWon>(_playerWon);
    on<WinAnimationDone>(_winAnimationDone);
    on<PlayerLost>(_playerLost);
    on<LoseAnimationDone>(_loseAnimationDone);
    on<WinAnimationReady>(_winAnimationReady);
    on<SetWin>(_setWin);
  }

  FutureOr<void> _initMainScreenBloc(InitMainScreenBloc event, Emitter<MainScreenState> emit) async {
    add(StartScreenGone());
  }

  FutureOr<void> _startTapped(StartTapped event, Emitter<MainScreenState> emit) async {
    sendCommand(ShowGame());
  }

  FutureOr<void> _startScreenGone(StartScreenGone event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(screenState: ScreenState.play));
  }

  FutureOr<void> _playerWon(PlayerWon event, Emitter<MainScreenState> emit) async {
    sendCommand(PrepareWinAnimation());
  }

  FutureOr<void> _winAnimationReady(WinAnimationReady event, Emitter<MainScreenState> emit) async {
    sendCommand(ShowWin());
    emit(state.copyWith(screenState: ScreenState.winAnimation));
  }

  FutureOr<void> _winAnimationDone(WinAnimationDone event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(screenState: ScreenState.win));
  }

  FutureOr<void> _playerLost(PlayerLost event, Emitter<MainScreenState> emit) async {
    sendCommand(ShowLose());
  }

  FutureOr<void> _loseAnimationDone(LoseAnimationDone event, Emitter<MainScreenState> emit) async {
    emit(state.copyWith(screenState: ScreenState.lose));
  }

  FutureOr<void> _setWin(SetWin event, Emitter<MainScreenState> emit) async {
    final nextTile = event.shouldWin ? state.winningTile : Random().nextInt(state.totalTiles);
    emit(state.copyWith(nextTile: nextTile));
  }
}
