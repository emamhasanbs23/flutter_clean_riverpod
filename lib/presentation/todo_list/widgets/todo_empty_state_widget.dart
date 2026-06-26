import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/app_size.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/theme/theme_context_extension.dart';

/// Empty list placeholder that remains scrollable for [RefreshIndicator].
class TodoEmptyStateWidget extends StatelessWidget {
  const TodoEmptyStateWidget({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height:
              MediaQuery.sizeOf(context).height *
              AppSize.emptyStateTopOffsetFactor,
        ),
        Center(child: Text(message, style: context.textTheme.bodyLarge)),
      ],
    );
  }
}
