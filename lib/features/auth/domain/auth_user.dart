/// Domain representation of an authenticated user.
///
/// The boilerplate uses a minimal stub: the only required field is the email.
/// Add fields (displayName, avatarUrl, roles) as the real backend exposes
/// them.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;
}
