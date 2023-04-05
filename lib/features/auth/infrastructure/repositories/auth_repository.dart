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
  UserEntity? get currentUser => authClient.currentUser == null
      ? null
      : UserEntity.fromJson(authClient.currentUser!.toJson());

  /// Returns Stream with auth user changes
  @override
  void authStateChange(
    void Function(UserEntity? userEntity) callback,
  ) {
    authClient.onAuthStateChange.listen((data) {
      switch (data.event) {
        case supabase.AuthChangeEvent.signedIn:
          callback(
            UserEntity.fromJson(data.session!.user.toJson()),
          );

          break;
        case supabase.AuthChangeEvent.signedOut:
          callback(null);
          break;
        case supabase.AuthChangeEvent.userUpdated:
          callback(
            UserEntity.fromJson(data.session!.user.toJson()),
          );
          break;
        case supabase.AuthChangeEvent.passwordRecovery:
        case supabase.AuthChangeEvent.tokenRefreshed:
        case supabase.AuthChangeEvent.userDeleted:
        case supabase.AuthChangeEvent.mfaChallengeVerified:
      }
    });
  }

  ///
  @override
  Future<Either<Failure, UserEntity>> setSession(String token) async {
    final response = await authClient.setSession(token);
    await authTokenLocalDataSource
        .store(response.session?.persistSessionString ?? '');

    final data = response.session;

    if (data == null) {
      await authTokenLocalDataSource.remove();
      return left(Failure.unauthorized(StackTrace.current));
    }

    return right(UserEntity.fromJson(data.user.toJson()));
  }

  /// Recovers session from local storage and refreshes tokens
  @override
  Future<Either<Failure, UserEntity>> restoreSession() async {
    final res = authTokenLocalDataSource.get();
    if (res.isLeft()) {
      return left(Failure.empty(StackTrace.current));
    }

    final response = await authClient.recoverSession(res.getOrElse((_) => ''));
    final data = response.session;

    if (response.session == null) {
      await authTokenLocalDataSource.remove();
      return left(Failure.unauthorized(StackTrace.current));
    }

    await authTokenLocalDataSource
        .store(response.session?.persistSessionString ?? '');

    return right(UserEntity.fromJson(data!.user.toJson()));
  }

  /// Signs in user to the application
  @override
  Future<Either<Failure, bool>> signInWithGoogle() async {
    log('here2');
    final res = await authClient.signInWithOAuth(
      supabase.Provider.google,
    );
    if (!res) {
      return left(Failure.badRequest(StackTrace.current));
    }
    return right(true);
  }

  /// Signs out user from the application
  @override
  Future<Either<Failure, bool>> signOut() async {
    await authTokenLocalDataSource.remove();
    try {
      await authClient.signOut();
      return right(true);
    } catch (e) {
      return left(Failure.badRequest(StackTrace.current));
    }
  }
}
