import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_form_state.freezed.dart';

@freezed
abstract class NoteFormState with _$NoteFormState {
  const factory NoteFormState({
    @required Note note,
    @required bool showErrorMessages,
    @required bool isSaving,
    @required bool isEditing,
    @required Option<Either<NoteFailure, Unit>> saveFailureOrSuccessOption,
  }) = _NoteFormState;

  factory NoteFormState.initial() => NoteFormState(
    note: Note.empty(),
    showErrorMessages: false,
    isSaving:  false,
    isEditing: false,
    saveFailureOrSuccessOption: none()
  );
}
