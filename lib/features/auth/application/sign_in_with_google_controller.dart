import 'package:example/features/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_google_controller.g.dart';

///
@riverpod
FutureOr<void> signInWithGoogle(SignInWithGoogleRef ref) async {
  await ref.watch(authRepositoryProvider).signInWithGoogle();
}
