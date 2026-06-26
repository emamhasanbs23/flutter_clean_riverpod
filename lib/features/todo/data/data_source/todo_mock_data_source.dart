import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/data_source/todo_remote_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';

/// In-memory data source used to demonstrate the full Clean Architecture
/// flow without depending on a real backend.
///
/// Simulates network latency via `Future.delayed` so loading states and error
/// paths can be exercised realistically. The list lives in memory only;
/// mutations are visible for the app's lifetime.
///
/// The optional `CancelToken` mirrors the contract of `TodoRemoteDataSource`
/// so callers can wire lifecycle cancellation uniformly. The mock does not
/// check the token — a real data source cancels the in-flight request,
/// which is the behavior we want to simulate in widget-level smoke tests.
class TodoMockDataSource implements TodoDataSource {
  TodoMockDataSource({Duration? latency})
    : _latency = latency ?? const Duration(milliseconds: 300) {
    _seed();
  }

  final Duration _latency;
  final List<TodoDto> _todos = [];

  @override
  Future<List<TodoDto>> fetchAll({CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    // Return a copy so callers cannot mutate the source of truth.
    return List.unmodifiable(_todos.map((t) => t));
  }

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    final dto = TodoDto(
      id: _generateId(),
      title: title,
      createdAt: DateTime.now(),
    );
    _todos.insert(0, dto);
    return dto;
  }

  @override
  Future<TodoDto> toggle(String id, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    final index = _todos.indexWhere((t) => t.id == id);
    if (index < 0) {
      throw NotFoundFailure('Todo not found: $id');
    }
    final updated = _todos[index].copyWith(completed: !_todos[index].completed);
    _todos[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    _todos.removeWhere((t) => t.id == id);
  }

  void _seed() {
    final now = DateTime.now();
    _todos.addAll([
      TodoDto(
        id: _generateId(),
        title: 'Read the Clean Architecture book',
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
