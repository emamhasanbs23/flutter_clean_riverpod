// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'todo_page.dart';

class TodoPageMapper extends ClassMapperBase<TodoPage> {
  TodoPageMapper._();

  static TodoPageMapper? _instance;
  static TodoPageMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TodoPageMapper._());
      TodoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TodoPage';

  static List<Todo> _$todos(TodoPage v) => v.todos;
  static const Field<TodoPage, List<Todo>> _f$todos = Field('todos', _$todos);
  static int _$total(TodoPage v) => v.total;
  static const Field<TodoPage, int> _f$total = Field('total', _$total);
  static int _$skip(TodoPage v) => v.skip;
  static const Field<TodoPage, int> _f$skip = Field('skip', _$skip);
  static int _$limit(TodoPage v) => v.limit;
  static const Field<TodoPage, int> _f$limit = Field('limit', _$limit);

  @override
  final MappableFields<TodoPage> fields = const {
    #todos: _f$todos,
    #total: _f$total,
    #skip: _f$skip,
    #limit: _f$limit,
  };

  static TodoPage _instantiate(DecodingData data) {
    return TodoPage(
      todos: data.dec(_f$todos),
      total: data.dec(_f$total),
      skip: data.dec(_f$skip),
      limit: data.dec(_f$limit),
    );
  }

  @override
  final Function instantiate = _instantiate;
}

mixin TodoPageMappable {
  TodoPageCopyWith<TodoPage, TodoPage, TodoPage> get copyWith =>
      _TodoPageCopyWithImpl<TodoPage, TodoPage>(
        this as TodoPage,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TodoPageMapper.ensureInitialized().stringifyValue(this as TodoPage);
  }

  @override
  bool operator ==(Object other) {
    return TodoPageMapper.ensureInitialized().equalsValue(
      this as TodoPage,
      other,
    );
  }

  @override
  int get hashCode {
    return TodoPageMapper.ensureInitialized().hashValue(this as TodoPage);
  }
}

extension TodoPageValueCopy<$R, $Out> on ObjectCopyWith<$R, TodoPage, $Out> {
  TodoPageCopyWith<$R, TodoPage, $Out> get $asTodoPage =>
      $base.as((v, t, t2) => _TodoPageCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TodoPageCopyWith<$R, $In extends TodoPage, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Todo, TodoCopyWith<$R, Todo, Todo>> get todos;
  $R call({List<Todo>? todos, int? total, int? skip, int? limit});
  TodoPageCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TodoPageCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TodoPage, $Out>
    implements TodoPageCopyWith<$R, TodoPage, $Out> {
  _TodoPageCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TodoPage> $mapper =
      TodoPageMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Todo, TodoCopyWith<$R, Todo, Todo>> get todos =>
      ListCopyWith(
        $value.todos,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(todos: v),
      );
  @override
  $R call({List<Todo>? todos, int? total, int? skip, int? limit}) => $apply(
    FieldCopyWithData({
      if (todos != null) #todos: todos,
      if (total != null) #total: total,
      if (skip != null) #skip: skip,
      if (limit != null) #limit: limit,
    }),
  );
  @override
  TodoPage $make(CopyWithData data) => TodoPage(
    todos: data.get(#todos, or: $value.todos),
    total: data.get(#total, or: $value.total),
    skip: data.get(#skip, or: $value.skip),
    limit: data.get(#limit, or: $value.limit),
  );

  @override
  TodoPageCopyWith<$R2, TodoPage, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TodoPageCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

