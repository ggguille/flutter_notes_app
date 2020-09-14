import 'package:dartz/dartz.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';

abstract class INoteRepository {
  Stream<Either<NoteFailure, IList<Note>>> watchAll();
  Stream<Either<NoteFailure, IList<Note>>> watchUncompleted();
  Future<Either<NoteFailure, Unit>> create(Note note);
  Future<Either<NoteFailure, Unit>> update(Note note);
  Future<Either<NoteFailure, Unit>> delete(Note note);
}