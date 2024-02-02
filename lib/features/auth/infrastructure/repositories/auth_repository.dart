import 'dart:developer';

import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:example/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:example/features/auth/infrastructure/datasources/local/auth_token_local_data_source.dart';
import 'package:example/features/common/domain/failures/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Repository that handles authorization and persists session
class AuthRepository implements AuthRepositoryInterface {
  /// Default constructor
  AuthRepository(this.authTokenLocalDataSource, this.authClient);

  /// local token storage provider
  final AuthTokenLocalDataSource authTokenLocalDataSource;

  /// Exposes Supabase auth client to allow Auth Controller to subscribe to auth changes
  final supabase.GoTrueClient authClient;

  /// Current authorized User
  UserEntity? get currentUser =>
      authClient.currentUser == null ? null : UserEntity.fromJson(authClient.currentUser!.toJson());

  /// Returns Stream with auth user changes
  @override
  void authStateChange(
    void Function(UserEntity? userEntity) callback,
  ) {
    authClient.onAuthStateChange.listen((data) {
      switch (data.event) {
        case supabase.AuthChangeEvent.signedIn:
        case supabase.AuthChangeEvent.userUpdated:
        case supabase.AuthChangeEvent.initialSession when data.session?.user != null:
        case supabase.AuthChangeEvent.mfaChallengeVerified:
          callback(
            UserEntity.fromJson(data.session!.user.toJson()),
          );

          break;
        case supabase.AuthChangeEvent.signedOut:
        case supabase.AuthChangeEvent.userDeleted:
          callback(null);
          break;
        case supabase.AuthChangeEvent.passwordRecovery:
        case supabase.AuthChangeEvent.tokenRefreshed:
        default:
          break;
      }
    });
  }

  ///
  @override
  Future<Either<Failure, UserEntity>> setSession(String token) async {
    try {
      final response = await authClient.setSession(token);
      await authTokenLocalDataSource.store(response.session?.providerToken ?? '');

      final user = response.user;

      if (user == null) {
        await authTokenLocalDataSource.remove();
        return left(const Failure.unauthorized());
      }

      return right(UserEntity.fromJson(user.toJson()));
    } catch (_) {
      return left(const Failure.unauthorized());
    }
  }

  /// Recovers session from local storage and refreshes tokens
  @override
  Future<Either<Failure, UserEntity>> restoreSession() async {
    try {
      final res = authTokenLocalDataSource.get();
      if (res.isLeft()) {
        return left(const Failure.empty());
      }

      final response = await authClient.recoverSession(res.getOrElse((_) => ''));
      final user = response.user;

      if (user == null) {
        await authTokenLocalDataSource.remove();
        return left(const Failure.unauthorized());
      }

      await authTokenLocalDataSource.store(response.session?.providerToken ?? '');

      return right(UserEntity.fromJson(user.toJson()));
    } catch (_) {
      return left(const Failure.unauthorized());
    }
  }

  /// Signs in user to the application
  @override
  Future<Either<Failure, bool>> signInWithGoogle() async {
    log('here2');
    final res = await authClient.signInWithOAuth(
      supabase.OAuthProvider.google,
    );
    if (!res) {
      return left(const Failure.badRequest());
    }
    return right(true);
  }

  /// Signs out user from the application
  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await authTokenLocalDataSource.remove();

      await authClient.signOut();
      return right(true);
    } catch (_) {
      return left(const Failure.badRequest());
    }
  }
}
