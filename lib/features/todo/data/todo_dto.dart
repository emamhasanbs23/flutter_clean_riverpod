/// Wire-format representation of a Todo. Mirrors the API/JSON payload and
/// is decoupled from the domain [Todo] so we can evolve them independently.
///
/// Plain Dart class with manual `fromJson`/`toJson`. We avoid
/// `json_serializable` here to keep the boilerplate free of codegen overhead.
class TodoDto {
  const TodoDto({
    required this.id,
    required this.title,
    this.completed = false,
    this.createdAt,
  });

  final String id;
  final String title;
  final bool completed;
  final DateTime? createdAt;

  factory TodoDto.fromJson(Map<String, dynamic> json) {
    return TodoDto(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  TodoDto copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
  }) {
    return TodoDto(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TodoDto &&
        other.id == id &&
        other.title == title &&
        other.completed == completed &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, completed, createdAt);

  @override
  String toString() {
    return 'TodoDto(id: $id, title: $title, completed: $completed, '
        'createdAt: $createdAt)';
  }
}