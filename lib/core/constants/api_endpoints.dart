/// Single source of truth for every REST path in the app.
///
/// Values must stay `const` so Retrofit annotations can reference them.
/// Path parameters (e.g. `{id}`) are resolved via `@Path` in the API contract.
abstract final class AuthEndpoints {
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
}

abstract final class TodoEndpoints {
  static const String list = '/todos';
  static const String create = '/todos';
  static const String byId = '/todos/{id}';
}
