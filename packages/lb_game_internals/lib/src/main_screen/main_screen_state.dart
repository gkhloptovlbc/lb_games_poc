import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum ScreenState {
  start,
  play,
  winAnimation,
  win,
  lose,
}

@immutable
class MainScreenState extends Equatable {
  final ScreenState screenState;

  final int totalTiles;
  final int currentTile;
  final int winningTile;
  final int nextTile;

  final prizeImageUrl =
      "https://c.sandbox.barcodes-aws.no/game-68c4ad3b-6444-48d1-a7d5-491bc69fd75a.jpg?v0.5852917086249558";
  final catImageUrl = "https://c.sandbox.barcodes-aws.no/schedule-ea20570f-738f-4add-968d-2edd663c6c08.jpg?v0.1548848594604384";

  const MainScreenState({
    required this.screenState,
    required this.totalTiles,
    required this.currentTile,
    required this.winningTile,
    required this.nextTile,
  });

  const MainScreenState.initial()
      : this(
          screenState: ScreenState.start,
          totalTiles: 13,
          currentTile: 0,
          winningTile: 4,
          nextTile: 4,
        );

  MainScreenState copyWith({
    ScreenState? screenState,
    int? totalTiles,
    int? currentTile,
    int? winningTile,
    int? nextTile,
  }) {
    return MainScreenState(
      screenState: screenState ?? this.screenState,
      totalTiles: totalTiles ?? this.totalTiles,
      currentTile: currentTile ?? this.currentTile,
      winningTile: winningTile ?? this.winningTile,
      nextTile: nextTile ?? this.nextTile,
    );
  }

  @override
  List<Object> get props => [
        screenState,
        totalTiles,
        currentTile,
        winningTile,
        nextTile,
      ];
}
