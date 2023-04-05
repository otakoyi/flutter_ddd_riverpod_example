import 'dart:convert';

import 'package:example/features/auth/application/auth_controller.dart';
import 'package:example/features/common/infrastructure/entities/environment.dart';
import 'package:example/flavors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

///
/// Infrastructure dependencies
///

/// Exposes [SharedPreferences] instance
final sharedPreferencesProvider =
    FutureProvider((ref) => SharedPreferences.getInstance());

/// Exposes [supabase.Supabase] instance
final supabaseProvider = FutureProvider<supabase.Supabase>((ref) async {
  final configFile = await rootBundle.loadString(F.envFileName);
  final env =
      Environment.fromJson(json.decode(configFile) as Map<String, dynamic>);

  return supabase.Supabase.initialize(
    url: env.supabaseUrl,
    anonKey: env.supabaseAnonKey,
    debug: kDebugMode,
  );
});

/// Exposes [supabase.SupabaseClient] client
final supabaseClientProvider = Provider<supabase.SupabaseClient>(
  (ref) => ref.read(supabaseProvider).asData!.value.client,
);

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
