import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

/// Convenience extension to reduce boilerplate when asserting on Either values
/// in tests. Inspired by the typical `.shouldBeRight()` / `.shouldBeLeft()`
/// patterns from fpdart_examples, but implemented in terms of plain
/// `fold` to avoid pulling in additional matcher packages.
extension EitherAssertions<L, R> on Either<L, R> {
  /// Asserts the value is [Right] and returns its inner value. Fails the test
  /// if the value is [Left].
  R expectRight() {
    return fold(
      (l) => fail('Expected Right, got Left: $l'),
      (r) => r,
    );
  }

  /// Asserts the value is [Left] and returns its inner value. Fails the test
  /// if the value is [Right].
  L expectLeft() {
    return fold(
      (l) => l,
      (r) => fail('Expected Left, got Right: $r'),
    );
  }
}
