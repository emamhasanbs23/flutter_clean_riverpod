// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_user.dart';

class AuthUserMapper extends ClassMapperBase<AuthUser> {
  AuthUserMapper._();

  static AuthUserMapper? _instance;
  static AuthUserMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthUserMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthUser';

  static String _$id(AuthUser v) => v.id;
  static const Field<AuthUser, String> _f$id = Field('id', _$id);
  static String _$email(AuthUser v) => v.email;
  static const Field<AuthUser, String> _f$email = Field('email', _$email);

  @override
  final MappableFields<AuthUser> fields = const {#id: _f$id, #email: _f$email};

  static AuthUser _instantiate(DecodingData data) {
    return AuthUser(id: data.dec(_f$id), email: data.dec(_f$email));
  }

  @override
  final Function instantiate = _instantiate;
}

mixin AuthUserMappable {
  AuthUserCopyWith<AuthUser, AuthUser, AuthUser> get copyWith =>
      _AuthUserCopyWithImpl<AuthUser, AuthUser>(
        this as AuthUser,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthUserMapper.ensureInitialized().stringifyValue(this as AuthUser);
  }

  @override
  bool operator ==(Object other) {
    return AuthUserMapper.ensureInitialized().equalsValue(
      this as AuthUser,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthUserMapper.ensureInitialized().hashValue(this as AuthUser);
  }
}

extension AuthUserValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthUser, $Out> {
  AuthUserCopyWith<$R, AuthUser, $Out> get $asAuthUser =>
      $base.as((v, t, t2) => _AuthUserCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthUserCopyWith<$R, $In extends AuthUser, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? email});
  AuthUserCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthUserCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthUser, $Out>
    implements AuthUserCopyWith<$R, AuthUser, $Out> {
  _AuthUserCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthUser> $mapper =
      AuthUserMapper.ensureInitialized();
  @override
  $R call({String? id, String? email}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (email != null) #email: email,
    }),
  );
  @override
  AuthUser $make(CopyWithData data) => AuthUser(
    id: data.get(#id, or: $value.id),
    email: data.get(#email, or: $value.email),
  );

  @override
  AuthUserCopyWith<$R2, AuthUser, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthUserCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

