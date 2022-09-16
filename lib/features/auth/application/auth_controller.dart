import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:example/features/auth/infrastructure/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni_links/uni_links.dart';

/// State controller for authentication
class AuthController extends StateNotifier<UserEntity?> {
  ///
  AuthController(this._read) : super(null) {
    _initialize();
  }
  final Reader _read;
  AuthRepository get _repository => _read(authRepositoryProvider);

  ///
  Future<void> _initialize() async {
    /// try to restore saved session
    final res = await _repository.restoreSession();
    state = res.fold((l) => null, (r) => r);
    _updateAuthState();
    if (state == null) {
      /// try to create session from deep link
      await _handleInitialDeepLink();
    }

    /// listen to auth changes
    _repository.authStateChange((user) {
      state = user;
      _updateAuthState();
    });
    // TODO(vh): how to cancel subscription override dispose
  }

  void _updateAuthState() {
    authStateListenable.value = state != null;
  }

  ///
  Future<void> _handleInitialDeepLink() async {
    final initialLink = await getInitialLink();
    if (!(initialLink?.contains('refresh_token=') ?? false)) {
      return;
    }

    final refreshTokenQueryParam = initialLink
        ?.split('&')
        .firstWhere((element) => element.contains('refresh_token'));

    final refreshToken = refreshTokenQueryParam
        ?.substring(refreshTokenQueryParam.indexOf('=') + 1);
    if (refreshToken == null) return;

    final res = await _repository.setSession(refreshToken);
    state = res.fold((l) => null, (r) => r);
    _updateAuthState();
  }

  /// Signs out user
  Future<void> signOut() async {
    await _repository.signOut();
  }
}
