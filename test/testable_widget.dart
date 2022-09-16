import 'package:example/config/theme.dart';
import 'package:example/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget makeTestableWidget({
  required Widget child,
  ProviderContainer? container,
}) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      theme: AppTheme(Brightness.light).themeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: UncontrolledProviderScope(
        container: container ?? ProviderContainer(),
        child: Material(
          child: child,
        ),
      ),
    ),
  );
}
