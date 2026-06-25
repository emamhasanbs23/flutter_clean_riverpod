/// Domain entity for a Todo item.
///
/// Plain Dart class with value semantics (`copyWith`, `==`, `hashCode`,
/// `toString`) so call sites can treat instances immutably. We intentionally
/// avoid `freezed` here to keep the boilerplate light and free of
/// codegen-time complexity.
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.completed,
    this.createdAt,
  });

  final String id;
  final String title;
  final bool completed;
  final DateTime? createdAt;

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo &&
        other.id == id &&
        other.title == title &&
        other.completed == completed &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, completed, createdAt);

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, completed: $completed, '
        'createdAt: $createdAt)';
  }
}
