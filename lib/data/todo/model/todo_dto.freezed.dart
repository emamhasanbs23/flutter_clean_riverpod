// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) {
  return _TodoDto.fromJson(json);
}

/// @nodoc
mixin _$TodoDto {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'todo')
  String get todo => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  int? get userId => throw _privateConstructorUsedError;

  /// Serializes this TodoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoDtoCopyWith<TodoDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoDtoCopyWith<$Res> {
  factory $TodoDtoCopyWith(TodoDto value, $Res Function(TodoDto) then) =
      _$TodoDtoCopyWithImpl<$Res, TodoDto>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'todo') String todo,
    bool completed,
    @JsonKey(name: 'userId') int? userId,
  });
}

/// @nodoc
class _$TodoDtoCopyWithImpl<$Res, $Val extends TodoDto>
    implements $TodoDtoCopyWith<$Res> {
  _$TodoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? todo = null,
    Object? completed = null,
    Object? userId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            todo: null == todo
                ? _value.todo
                : todo // ignore: cast_nullable_to_non_nullable
                      as String,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TodoDtoImplCopyWith<$Res> implements $TodoDtoCopyWith<$Res> {
  factory _$$TodoDtoImplCopyWith(
    _$TodoDtoImpl value,
    $Res Function(_$TodoDtoImpl) then,
  ) = __$$TodoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'todo') String todo,
    bool completed,
    @JsonKey(name: 'userId') int? userId,
  });
}

/// @nodoc
class __$$TodoDtoImplCopyWithImpl<$Res>
    extends _$TodoDtoCopyWithImpl<$Res, _$TodoDtoImpl>
    implements _$$TodoDtoImplCopyWith<$Res> {
  __$$TodoDtoImplCopyWithImpl(
    _$TodoDtoImpl _value,
    $Res Function(_$TodoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? todo = null,
    Object? completed = null,
    Object? userId = freezed,
  }) {
    return _then(
      _$TodoDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        todo: null == todo
            ? _value.todo
            : todo // ignore: cast_nullable_to_non_nullable
                  as String,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoDtoImpl implements _TodoDto {
  const _$TodoDtoImpl({
    required this.id,
    @JsonKey(name: 'todo') required this.todo,
    this.completed = false,
    @JsonKey(name: 'userId') this.userId,
  });

  factory _$TodoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'todo')
  final String todo;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey(name: 'userId')
  final int? userId;

  @override
  String toString() {
    return 'TodoDto(id: $id, todo: $todo, completed: $completed, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.todo, todo) || other.todo == todo) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, todo, completed, userId);

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoDtoImplCopyWith<_$TodoDtoImpl> get copyWith =>
      __$$TodoDtoImplCopyWithImpl<_$TodoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoDtoImplToJson(this);
  }
}

abstract class _TodoDto implements TodoDto {
  const factory _TodoDto({
    required final int id,
    @JsonKey(name: 'todo') required final String todo,
    final bool completed,
    @JsonKey(name: 'userId') final int? userId,
  }) = _$TodoDtoImpl;

  factory _TodoDto.fromJson(Map<String, dynamic> json) = _$TodoDtoImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'todo')
  String get todo;
  @override
  bool get completed;
  @override
  @JsonKey(name: 'userId')
  int? get userId;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoDtoImplCopyWith<_$TodoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateTodoRequestDto _$CreateTodoRequestDtoFromJson(Map<String, dynamic> json) {
  return _CreateTodoRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateTodoRequestDto {
  String get todo => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  int get userId => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this CreateTodoRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTodoRequestDtoCopyWith<CreateTodoRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTodoRequestDtoCopyWith<$Res> {
  factory $CreateTodoRequestDtoCopyWith(
    CreateTodoRequestDto value,
    $Res Function(CreateTodoRequestDto) then,
  ) = _$CreateTodoRequestDtoCopyWithImpl<$Res, CreateTodoRequestDto>;
  @useResult
  $Res call({String todo, @JsonKey(name: 'userId') int userId, bool completed});
}

/// @nodoc
class _$CreateTodoRequestDtoCopyWithImpl<
  $Res,
  $Val extends CreateTodoRequestDto
>
    implements $CreateTodoRequestDtoCopyWith<$Res> {
  _$CreateTodoRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todo = null,
    Object? userId = null,
    Object? completed = null,
  }) {
    return _then(
      _value.copyWith(
            todo: null == todo
                ? _value.todo
                : todo // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateTodoRequestDtoImplCopyWith<$Res>
    implements $CreateTodoRequestDtoCopyWith<$Res> {
  factory _$$CreateTodoRequestDtoImplCopyWith(
    _$CreateTodoRequestDtoImpl value,
    $Res Function(_$CreateTodoRequestDtoImpl) then,
  ) = __$$CreateTodoRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String todo, @JsonKey(name: 'userId') int userId, bool completed});
}

/// @nodoc
class __$$CreateTodoRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateTodoRequestDtoCopyWithImpl<$Res, _$CreateTodoRequestDtoImpl>
    implements _$$CreateTodoRequestDtoImplCopyWith<$Res> {
  __$$CreateTodoRequestDtoImplCopyWithImpl(
    _$CreateTodoRequestDtoImpl _value,
    $Res Function(_$CreateTodoRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todo = null,
    Object? userId = null,
    Object? completed = null,
  }) {
    return _then(
      _$CreateTodoRequestDtoImpl(
        todo: null == todo
            ? _value.todo
            : todo // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTodoRequestDtoImpl implements _CreateTodoRequestDto {
  const _$CreateTodoRequestDtoImpl({
    required this.todo,
    @JsonKey(name: 'userId') required this.userId,
    this.completed = false,
  });

  factory _$CreateTodoRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTodoRequestDtoImplFromJson(json);

  @override
  final String todo;
  @override
  @JsonKey(name: 'userId')
  final int userId;
  @override
  @JsonKey()
  final bool completed;

  @override
  String toString() {
    return 'CreateTodoRequestDto(todo: $todo, userId: $userId, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTodoRequestDtoImpl &&
            (identical(other.todo, todo) || other.todo == todo) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, todo, userId, completed);

  /// Create a copy of CreateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTodoRequestDtoImplCopyWith<_$CreateTodoRequestDtoImpl>
  get copyWith =>
      __$$CreateTodoRequestDtoImplCopyWithImpl<_$CreateTodoRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTodoRequestDtoImplToJson(this);
  }
}

abstract class _CreateTodoRequestDto implements CreateTodoRequestDto {
  const factory _CreateTodoRequestDto({
    required final String todo,
    @JsonKey(name: 'userId') required final int userId,
    final bool completed,
  }) = _$CreateTodoRequestDtoImpl;

  factory _CreateTodoRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateTodoRequestDtoImpl.fromJson;

  @override
  String get todo;
  @override
  @JsonKey(name: 'userId')
  int get userId;
  @override
  bool get completed;

  /// Create a copy of CreateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTodoRequestDtoImplCopyWith<_$CreateTodoRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

UpdateTodoRequestDto _$UpdateTodoRequestDtoFromJson(Map<String, dynamic> json) {
  return _UpdateTodoRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateTodoRequestDto {
  bool get completed => throw _privateConstructorUsedError;

  /// Serializes this UpdateTodoRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTodoRequestDtoCopyWith<UpdateTodoRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTodoRequestDtoCopyWith<$Res> {
  factory $UpdateTodoRequestDtoCopyWith(
    UpdateTodoRequestDto value,
    $Res Function(UpdateTodoRequestDto) then,
  ) = _$UpdateTodoRequestDtoCopyWithImpl<$Res, UpdateTodoRequestDto>;
  @useResult
  $Res call({bool completed});
}

/// @nodoc
class _$UpdateTodoRequestDtoCopyWithImpl<
  $Res,
  $Val extends UpdateTodoRequestDto
>
    implements $UpdateTodoRequestDtoCopyWith<$Res> {
  _$UpdateTodoRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? completed = null}) {
    return _then(
      _value.copyWith(
            completed: null == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateTodoRequestDtoImplCopyWith<$Res>
    implements $UpdateTodoRequestDtoCopyWith<$Res> {
  factory _$$UpdateTodoRequestDtoImplCopyWith(
    _$UpdateTodoRequestDtoImpl value,
    $Res Function(_$UpdateTodoRequestDtoImpl) then,
  ) = __$$UpdateTodoRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool completed});
}

/// @nodoc
class __$$UpdateTodoRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateTodoRequestDtoCopyWithImpl<$Res, _$UpdateTodoRequestDtoImpl>
    implements _$$UpdateTodoRequestDtoImplCopyWith<$Res> {
  __$$UpdateTodoRequestDtoImplCopyWithImpl(
    _$UpdateTodoRequestDtoImpl _value,
    $Res Function(_$UpdateTodoRequestDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? completed = null}) {
    return _then(
      _$UpdateTodoRequestDtoImpl(
        completed: null == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTodoRequestDtoImpl implements _UpdateTodoRequestDto {
  const _$UpdateTodoRequestDtoImpl({required this.completed});

  factory _$UpdateTodoRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateTodoRequestDtoImplFromJson(json);

  @override
  final bool completed;

  @override
  String toString() {
    return 'UpdateTodoRequestDto(completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTodoRequestDtoImpl &&
            (identical(other.completed, completed) ||
                other.completed == completed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, completed);

  /// Create a copy of UpdateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTodoRequestDtoImplCopyWith<_$UpdateTodoRequestDtoImpl>
  get copyWith =>
      __$$UpdateTodoRequestDtoImplCopyWithImpl<_$UpdateTodoRequestDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTodoRequestDtoImplToJson(this);
  }
}

abstract class _UpdateTodoRequestDto implements UpdateTodoRequestDto {
  const factory _UpdateTodoRequestDto({required final bool completed}) =
      _$UpdateTodoRequestDtoImpl;

  factory _UpdateTodoRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateTodoRequestDtoImpl.fromJson;

  @override
  bool get completed;

  /// Create a copy of UpdateTodoRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTodoRequestDtoImplCopyWith<_$UpdateTodoRequestDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
