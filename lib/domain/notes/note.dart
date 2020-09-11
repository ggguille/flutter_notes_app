import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';
import 'package:flutter_notes_app/domain/core/value_objects.dart';
import 'package:flutter_notes_app/domain/notes/todo_item.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note(
      {@required UniqueId id,
      @required NoteBody body,
      @required NoteColor color,
      @required List3<TodoItem> todos}) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(""),
        color: NoteColor(NoteColor.predefinedColors[0]),
        todos: List3(IList.from([])),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(
          todos
              .getOrCrash()
              .map((todoItem) => todoItem.failureOption)
              .filter((failureOption) => failureOption.isSome())
              .headOption
              .getOrElse(() => none())
              .fold(
                () => right(unit),
                (failure) => left(failure),
              ),
        )
        .fold(
          (failure) => some(failure),
          (_) => none(),
        );
  }
}
