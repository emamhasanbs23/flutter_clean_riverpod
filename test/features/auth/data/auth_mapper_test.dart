import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/mapper/auth_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/features/auth/data/model/login_response.dart';
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
      const response = LoginResponse(
        accessToken: 'a',
        userId: 'usr_42',
      );

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
        'access_token': 'a',
        'refresh_token': 'r',
        'user': {'id': 'usr_99', 'email': 'x@y.z'},
      });

      final user = response.toDomainOrNull();

      expect(user, isNotNull);
      expect(user!.id, 'usr_99');
      expect(user.email, 'x@y.z');
    });
  });
}
