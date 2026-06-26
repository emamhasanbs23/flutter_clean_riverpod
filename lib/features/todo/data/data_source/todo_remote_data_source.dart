import 'package:dio/dio.dart';

import 'package:flutter_clean_riverpod_boilerplate/core/error/dio_failure_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/error/failures.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/logger/app_logger.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';

/// Contract every Todo data source must satisfy. The mock implementation
/// in [TodoMockDataSource] and the Dio-backed implementation in
/// [TodoRemoteDataSource] both satisfy this interface so the repository can
/// swap them via a single provider override.
abstract interface class TodoDataSource {
  Future<List<TodoDto>> fetchAll();
  Future<TodoDto> create(String title);
  Future<TodoDto> toggle(String id);
  Future<void> delete(String id);
}

/// Real network-backed implementation that talks to the configured API.
///
/// Uses [Dio] for the round-trip and [mapDioExceptionToFailure] to translate
/// transport / HTTP errors into domain [Failure]s before throwing, so the
/// repository can simply re-throw and let its catch block build the Either.
///
/// The default endpoint targets jsonplaceholder.typicode.com — a public,
/// no-auth test API that mirrors the shape of a real Todo REST backend
/// (`GET /todos`, `POST /todos`, etc). The URL prefix is configurable so a
/// real backend can swap in by overriding the FlavorConfig baseUrl.
class TodoRemoteDataSource implements TodoDataSource {
  TodoRemoteDataSource(this._dio, {String resourcePath = '/todos'})
      : _resourcePath = resourcePath;

  static const _titleField = 'title';
  static const _completedField = 'completed';

  final Dio _dio;
  final String _resourcePath;

  @override
  Future<List<TodoDto>> fetchAll() async {
    try {
      final response = await _dio.get<List<dynamic>>(_resourcePath);
      final raw = response.data ?? const <dynamic>[];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(TodoDto.fromJson)
          .toList(growable: false);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'TodoRemoteDataSource.fetchAll failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  @override
  Future<TodoDto> create(String title) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        _resourcePath,
        data: {_titleField: title, _completedField: false},
      );
      final data = response.data;
      if (data == null) {
        throw const UnexpectedFailure('Empty response from create todo');
      }
      return TodoDto.fromJson(data);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'TodoRemoteDataSource.create failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  @override
  Future<TodoDto> toggle(String id) async {
    try {
      // jsonplaceholder doesn't accept PATCH; fall back to PUT with the
      // toggled value. For a real backend this would be a PATCH.
      final current = await _dio.get<Map<String, dynamic>>(
        '$_resourcePath/$id',
      );
      final body = current.data;
      if (body == null) {
        throw const NotFoundFailure('Todo not found');
      }
      final flipped = !(_boolField(body, _completedField) ?? false);
      final response = await _dio.put<Map<String, dynamic>>(
        '$_resourcePath/$id',
        data: {...body, _completedField: flipped},
      );
      final data = response.data;
      if (data == null) {
        throw const UnexpectedFailure('Empty response from toggle todo');
      }
      return TodoDto.fromJson(data);
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'TodoRemoteDataSource.toggle failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dio.delete<void>('$_resourcePath/$id');
    } on DioException catch (error, stackTrace) {
      AppLogger.e(
        'TodoRemoteDataSource.delete failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw mapDioExceptionToFailure(error);
    }
  }

  bool? _boolField(Map<String, dynamic> json, String key) {
    final value = json[key];
    return value is bool ? value : null;
  }
}
