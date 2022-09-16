import 'package:example/app.dart';
import 'package:example/bootstrap.dart';
import 'package:example/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  F.appFlavor = Flavor.local;
  runApp(
    UncontrolledProviderScope(
      container: await bootstrap(),
      child: const ExampleApp(),
    ),
  );
}
