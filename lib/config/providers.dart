import 'package:example/features/auth/application/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'providers.g.dart';

///
/// Infrastructure dependencies
///

/// Exposes [SharedPreferences] instance
@Riverpod(keepAlive: true)
FutureOr<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

/// Exposes [Supabase] instance

/// Exposes [SupabaseClient] client
@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
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

  /// Auth
  container.read(authControllerProvider);
}
