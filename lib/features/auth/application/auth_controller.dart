import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/auth/domain/entities/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uni_links/uni_links.dart';

part 'auth_controller.g.dart';

/// State controller for authentication
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<UserEntity?> build() async {
    final repository = ref.watch(authRepositoryProvider);
    final res = await repository.restoreSession();
    state = res.fold((l) => AsyncError(l.error, l.stackTrace), AsyncData.new);
    _updateAuthState();
    if (state.valueOrNull == null) {
      /// try to create session from deep link
      await _handleInitialDeepLink();
    }

    /// listen to auth changes
    repository.authStateChange((user) {
      state = AsyncData(user);
      _updateAuthState();
    });
    return null;
  }

  void _updateAuthState() {
    authStateListenable.value = state.valueOrNull != null;
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

    final res = await ref.read(authRepositoryProvider).setSession(refreshToken);
    state = res.fold((l) => AsyncError(l.error, l.stackTrace), AsyncData.new);
    _updateAuthState();
  }

  /// Signs out user
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
