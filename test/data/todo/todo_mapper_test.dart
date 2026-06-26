import 'package:flutter_clean_riverpod_boilerplate/data/todo/mapper/todo_mapper.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todo_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/data/todo/model/todos_response_dto.dart';
import 'package:flutter_clean_riverpod_boilerplate/domain/todo/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodoDtoMapper', () {
    test('maps todo field to title and int id to String', () {
      const dto = TodoDto(id: 42, todo: 'Buy milk', completed: true, userId: 5);

      expect(
        dto.toDomain(),
        const Todo(id: '42', title: 'Buy milk', completed: true),
      );
    });

    test('handles null userId', () {
      const dto = TodoDto(id: 1, todo: 'Task');

      expect(dto.toDomain().title, 'Task');
    });
  });

  group('TodoDomainMapper', () {
    test('maps title to todo and parses id', () {
      const entity = Todo(id: '7', title: 'Ship it', completed: false);

      expect(entity.toDto(), const TodoDto(id: 7, todo: 'Ship it'));
    });

    test('falls back to 0 when id is not numeric', () {
      const entity = Todo(id: 'abc', title: 'Task', completed: false);

      expect(entity.toDto().id, 0);
    });
  });

  group('TodosResponseDto', () {
    test('parses the DummyJSON list envelope', () {
      final dto = TodosResponseDto.fromJson({
        'todos': [
          {
            'id': 1,
            'todo': 'Do something nice',
            'completed': true,
            'userId': 26,
          },
        ],
        'total': 150,
        'skip': 0,
        'limit': 30,
      });

      expect(dto.todos, hasLength(1));
      expect(dto.todos.first.todo, 'Do something nice');
      expect(dto.total, 150);
    });

    test('defaults to empty list when todos is missing', () {
      final dto = TodosResponseDto.fromJson({'total': 0});

      expect(dto.todos, isEmpty);
      expect(dto.total, 0);
    });
  });
}
