import 'dart:convert';

import 'package:example/features/auth/application/auth_controller.dart';
import 'package:example/features/common/infrastructure/entities/environment.dart';
import 'package:example/flavors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'providers.g.dart';

///
/// Infrastructure dependencies
///

/// Exposes [SharedPreferences] instance
@riverpod
FutureOr<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

/// Exposes [Supabase] instance

@riverpod
FutureOr<Supabase> supabase(SupabaseRef ref) async {
  final configFile = await rootBundle.loadString(F.envFileName);
  final env = Environment.fromJson(json.decode(configFile) as Map<String, dynamic>);

  return Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseAnonKey,
    debug: kDebugMode,
  );
}

/// Exposes [SupabaseClient] client
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return ref.watch(supabaseProvider).valueOrNull!.client;
}

///
/// Application dependencies
///

///
/// Presentation dependencies
///
///

/// Triggered from bootstrap() to complete futures
Future<void> initializeProviders(ProviderContainer container) async {
  /// Core
  await container.read(sharedPreferencesProvider.future);
  await container.read(supabaseProvider.future);

  /// Auth
  container.read(authControllerProvider);
}
