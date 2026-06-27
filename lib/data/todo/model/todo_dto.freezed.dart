// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoDto {

 int get id;@JsonKey(name: 'todo') String get todo; bool get completed;@JsonKey(name: 'userId') int? get userId;
/// Create a copy of TodoDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoDtoCopyWith<TodoDto> get copyWith => _$TodoDtoCopyWithImpl<TodoDto>(this as TodoDto, _$identity);

  /// Serializes this TodoDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,todo,completed,userId);

@override
String toString() {
  return 'TodoDto(id: $id, todo: $todo, completed: $completed, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $TodoDtoCopyWith<$Res>  {
  factory $TodoDtoCopyWith(TodoDto value, $Res Function(TodoDto) _then) = _$TodoDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'todo') String todo, bool completed,@JsonKey(name: 'userId') int? userId
});




}
/// @nodoc
class _$TodoDtoCopyWithImpl<$Res>
    implements $TodoDtoCopyWith<$Res> {
  _$TodoDtoCopyWithImpl(this._self, this._then);

  final TodoDto _self;
  final $Res Function(TodoDto) _then;

/// Create a copy of TodoDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? todo = null,Object? completed = null,Object? userId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,todo: null == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoDto].
extension TodoDtoPatterns on TodoDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoDto value)  $default,){
final _that = this;
switch (_that) {
case _TodoDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoDto value)?  $default,){
final _that = this;
switch (_that) {
case _TodoDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'todo')  String todo,  bool completed, @JsonKey(name: 'userId')  int? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoDto() when $default != null:
return $default(_that.id,_that.todo,_that.completed,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'todo')  String todo,  bool completed, @JsonKey(name: 'userId')  int? userId)  $default,) {final _that = this;
switch (_that) {
case _TodoDto():
return $default(_that.id,_that.todo,_that.completed,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'todo')  String todo,  bool completed, @JsonKey(name: 'userId')  int? userId)?  $default,) {final _that = this;
switch (_that) {
case _TodoDto() when $default != null:
return $default(_that.id,_that.todo,_that.completed,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodoDto implements TodoDto {
  const _TodoDto({required this.id, @JsonKey(name: 'todo') required this.todo, this.completed = false, @JsonKey(name: 'userId') this.userId});
  factory _TodoDto.fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'todo') final  String todo;
@override@JsonKey() final  bool completed;
@override@JsonKey(name: 'userId') final  int? userId;

/// Create a copy of TodoDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoDtoCopyWith<_TodoDto> get copyWith => __$TodoDtoCopyWithImpl<_TodoDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodoDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoDto&&(identical(other.id, id) || other.id == id)&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,todo,completed,userId);

@override
String toString() {
  return 'TodoDto(id: $id, todo: $todo, completed: $completed, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TodoDtoCopyWith<$Res> implements $TodoDtoCopyWith<$Res> {
  factory _$TodoDtoCopyWith(_TodoDto value, $Res Function(_TodoDto) _then) = __$TodoDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'todo') String todo, bool completed,@JsonKey(name: 'userId') int? userId
});




}
/// @nodoc
class __$TodoDtoCopyWithImpl<$Res>
    implements _$TodoDtoCopyWith<$Res> {
  __$TodoDtoCopyWithImpl(this._self, this._then);

  final _TodoDto _self;
  final $Res Function(_TodoDto) _then;

/// Create a copy of TodoDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? todo = null,Object? completed = null,Object? userId = freezed,}) {
  return _then(_TodoDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,todo: null == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$CreateTodoRequestDto {

 String get todo;@JsonKey(name: 'userId') int get userId; bool get completed;
/// Create a copy of CreateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTodoRequestDtoCopyWith<CreateTodoRequestDto> get copyWith => _$CreateTodoRequestDtoCopyWithImpl<CreateTodoRequestDto>(this as CreateTodoRequestDto, _$identity);

  /// Serializes this CreateTodoRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTodoRequestDto&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todo,userId,completed);

@override
String toString() {
  return 'CreateTodoRequestDto(todo: $todo, userId: $userId, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $CreateTodoRequestDtoCopyWith<$Res>  {
  factory $CreateTodoRequestDtoCopyWith(CreateTodoRequestDto value, $Res Function(CreateTodoRequestDto) _then) = _$CreateTodoRequestDtoCopyWithImpl;
@useResult
$Res call({
 String todo,@JsonKey(name: 'userId') int userId, bool completed
});




}
/// @nodoc
class _$CreateTodoRequestDtoCopyWithImpl<$Res>
    implements $CreateTodoRequestDtoCopyWith<$Res> {
  _$CreateTodoRequestDtoCopyWithImpl(this._self, this._then);

  final CreateTodoRequestDto _self;
  final $Res Function(CreateTodoRequestDto) _then;

/// Create a copy of CreateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todo = null,Object? userId = null,Object? completed = null,}) {
  return _then(_self.copyWith(
todo: null == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTodoRequestDto].
extension CreateTodoRequestDtoPatterns on CreateTodoRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTodoRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTodoRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTodoRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateTodoRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTodoRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTodoRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String todo, @JsonKey(name: 'userId')  int userId,  bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTodoRequestDto() when $default != null:
return $default(_that.todo,_that.userId,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String todo, @JsonKey(name: 'userId')  int userId,  bool completed)  $default,) {final _that = this;
switch (_that) {
case _CreateTodoRequestDto():
return $default(_that.todo,_that.userId,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String todo, @JsonKey(name: 'userId')  int userId,  bool completed)?  $default,) {final _that = this;
switch (_that) {
case _CreateTodoRequestDto() when $default != null:
return $default(_that.todo,_that.userId,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTodoRequestDto implements CreateTodoRequestDto {
  const _CreateTodoRequestDto({required this.todo, @JsonKey(name: 'userId') required this.userId, this.completed = false});
  factory _CreateTodoRequestDto.fromJson(Map<String, dynamic> json) => _$CreateTodoRequestDtoFromJson(json);

@override final  String todo;
@override@JsonKey(name: 'userId') final  int userId;
@override@JsonKey() final  bool completed;

/// Create a copy of CreateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTodoRequestDtoCopyWith<_CreateTodoRequestDto> get copyWith => __$CreateTodoRequestDtoCopyWithImpl<_CreateTodoRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTodoRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTodoRequestDto&&(identical(other.todo, todo) || other.todo == todo)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todo,userId,completed);

@override
String toString() {
  return 'CreateTodoRequestDto(todo: $todo, userId: $userId, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$CreateTodoRequestDtoCopyWith<$Res> implements $CreateTodoRequestDtoCopyWith<$Res> {
  factory _$CreateTodoRequestDtoCopyWith(_CreateTodoRequestDto value, $Res Function(_CreateTodoRequestDto) _then) = __$CreateTodoRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String todo,@JsonKey(name: 'userId') int userId, bool completed
});




}
/// @nodoc
class __$CreateTodoRequestDtoCopyWithImpl<$Res>
    implements _$CreateTodoRequestDtoCopyWith<$Res> {
  __$CreateTodoRequestDtoCopyWithImpl(this._self, this._then);

  final _CreateTodoRequestDto _self;
  final $Res Function(_CreateTodoRequestDto) _then;

/// Create a copy of CreateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todo = null,Object? userId = null,Object? completed = null,}) {
  return _then(_CreateTodoRequestDto(
todo: null == todo ? _self.todo : todo // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UpdateTodoRequestDto {

 bool get completed;
/// Create a copy of UpdateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTodoRequestDtoCopyWith<UpdateTodoRequestDto> get copyWith => _$UpdateTodoRequestDtoCopyWithImpl<UpdateTodoRequestDto>(this as UpdateTodoRequestDto, _$identity);

  /// Serializes this UpdateTodoRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTodoRequestDto&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completed);

@override
String toString() {
  return 'UpdateTodoRequestDto(completed: $completed)';
}


}

/// @nodoc
abstract mixin class $UpdateTodoRequestDtoCopyWith<$Res>  {
  factory $UpdateTodoRequestDtoCopyWith(UpdateTodoRequestDto value, $Res Function(UpdateTodoRequestDto) _then) = _$UpdateTodoRequestDtoCopyWithImpl;
@useResult
$Res call({
 bool completed
});




}
/// @nodoc
class _$UpdateTodoRequestDtoCopyWithImpl<$Res>
    implements $UpdateTodoRequestDtoCopyWith<$Res> {
  _$UpdateTodoRequestDtoCopyWithImpl(this._self, this._then);

  final UpdateTodoRequestDto _self;
  final $Res Function(UpdateTodoRequestDto) _then;

/// Create a copy of UpdateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? completed = null,}) {
  return _then(_self.copyWith(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTodoRequestDto].
extension UpdateTodoRequestDtoPatterns on UpdateTodoRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTodoRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTodoRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTodoRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTodoRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTodoRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTodoRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTodoRequestDto() when $default != null:
return $default(_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool completed)  $default,) {final _that = this;
switch (_that) {
case _UpdateTodoRequestDto():
return $default(_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool completed)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTodoRequestDto() when $default != null:
return $default(_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTodoRequestDto implements UpdateTodoRequestDto {
  const _UpdateTodoRequestDto({required this.completed});
  factory _UpdateTodoRequestDto.fromJson(Map<String, dynamic> json) => _$UpdateTodoRequestDtoFromJson(json);

@override final  bool completed;

/// Create a copy of UpdateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTodoRequestDtoCopyWith<_UpdateTodoRequestDto> get copyWith => __$UpdateTodoRequestDtoCopyWithImpl<_UpdateTodoRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTodoRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTodoRequestDto&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completed);

@override
String toString() {
  return 'UpdateTodoRequestDto(completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$UpdateTodoRequestDtoCopyWith<$Res> implements $UpdateTodoRequestDtoCopyWith<$Res> {
  factory _$UpdateTodoRequestDtoCopyWith(_UpdateTodoRequestDto value, $Res Function(_UpdateTodoRequestDto) _then) = __$UpdateTodoRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 bool completed
});




}
/// @nodoc
class __$UpdateTodoRequestDtoCopyWithImpl<$Res>
    implements _$UpdateTodoRequestDtoCopyWith<$Res> {
  __$UpdateTodoRequestDtoCopyWithImpl(this._self, this._then);

  final _UpdateTodoRequestDto _self;
  final $Res Function(_UpdateTodoRequestDto) _then;

/// Create a copy of UpdateTodoRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? completed = null,}) {
  return _then(_UpdateTodoRequestDto(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
