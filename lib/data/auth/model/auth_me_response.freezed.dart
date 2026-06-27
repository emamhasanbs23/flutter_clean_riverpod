// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_me_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthMeResponse {

 int get id; String get email; String? get username; String? get firstName; String? get lastName; String? get image;
/// Create a copy of AuthMeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthMeResponseCopyWith<AuthMeResponse> get copyWith => _$AuthMeResponseCopyWithImpl<AuthMeResponse>(this as AuthMeResponse, _$identity);

  /// Serializes this AuthMeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthMeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,firstName,lastName,image);

@override
String toString() {
  return 'AuthMeResponse(id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName, image: $image)';
}


}

/// @nodoc
abstract mixin class $AuthMeResponseCopyWith<$Res>  {
  factory $AuthMeResponseCopyWith(AuthMeResponse value, $Res Function(AuthMeResponse) _then) = _$AuthMeResponseCopyWithImpl;
@useResult
$Res call({
 int id, String email, String? username, String? firstName, String? lastName, String? image
});




}
/// @nodoc
class _$AuthMeResponseCopyWithImpl<$Res>
    implements $AuthMeResponseCopyWith<$Res> {
  _$AuthMeResponseCopyWithImpl(this._self, this._then);

  final AuthMeResponse _self;
  final $Res Function(AuthMeResponse) _then;

/// Create a copy of AuthMeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthMeResponse].
extension AuthMeResponsePatterns on AuthMeResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthMeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthMeResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthMeResponse value)  $default,){
final _that = this;
switch (_that) {
case _AuthMeResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthMeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AuthMeResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email,  String? username,  String? firstName,  String? lastName,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthMeResponse() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.firstName,_that.lastName,_that.image);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email,  String? username,  String? firstName,  String? lastName,  String? image)  $default,) {final _that = this;
switch (_that) {
case _AuthMeResponse():
return $default(_that.id,_that.email,_that.username,_that.firstName,_that.lastName,_that.image);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email,  String? username,  String? firstName,  String? lastName,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _AuthMeResponse() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.firstName,_that.lastName,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthMeResponse implements AuthMeResponse {
  const _AuthMeResponse({required this.id, required this.email, this.username, this.firstName, this.lastName, this.image});
  factory _AuthMeResponse.fromJson(Map<String, dynamic> json) => _$AuthMeResponseFromJson(json);

@override final  int id;
@override final  String email;
@override final  String? username;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? image;

/// Create a copy of AuthMeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthMeResponseCopyWith<_AuthMeResponse> get copyWith => __$AuthMeResponseCopyWithImpl<_AuthMeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthMeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthMeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,firstName,lastName,image);

@override
String toString() {
  return 'AuthMeResponse(id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName, image: $image)';
}


}

/// @nodoc
abstract mixin class _$AuthMeResponseCopyWith<$Res> implements $AuthMeResponseCopyWith<$Res> {
  factory _$AuthMeResponseCopyWith(_AuthMeResponse value, $Res Function(_AuthMeResponse) _then) = __$AuthMeResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String? username, String? firstName, String? lastName, String? image
});




}
/// @nodoc
class __$AuthMeResponseCopyWithImpl<$Res>
    implements _$AuthMeResponseCopyWith<$Res> {
  __$AuthMeResponseCopyWithImpl(this._self, this._then);

  final _AuthMeResponse _self;
  final $Res Function(_AuthMeResponse) _then;

/// Create a copy of AuthMeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? image = freezed,}) {
  return _then(_AuthMeResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
