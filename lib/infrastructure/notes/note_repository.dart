import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_notes_app/domain/notes/i_note_repository.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/infrastructure/notes/note_dtos.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_notes_app/infrastructure/core/firestore_helpers.dart';

const String _permissionDeniedMessage = 'PERMISSION_DENIED';
const String _notFoundMessage = 'NOT_FOUND';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, IList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, IList<Note>>(
            IList.from(
              snapshot.docs.map(
                (doc) => NoteDto.fromFirestore(doc).toDomain(),
              ),
            ),
          ),
        )
        .onErrorReturnWith(
      (ex) {
        if (ex is FirebaseException &&
            ex.message.contains(_permissionDeniedMessage)) {
          return left(const NoteFailure.insufficientPermissions());
        }
        return left(const NoteFailure.unexpected());
      },
    );
  }

  @override
  Stream<Either<NoteFailure, IList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(
            (doc) => NoteDto.fromFirestore(doc).toDomain(),
          ),
        )
        .map(
          (notes) => right<NoteFailure, IList<Note>>(
            IList.from(
              notes.where(
                (note) =>
                    note.todos.getOrCrash().any((todoItem) => !todoItem.done),
              ),
            ),
          ),
        )
        .onErrorReturnWith(
      (ex) {
        if (ex is FirebaseException &&
            ex.message.contains(_permissionDeniedMessage)) {
          return left(const NoteFailure.insufficientPermissions());
        }
        return left(const NoteFailure.unexpected());
      },
    );
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).set(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains(_permissionDeniedMessage)) {
        return left(const NoteFailure.insufficientPermissions());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);
      await userDoc.noteCollection.doc(noteDto.id).update(noteDto.toJson());
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains(_permissionDeniedMessage)) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message.contains(_notFoundMessage)) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();
      await userDoc.noteCollection.doc(noteId).delete();
      return right(unit);
    } on FirebaseException catch (e) {
      if (e.message.contains(_permissionDeniedMessage)) {
        return left(const NoteFailure.insufficientPermissions());
      } else if (e.message.contains(_notFoundMessage)) {
        return left(const NoteFailure.unableToUpdate());
      } else {
        return left(const NoteFailure.unexpected());
      }
    }
  }
}
