import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/constants/api_endpoints.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todos_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'todo_api.g.dart';

/// Retrofit-annotated contract for the DummyJSON Todo resource.
///
/// Every method accepts an optional [CancelToken] so callers (typically a
/// Riverpod controller) can abort the request when the owning widget is
/// disposed.
@RestApi()
abstract class TodoApi {
  factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

  @GET(TodoEndpoints.list)
  Future<TodosResponseDto> getTodos({
    @Query('limit') int? limit,
    @Query('skip') int? skip,
    CancelToken? cancelToken,
  });

  @GET(TodoEndpoints.byId)
  Future<TodoDto> getTodo(@Path('id') String id, {CancelToken? cancelToken});

  @POST(TodoEndpoints.create)
  Future<TodoDto> createTodo(
    @Body() CreateTodoRequestDto body, {
    CancelToken? cancelToken,
  });

  @PATCH(TodoEndpoints.byId)
  Future<TodoDto> updateTodo(
    @Path('id') String id,
    @Body() UpdateTodoRequestDto body, {
    CancelToken? cancelToken,
  });

  @DELETE(TodoEndpoints.byId)
  Future<TodoDto> deleteTodo(@Path('id') String id, {CancelToken? cancelToken});
}
