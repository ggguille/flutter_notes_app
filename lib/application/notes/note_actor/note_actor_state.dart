import 'package:flutter_notes_app/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_actor_state.freezed.dart';

@freezed
abstract class NoteActorState with _$NoteActorState {
  const factory NoteActorState.initial() = _Initial;
  const factory NoteActorState.actionInProgress() = _ActionInProgress;
  const factory NoteActorState.deleteFailure(NoteFailure failure) = _DeleteFailure;
  const factory NoteActorState.deleteSuccess() = _DeleteSuccess;
}