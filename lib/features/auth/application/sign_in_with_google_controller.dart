import 'package:example/features/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_google_controller.g.dart';

///Sign in with google

@riverpod
class SignInWithGoogleController extends _$SignInWithGoogleController {
  @override
  FutureOr<bool> build() {
    return false;
  }

  /// Signs in using Supabase auth
  Future<void> signInWithGoogle() async {
    final res = await ref.read(authRepositoryProvider).signInWithGoogle();
    res.fold((l) {
      state = AsyncError(l, StackTrace.current);
    }, (r) {
      state = AsyncData(r);
    });
  }
}
