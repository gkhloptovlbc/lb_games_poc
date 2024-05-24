import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc.dart';

abstract class BlocCommand {
  const BlocCommand();
}

// ignore: strict_raw_type
class BlocCommandsListener<B extends BaseBloc> extends StatefulWidget {
  final void Function(BuildContext context, BlocCommand command) listener;
  final Widget child;
  final B? bloc;

  const BlocCommandsListener({
    super.key,
    this.bloc,
    required this.listener,
    required this.child,
  });

  @override
  BlocCommandsListenerState<B> createState() => BlocCommandsListenerState<B>();
}

// ignore: strict_raw_type
class BlocCommandsListenerState<B extends BaseBloc> extends State<BlocCommandsListener<B>> {
  B? _bloc;
  StreamSubscription<BlocCommand>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? BlocProvider.of<B>(context);
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _subscribe() {
    _subscription = _bloc?.commandsStream.listen(
      (command) {
        widget.listener(context, command);
      },
    );
  }

  void _unsubscribe() {
    unawaited(_subscription?.cancel());
    _subscription = null;
  }
}
