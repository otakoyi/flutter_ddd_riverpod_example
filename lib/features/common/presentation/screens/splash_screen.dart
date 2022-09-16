import 'package:flutter/material.dart';

/// Default app splash screen
class SplashScreen extends StatelessWidget {
  /// Default constructor for [SplashScreen]
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Todo: let's stylize it at some point
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
