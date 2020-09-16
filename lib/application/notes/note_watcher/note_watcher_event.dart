import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_watcher_event.freezed.dart';

@freezed
abstract class NoteWatcherEvent with _$NoteWatcherEvent {
  const factory NoteWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory NoteWatcherEvent.watchUncompletedStarted() =
      _WatchUncompletedStarted;
  const factory NoteWatcherEvent.notesReceived(
    Either<NoteFailure, IList<Note>> failureOrNotes,
  ) = _NotesReceived;
}
