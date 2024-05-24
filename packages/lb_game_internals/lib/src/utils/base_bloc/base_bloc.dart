import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_command.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final _commandsController = StreamController<BlocCommand>.broadcast();

  BaseBloc(super.initialState);

  Stream<BlocCommand> get commandsStream => _commandsController.stream;

  void sendCommand(BlocCommand command) {
    _commandsController.add(command);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    await _commandsController.close();
    return super.close();
  }
}
