import 'dart:developer';

import 'package:example/features/auth/auth_provider.dart';
import 'package:example/features/common/presentation/utils/extensions/ui_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Calls [SignInWithGoogleButton] method for sign in process
class SignInWithGoogleButton extends ConsumerWidget {
  /// Default constructor for [SignInWithGoogleButton] widget
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        try {
          ref.read(signInWithGoogleProvider.notifier).signInWithGoogle();
        } catch (e) {
          log(e.toString());
        }
      },
      child: Text(context.tr.signInWithGoogle),
    );
  }
}
