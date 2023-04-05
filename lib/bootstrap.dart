import 'package:example/config/providers.dart' as providers;
import 'package:example/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

/// Initializes services and controllers before the start of the application
Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  final container = ProviderContainer(
    overrides: [], //supabaseProvider.overrideWithValue(Supabase.instance)
    observers: [if (F.appFlavor == Flavor.local) _Logger()],
  );
  await providers.initializeProviders(container);
  return container;
}

class _Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '''
      {
      "provider": "${provider.name ?? provider.runtimeType}",
      "newValue": "$newValue"
      }''',
    );
  }
}
