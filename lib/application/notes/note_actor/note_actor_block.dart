import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_actor/note_actor_event.dart';
import 'package:flutter_notes_app/application/notes/note_actor/note_actor_state.dart';
import 'package:flutter_notes_app/domain/notes/i_note_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial());

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    yield const NoteActorState.actionInProgress();
    final possiblefailure = await _noteRepository.delete(event.note);
    yield possiblefailure.fold(
      (failure) => NoteActorState.deleteFailure(failure),
      (_) => const NoteActorState.deleteSuccess(),
    );
  }
}
