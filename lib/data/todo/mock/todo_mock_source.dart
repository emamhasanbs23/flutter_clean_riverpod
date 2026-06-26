import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/data_source/todo_data_source.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todos_response_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/remote/todo_remote_source.dart';

/// In-memory data source used to demonstrate the full Clean Architecture
/// flow without depending on a real backend.
class TodoMockSource implements TodoDataSource {
  TodoMockSource({Duration? latency})
    : _latency = latency ?? const Duration(milliseconds: 300) {
    _seed();
  }

  final Duration _latency;
  final List<TodoDto> _todos = [];
  int _nextId = 100;

  @override
  Future<TodosResponseDto> fetchPage({
    required int limit,
    required int skip,
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(_latency);
    final page = _todos.skip(skip).take(limit).toList(growable: false);
    return TodosResponseDto(
      todos: page,
      total: _todos.length,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<TodoDto> fetchById(String id, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    final index = _todos.indexWhere((t) => t.id.toString() == id);
    if (index < 0) {
      throw NotFoundFailure('Todo not found: $id');
    }
    return _todos[index];
  }

  @override
  Future<TodoDto> create(String title, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    final dto = TodoDto(
      id: _nextId++,
      todo: title,
      userId: TodoRemoteSourceImpl.defaultUserId,
    );
    _todos.insert(0, dto);
    return dto;
  }

  @override
  Future<TodoDto> toggle(
    String id, {
    required bool completed,
    CancelToken? cancelToken,
  }) async {
    await Future<void>.delayed(_latency);
    final index = _todos.indexWhere((t) => t.id.toString() == id);
    if (index < 0) {
      throw NotFoundFailure('Todo not found: $id');
    }
    final updated = _todos[index].copyWith(completed: completed);
    _todos[index] = updated;
    return updated;
  }

  @override
  Future<void> delete(String id, {CancelToken? cancelToken}) async {
    await Future<void>.delayed(_latency);
    _todos.removeWhere((t) => t.id.toString() == id);
  }

  void _seed() {
    _todos.addAll([
      const TodoDto(id: 1, todo: 'Read the Clean Architecture book', userId: 1),
      const TodoDto(
        id: 2,
        todo: 'Wire up Riverpod providers',
        completed: true,
        userId: 1,
      ),
      const TodoDto(id: 3, todo: 'Ship the boilerplate 🚀', userId: 1),
    ]);
    _nextId = 4;
  }
}
