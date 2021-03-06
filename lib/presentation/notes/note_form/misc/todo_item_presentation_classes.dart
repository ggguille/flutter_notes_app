import 'package:dartz/dartz.dart' hide id;
import 'package:flutter/material.dart';
import 'package:flutter_notes_app/domain/core/value_objects.dart';
import 'package:flutter_notes_app/domain/notes/todo_item.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_item_presentation_classes.freezed.dart';

class FormTodos extends ValueNotifier<IList<TodoItemPrimitive>> {
  FormTodos() : super(IList.from([]));
}

@freezed
abstract class TodoItemPrimitive with _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    @required UniqueId id,
    @required String name,
    @required bool done,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() =>
      TodoItemPrimitive(id: UniqueId(), name: '', done: false);

  factory TodoItemPrimitive.fromDomain(TodoItem todoItem) {
    return TodoItemPrimitive(
      id: todoItem.id,
      name: todoItem.name.getOrCrash(),
      done: todoItem.done,
    );
  }

  TodoItem toDomain() {
    return TodoItem(
      id: id,
      name: TodoName(name),
      done: done,
    );
  }
}
