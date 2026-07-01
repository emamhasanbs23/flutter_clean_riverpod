import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';

/// Sealed view of the login submission lifecycle so the UI can render
/// appropriate loading / error states without parsing nullable values.
sealed class LoginState {
  const LoginState();
}

class LoginIdle extends LoginState {
  const LoginIdle();
}

class LoginSubmitting extends LoginState {
  const LoginSubmitting();
}

/// Carries the domain [Failure] so the page can render a localized message
/// via `failure.toMessage(context)` at the render site. We do NOT store a
/// pre-localized string here because BuildContext is unavailable inside
/// the controller and we want one source of truth for failure text.
class LoginError extends LoginState {
  const LoginError(this.failure);
  final Failure failure;
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}
