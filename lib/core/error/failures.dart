import 'package:flutter/widgets.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';

/// Base type for all domain-level failures.
///
/// Repositories return [Failure] inside [Either] values so the presentation
/// layer can branch on the concrete subtype without leaking exceptions.
sealed class Failure {
  const Failure(this.message);

  /// Human-readable fallback description. Use [toMessage] when you have a
  /// [BuildContext] available so localized strings can be used instead.
  final String message;

  /// Maps this failure to a localized message for the user.
  String toMessage(BuildContext context) {
    return switch (this) {
      NetworkFailure() => context.l10n.errorNetwork,
      UnauthorizedFailure() => context.l10n.errorUnauthorized,
      NotFoundFailure() => context.l10n.errorNotFound,
      UnexpectedFailure() => context.l10n.errorUnexpected,
      InvalidCredentialsFailure() => context.l10n.loginInvalidCredentials,
    };
  }
}

/// Auth-specific failure subtype. Lives in the core library because
/// [Failure] is sealed and cannot be extended from other libraries.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure()
      : super('Invalid email or password');
}

/// Connectivity / transport errors. Wraps [DioException] and friends.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

/// HTTP 401 / 403 — caller must re-authenticate.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

/// HTTP 404 or "missing" semantics from the data source.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

/// Anything that did not match a known category. Use sparingly — prefer
/// adding a specific subtype when the UI needs to react differently.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected error']);
}