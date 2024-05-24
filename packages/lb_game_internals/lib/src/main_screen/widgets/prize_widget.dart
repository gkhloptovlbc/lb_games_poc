import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main_screen_bloc.dart';
import '../main_screen_state.dart';

class PrizeWidget extends StatelessWidget {
  const PrizeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return CachedNetworkImage(
          key: Key(state.prizeImageUrl),
          imageUrl: state.prizeImageUrl,
        );
      },
    );
  }
}
