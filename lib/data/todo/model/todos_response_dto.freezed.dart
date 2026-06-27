// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todos_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodosResponseDto {

 List<TodoDto> get todos; int get total; int get skip; int get limit;
/// Create a copy of TodosResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodosResponseDtoCopyWith<TodosResponseDto> get copyWith => _$TodosResponseDtoCopyWithImpl<TodosResponseDto>(this as TodosResponseDto, _$identity);

  /// Serializes this TodosResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodosResponseDto&&const DeepCollectionEquality().equals(other.todos, todos)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(todos),total,skip,limit);

@override
String toString() {
  return 'TodosResponseDto(todos: $todos, total: $total, skip: $skip, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $TodosResponseDtoCopyWith<$Res>  {
  factory $TodosResponseDtoCopyWith(TodosResponseDto value, $Res Function(TodosResponseDto) _then) = _$TodosResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<TodoDto> todos, int total, int skip, int limit
});




}
/// @nodoc
class _$TodosResponseDtoCopyWithImpl<$Res>
    implements $TodosResponseDtoCopyWith<$Res> {
  _$TodosResponseDtoCopyWithImpl(this._self, this._then);

  final TodosResponseDto _self;
  final $Res Function(TodosResponseDto) _then;

/// Create a copy of TodosResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todos = null,Object? total = null,Object? skip = null,Object? limit = null,}) {
  return _then(_self.copyWith(
todos: null == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as List<TodoDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TodosResponseDto].
extension TodosResponseDtoPatterns on TodosResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodosResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodosResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodosResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _TodosResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodosResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _TodosResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TodoDto> todos,  int total,  int skip,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodosResponseDto() when $default != null:
return $default(_that.todos,_that.total,_that.skip,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TodoDto> todos,  int total,  int skip,  int limit)  $default,) {final _that = this;
switch (_that) {
case _TodosResponseDto():
return $default(_that.todos,_that.total,_that.skip,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TodoDto> todos,  int total,  int skip,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _TodosResponseDto() when $default != null:
return $default(_that.todos,_that.total,_that.skip,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodosResponseDto implements TodosResponseDto {
  const _TodosResponseDto({final  List<TodoDto> todos = const <TodoDto>[], this.total = 0, this.skip = 0, this.limit = 0}): _todos = todos;
  factory _TodosResponseDto.fromJson(Map<String, dynamic> json) => _$TodosResponseDtoFromJson(json);

 final  List<TodoDto> _todos;
@override@JsonKey() List<TodoDto> get todos {
  if (_todos is EqualUnmodifiableListView) return _todos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todos);
}

@override@JsonKey() final  int total;
@override@JsonKey() final  int skip;
@override@JsonKey() final  int limit;

/// Create a copy of TodosResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodosResponseDtoCopyWith<_TodosResponseDto> get copyWith => __$TodosResponseDtoCopyWithImpl<_TodosResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodosResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodosResponseDto&&const DeepCollectionEquality().equals(other._todos, _todos)&&(identical(other.total, total) || other.total == total)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todos),total,skip,limit);

@override
String toString() {
  return 'TodosResponseDto(todos: $todos, total: $total, skip: $skip, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$TodosResponseDtoCopyWith<$Res> implements $TodosResponseDtoCopyWith<$Res> {
  factory _$TodosResponseDtoCopyWith(_TodosResponseDto value, $Res Function(_TodosResponseDto) _then) = __$TodosResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<TodoDto> todos, int total, int skip, int limit
});




}
/// @nodoc
class __$TodosResponseDtoCopyWithImpl<$Res>
    implements _$TodosResponseDtoCopyWith<$Res> {
  __$TodosResponseDtoCopyWithImpl(this._self, this._then);

  final _TodosResponseDto _self;
  final $Res Function(_TodosResponseDto) _then;

/// Create a copy of TodosResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todos = null,Object? total = null,Object? skip = null,Object? limit = null,}) {
  return _then(_TodosResponseDto(
todos: null == todos ? _self._todos : todos // ignore: cast_nullable_to_non_nullable
as List<TodoDto>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
