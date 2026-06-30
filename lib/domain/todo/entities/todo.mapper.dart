// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'todo.dart';

class TodoMapper extends ClassMapperBase<Todo> {
  TodoMapper._();

  static TodoMapper? _instance;
  static TodoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TodoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Todo';

  static String _$id(Todo v) => v.id;
  static const Field<Todo, String> _f$id = Field('id', _$id);
  static String _$title(Todo v) => v.title;
  static const Field<Todo, String> _f$title = Field('title', _$title);
  static bool _$completed(Todo v) => v.completed;
  static const Field<Todo, bool> _f$completed = Field('completed', _$completed);

  @override
  final MappableFields<Todo> fields = const {
    #id: _f$id,
    #title: _f$title,
    #completed: _f$completed,
  };

  static Todo _instantiate(DecodingData data) {
    return Todo(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      completed: data.dec(_f$completed),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin TodoMappable {
  TodoCopyWith<Todo, Todo, Todo> get copyWith =>
      _TodoCopyWithImpl<Todo, Todo>(this as Todo, $identity, $identity);
  @override
  String toString() {
    return TodoMapper.ensureInitialized().stringifyValue(this as Todo);
  }

  @override
  bool operator ==(Object other) {
    return TodoMapper.ensureInitialized().equalsValue(this as Todo, other);
  }

  @override
  int get hashCode {
    return TodoMapper.ensureInitialized().hashValue(this as Todo);
  }
}

extension TodoValueCopy<$R, $Out> on ObjectCopyWith<$R, Todo, $Out> {
  TodoCopyWith<$R, Todo, $Out> get $asTodo =>
      $base.as((v, t, t2) => _TodoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TodoCopyWith<$R, $In extends Todo, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? title, bool? completed});
  TodoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TodoCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Todo, $Out>
    implements TodoCopyWith<$R, Todo, $Out> {
  _TodoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Todo> $mapper = TodoMapper.ensureInitialized();
  @override
  $R call({String? id, String? title, bool? completed}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (completed != null) #completed: completed,
    }),
  );
  @override
  Todo $make(CopyWithData data) => Todo(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    completed: data.get(#completed, or: $value.completed),
  );

  @override
  TodoCopyWith<$R2, Todo, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TodoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

