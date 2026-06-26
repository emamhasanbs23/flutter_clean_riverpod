import 'package:dio/dio.dart';
import 'package:flutter_clean_riverpod_boilerplate/core/constants/api_endpoints.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_request.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/refresh_token_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

/// Retrofit-annotated contract for the auth endpoints.
///
/// The class is wired to the same configured `Dio` the rest of the app uses
/// (see `dioProvider` in `core/network/dio_client.dart`), so the
/// `AuthInterceptor` still attaches the bearer token on `login` and recovers
/// from 401s by calling `refresh`. The `refresh` call intentionally drops the
/// `Authorization` header — sending the (now invalid) access token back to
/// the refresh endpoint can cause backends to loop on 401 or reject the
/// request outright.
///
/// Every method accepts an optional [CancelToken] so callers can abort the
/// request when the owning widget is disposed.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST(AuthEndpoints.login)
  Future<LoginResponse> login(
    @Body() LoginRequest request, {
    CancelToken? cancelToken,
  });

  /// Trades a refresh token for a fresh access token.
  ///
  /// Callers should pass
  /// `@DioOptions(extra: {AuthInterceptor.skipAuthKey: true})`
  /// so the `AuthInterceptor` knows not to attach the (likely expired)
  /// access token to this request. The refresh endpoint must work with only
  /// the refresh token in the body.
  @POST(AuthEndpoints.refresh)
  Future<RefreshTokenResponse> refresh(
    @Body() RefreshTokenRequest request, {
    @DioOptions() Options? options,
    CancelToken? cancelToken,
  });

  /// Returns the currently authenticated user. Requires a valid access token
  /// attached by the auth interceptor.
  @GET(AuthEndpoints.me)
  Future<AuthMeResponse> getMe({CancelToken? cancelToken});
}
