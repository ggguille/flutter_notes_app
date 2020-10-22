import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/core/failures.dart';
import 'package:flutter_notes_app/domain/core/value_objects.dart';
import 'package:flutter_notes_app/domain/core/value_transformers.dart';
import 'package:flutter_notes_app/domain/core/value_validators.dart';

class NoteBody extends ValueObject<String> {
  static const maxLength = 1000;

  @override
  final Either<ValueFailure<String>, String> value;

  factory NoteBody(String input) {
    assert(input != null);
    return NoteBody._(
      validateMaxStringLength(input, maxLength).flatMap(validateStringNotEmpty),
    );
  }

  const NoteBody._(this.value);
}

class TodoName extends ValueObject<String> {
  static const maxLength = 30;

  @override
  final Either<ValueFailure<String>, String> value;

  factory TodoName(String input) {
    assert(input != null);
    return TodoName._(validateMaxStringLength(input, maxLength)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine));
  }

  const TodoName._(this.value);
}

class NoteColor extends ValueObject<Color> {
  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // salmon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  @override
  final Either<ValueFailure<Color>, Color> value;

  factory NoteColor(Color input) {
    assert(input != null);
    return NoteColor._(right(makeColorOpaque(input)));
  }

  const NoteColor._(this.value);
}

class List3<T> extends ValueObject<IList<T>> {
  static const maxLength = 3;

  @override
  final Either<ValueFailure<IList<T>>, IList<T>> value;

  factory List3(IList<T> input) {
    assert(input != null);
    return List3._(validateMaxListLength(input, maxLength));
  }

  const List3._(this.value);

  int get length {
    return value.getOrElse(() => IList.from([])).length();
  }

  bool get isFull {
    return length == maxLength;
  }
}
