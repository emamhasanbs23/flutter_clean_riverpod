import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/constants/api_endpoints.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/todo/data/model/todo_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'todo_api.g.dart';

/// Retrofit-annotated contract for the Todo resource.
///
/// The default base path is `/todos`; jsonplaceholder.typicode.com exposes
/// the same shape, so a real backend can plug in via the base URL of the
/// configured `Dio` without further changes.
///
/// Every method accepts an optional [CancelToken] so callers (typically a
/// Riverpod controller) can abort the request when the owning widget is
/// disposed. Retrofit forwards the token through `Options.cancelToken` and
/// `Dio` cancels the in-flight request, throwing `DioExceptionType.cancel`.
@RestApi()
abstract class TodoApi {
  factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

  @GET(TodoEndpoints.list)
  Future<List<TodoDto>> getTodos({CancelToken? cancelToken});

  @POST(TodoEndpoints.create)
  Future<TodoDto> createTodo(@Body() TodoDto body, {CancelToken? cancelToken});

  /// jsonplaceholder does not accept PATCH, so this is a `@PUT` carrying
  /// the full updated record. A real backend that supports PATCH can swap
  /// this annotation without changing call sites.
  @PUT(TodoEndpoints.byId)
  Future<TodoDto> updateTodo(
    @Path('id') String id,
    @Body() TodoDto body, {
    CancelToken? cancelToken,
  });

  @DELETE(TodoEndpoints.byId)
  Future<void> deleteTodo(@Path('id') String id, {CancelToken? cancelToken});
}
