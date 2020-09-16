import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_actor_event.freezed.dart';

@freezed
abstract class NoteActorEvent with _$NoteActorEvent {
  const factory NoteActorEvent.deleted(Note note) = _Deleted;
}