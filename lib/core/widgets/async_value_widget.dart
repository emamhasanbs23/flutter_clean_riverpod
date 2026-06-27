import 'package:flutter/material.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_error_widget.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/widgets/app_loading_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Renders [AsyncValue] loading / error / data branches with the app's
/// standard [AppLoadingIndicator] and [AppErrorWidget].
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.data,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => value.when(
    loading: () => const AppLoadingIndicator(),
    error: (error, _) => AppErrorWidget(
      failure: error is Failure ? error : UnexpectedFailure(error.toString()),
      onRetry: onRetry,
    ),
    data: data,
  );
}
