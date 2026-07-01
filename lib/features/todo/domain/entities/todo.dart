import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/entity_mappable_options.dart';

part 'todo.mapper.dart';

/// Domain entity for a Todo item.
///
/// Value type via `dart_mappable` (`copyWith`, `==`, `hashCode`, `toString`).
/// Intentionally **does not** implement `fromJson` / `toJson` — domain
/// entities never cross the wire; the data layer translates between
/// `TodoDto` (wire format) and this entity via `todo_mapper.dart`.
@MappableClass(generateMethods: entityGenerateMethods)
class Todo with TodoMappable {
  const Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;
}
