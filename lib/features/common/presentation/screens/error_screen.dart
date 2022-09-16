import 'package:flutter/material.dart';

/// Default error page
class ErrorScreen extends StatelessWidget {
  /// Default constructor for the [ErrorScreen]
  const ErrorScreen({super.key, required this.message});

  /// Error message displayed on the [ErrorScreen]
  final String message;

  @override
  Widget build(BuildContext context) {
    // Todo: let's stylize it at some point
    return Scaffold(
      body: Center(child: Text(message)),
    );
  }
}
