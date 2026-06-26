import 'package:flutter_clean_riverpod_boilerplate/data/auth/mapper/auth_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/auth_me_response.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/auth/model/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthResponseMapper.toDomainOrNull', () {
    test('returns AuthUser when nested user is present', () {
      const response = LoginResponse(
        accessToken: 'a',
        refreshToken: 'r',
        userId: 'usr_42',
        userEmail: 'demo@example.com',
      );

      final user = response.toDomainOrNull();

      expect(user, isNotNull);
      expect(user!.id, 'usr_42');
      expect(user.email, 'demo@example.com');
    });

    test('returns null when user id is missing', () {
      const response = LoginResponse(
        accessToken: 'a',
        userEmail: 'demo@example.com',
      );

      expect(response.toDomainOrNull(), isNull);
    });

    test('returns null when user email is missing', () {
      const response = LoginResponse(accessToken: 'a', userId: 'usr_42');

      expect(response.toDomainOrNull(), isNull);
    });

    test('returns null when user email is empty', () {
      const response = LoginResponse(
        accessToken: 'a',
        userId: 'usr_42',
        userEmail: '',
      );

      expect(response.toDomainOrNull(), isNull);
    });

    test('parses a nested user object via fromJson', () {
      final response = LoginResponse.fromJson(const {
        'accessToken': 'a',
        'refreshToken': 'r',
        'user': {'id': 'usr_99', 'email': 'x@y.z'},
      });

      final user = response.toDomainOrNull();

      expect(user, isNotNull);
      expect(user!.id, 'usr_99');
      expect(user.email, 'x@y.z');
    });

    test('parses DummyJSON flat login payload with numeric id', () {
      final response = LoginResponse.fromJson(const {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'accessToken': 'a',
        'refreshToken': 'r',
      });

      final user = response.toDomainOrNull();

      expect(user, isNotNull);
      expect(user!.id, '1');
      expect(user.email, 'emily.johnson@x.dummyjson.com');
    });
  });

  group('AuthMeResponseMapper.toDomain', () {
    test('maps id and email to AuthUser', () {
      const response = AuthMeResponse(
        id: 42,
        email: 'demo@example.com',
        username: 'emilys',
      );

      final user = response.toDomain();

      expect(user.id, '42');
      expect(user.email, 'demo@example.com');
    });
  });
}
