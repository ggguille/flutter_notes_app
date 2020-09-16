import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_event.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_state.dart';
import 'package:flutter_notes_app/domain/notes/i_note_repository.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/domain/notes/note_failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;
  StreamSubscription<Either<NoteFailure, IList<Note>>> _notesStreamSubscription;

  NoteWatcherBloc(this._noteRepository)
      : super(const NoteWatcherState.initial());

  @override
  Stream<NoteWatcherState> mapEventToState(
    NoteWatcherEvent event,
  ) async* {
    yield* event.map(
      watchAllStarted: (e) async* {
        yield* _watcher(_noteRepository.watchAll);
      },
      watchUncompletedStarted: (e) async* {
        yield* _watcher(_noteRepository.watchUncompleted);
      },
      notesReceived: (e) async* {
        yield e.failureOrNotes.fold(
          (failure) => NoteWatcherState.loadFailure(failure),
          (notes) => NoteWatcherState.loadSuccess(notes),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _notesStreamSubscription.cancel();
    return super.close();
  }

  Stream<NoteWatcherState> _watcher(
    Stream<Either<NoteFailure, IList<Note>>> Function() watcherCallable,
  ) async* {
    yield const NoteWatcherState.loadInProgress();
    await _notesStreamSubscription?.cancel();
    _notesStreamSubscription = watcherCallable().listen((failureOrNotes) =>
        add(NoteWatcherEvent.notesReceived(failureOrNotes)));
  }
}
