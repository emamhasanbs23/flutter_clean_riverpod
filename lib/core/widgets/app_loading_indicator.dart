import 'package:flutter/material.dart';

/// Centered, theme-aware loading spinner.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.strokeWidth});

  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 3,
      ),
    );
  }
}
