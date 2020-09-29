import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_state.dart';

class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  NoteFormBloc() : super(NoteFormState.initial());

  @override
  Stream<NoteFormState> mapEventToState(NoteFormEvent event) async* {
    yield* event.map(
      initialized: (e) async* {
        
      },
      bodyChanged: (e) async* {
        
      },
      colorChanged: (e) async* {
        
      },
      todosChanged: (e) async* {
        
      },
      saved: (e) async* {
        
      },
    );
  }
}
