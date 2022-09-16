import 'package:example/config/router.dart';
import 'package:example/config/theme.dart';
import 'package:example/flavors.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Main example app class
class ExampleApp extends StatelessWidget {
  /// Default constructor for Example app
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: F.title,
      theme: AppTheme(Brightness.light).themeData,
      darkTheme: AppTheme(Brightness.dark).themeData,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
