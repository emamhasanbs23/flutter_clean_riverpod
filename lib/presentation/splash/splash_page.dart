import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';

/// Shown while auth state resolves on cold start.
///
/// Keeps protected routes (todo list, detail) off the widget tree so their
/// controllers do not fire network requests before auth is known.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AppLoadingIndicator());
  }
}
