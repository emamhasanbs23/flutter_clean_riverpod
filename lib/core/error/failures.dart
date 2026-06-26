import 'package:dio/dio.dart' show DioException;
import 'package:flutter/widgets.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/l10n/l10n_extension.dart';
import 'package:fpdart/fpdart.dart' show Either;

/// Base type for all domain-level failures.
///
/// Repositories return [Failure] inside [Either] values so the presentation
/// layer can branch on the concrete subtype without leaking exceptions.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Human-readable fallback description. Use [toMessage] when you have a
  /// [BuildContext] available so localized strings can be used instead.
  final String message;

  /// Maps this failure to a localized message for the user.
  String toMessage(BuildContext context) {
    return switch (this) {
      NoConnectionFailure() => context.l10n.errorNoConnection,
      TimeoutFailure() => context.l10n.errorTimeout,
      ServerFailure() => context.l10n.errorServer,
      NetworkFailure() => context.l10n.errorNetwork,
      UnauthorizedFailure() => context.l10n.errorUnauthorized,
      NotFoundFailure() => context.l10n.errorNotFound,
      ValidationFailure(:final errors) =>
        errors?.values.firstOrNull ?? context.l10n.errorValidation,
      RateLimitFailure() => context.l10n.errorRateLimit,
      CancelledFailure() => context.l10n.errorCancelled,
      SerializationFailure() => context.l10n.errorSerialization,
      UnexpectedFailure() => context.l10n.errorUnexpected,
      InvalidCredentialsFailure() => context.l10n.loginInvalidCredentials,
    };
  }
}

// ============================================================================
// Transport / Connectivity Failures
// ============================================================================

/// No network connection (device offline, airplane mode, no interface).
final class NoConnectionFailure extends Failure {
  const NoConnectionFailure() : super('No internet connection');
}

/// Request timed out (connect, send, or receive timeout).
final class TimeoutFailure extends Failure {
  const TimeoutFailure() : super('Request timed out');
}

/// Connectivity / transport errors not covered by more specific subtypes.
/// Wraps [DioException] connection issues.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

/// Request was cancelled (e.g., widget disposed, user navigated away).
final class CancelledFailure extends Failure {
  const CancelledFailure() : super('Request cancelled');
}

// ============================================================================
// HTTP Status-Based Failures
// ============================================================================

/// HTTP 5xx — server-side errors.
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

/// HTTP 401 / 403 — caller must re-authenticate.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

/// HTTP 404 or "missing" semantics from the data source.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Not found']);
}

/// HTTP 400 / 422 — validation errors with optional field-level messages.
final class ValidationFailure extends Failure {
  const ValidationFailure({this.errors}) : super('Validation failed');

  /// Field-level error messages: {fieldName: errorMessage}
  final Map<String, String>? errors;
}

/// HTTP 429 — rate limit exceeded.
final class RateLimitFailure extends Failure {
  const RateLimitFailure({this.retryAfter})
    : super('Rate limit exceeded. Please try again later.');

  /// Seconds until the rate limit resets, if provided by the server.
  final int? retryAfter;
}

// ============================================================================
// Data / Serialization Failures
// ============================================================================

/// JSON parsing or deserialization failed.
final class SerializationFailure extends Failure {
  const SerializationFailure([super.message = 'Failed to parse response']);
}

// ============================================================================
// Auth-Specific Failures
// ============================================================================

/// Auth-specific failure subtype. Lives in the core library because
/// [Failure] is sealed and cannot be extended from other libraries.
final class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('Invalid username or password');
}

// ============================================================================
// Catch-All Failure
// ============================================================================

/// Anything that did not match a known category. Use sparingly — prefer
/// adding a specific subtype when the UI needs to react differently.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected error']);
}
