import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_lifecycle/app_lifecycle.dart';
import '../audio/audio_controller.dart';
import '../settings/settings.dart';

class AppHarness extends StatelessWidget {
  const AppHarness({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          Provider(create: (context) => SettingsController()),
          // Set up audio.
          ProxyProvider2<AppLifecycleStateNotifier, SettingsController, AudioController>(
            create: (context) => AudioController(),
            update: (context, lifecycleNotifier, settings, audio) {
              audio!.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
            // Ensures that music starts immediately.
            lazy: false,
          ),
        ],
        child: child,
      ),
    );
  }
}
