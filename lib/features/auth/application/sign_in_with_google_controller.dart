import 'dart:developer';

import 'package:example/features/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///s
class SignInWithGoogleController extends StateNotifier<bool> {
  ///
  SignInWithGoogleController(this._read) : super(false);
  final Reader _read;

  /// Signs in using Supabase auth
  Future<void> signInWithGoogle() async {
    log('here');
    await _read(authRepositoryProvider).signInWithGoogle();
  }
}
