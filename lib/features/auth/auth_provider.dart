import 'package:example/config/providers.dart';
import 'package:example/features/auth/application/auth_controller.dart';
import 'package:example/features/auth/application/sign_in_with_google_controller.dart';
import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:example/features/auth/infrastructure/datasources/local/auth_token_local_data_source.dart';
import 'package:example/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///
/// Infrastructure dependencies
///

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authClient = ref.watch(supabaseClientProvider).auth;
  final prefs = ref.read(sharedPreferencesProvider).asData!.value;
  return AuthRepository(
    AuthTokenLocalDataSource(
      prefs,
    ),
    authClient,
  );
});

///
/// Application dependencies
///

/// Provides a [ValueNotifier] to the app router to redirect on auth state change
final authStateListenable = ValueNotifier<bool>(false);

///
final authControllerProvider =
    StateNotifierProvider<AuthController, UserEntity?>((ref) {
  return AuthController(ref.read);
});

///
final signInWithGoogleProvider =
    StateNotifierProvider<SignInWithGoogleController, bool>((ref) {
  return SignInWithGoogleController(ref.read);
});

///
/// Presentation dependencies
///
