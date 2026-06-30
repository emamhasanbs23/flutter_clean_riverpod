import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/entity_mappable_options.dart';

part 'auth_user.mapper.dart';

/// Domain representation of an authenticated user.
///
/// Value type via `dart_mappable` (`copyWith`, `==`, `hashCode`, `toString`).
/// Intentionally **does not** implement `fromJson` / `toJson` — domain
/// entities never cross the wire; the data layer translates between wire DTOs
/// and this entity via `AuthMapper`.
@MappableClass(generateMethods: entityGenerateMethods)
class AuthUser with AuthUserMappable {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String email;
}
