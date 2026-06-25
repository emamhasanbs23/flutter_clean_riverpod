import 'dart:async';

import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/todo_remote_data_source.dart';

/// In-memory data source used to demonstrate the full Clean Architecture
/// flow without depending on a real backend.
///
/// Simulates network latency via [Future.delayed] so loading states and error
/// paths can be exercised realistically. The list lives in memory only;
/// mutations are visible for the app's lifetime.
class TodoMockDataSource implements TodoDataSource {
  TodoMockDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 300) {
    _seed();
  }

  final Duration _latency;
  final List<TodoDto> _todos = [];

  Future<List<TodoDto>> fetchAll() async {
    await Future<void>.delayed(_latency);
    // Return a copy so callers cannot mutate the source of truth.
    return List.unmodifiable(_todos.map((t) => t));
  }

  Future<TodoDto> create(String title) async {
    await Future<void>.delayed(_latency);
    final dto = TodoDto(
      id: _generateId(),
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );
    _todos.insert(0, dto);
    return dto;
  }

  Future<TodoDto> toggle(String id) async {
    await Future<void>.delayed(_latency);
    final index = _todos.indexWhere((t) => t.id == id);
    if (index < 0) {
      throw StateError('Todo not found: $id');
    }
    final updated = _todos[index].copyWith(completed: !_todos[index].completed);
    _todos[index] = updated;
    return updated;
  }

  Future<void> delete(String id) async {
    await Future<void>.delayed(_latency);
    _todos.removeWhere((t) => t.id == id);
  }

  void _seed() {
    final now = DateTime.now();
    _todos.addAll([
      TodoDto(
        id: _generateId(),
        title: 'Read the Clean Architecture book',
        completed: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      TodoDto(
        id: _generateId(),
        title: 'Wire up Riverpod providers',
        completed: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      TodoDto(
        id: _generateId(),
        title: 'Ship the boilerplate 🚀',
        completed: false,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
    ]);
  }

  String _generateId() {
    // Timestamp + random suffix — collision-resistant enough for an in-memory
    // mock and obviously not a real UUID.
    final stamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final suffix = (DateTime.now().millisecond * 31).toRadixString(36);
    return 'todo_$stamp$suffix';
  }
}