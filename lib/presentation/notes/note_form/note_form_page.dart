import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_state.dart';
import 'package:flutter_notes_app/domain/notes/note.dart';
import 'package:flutter_notes_app/injection.dart';

class NoteFormPage extends StatelessWidget {
  final Note editingNote;

  const NoteFormPage({
    Key key,
    @required this.editingNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editingNote))),
      child: const NotePageScafold(),
    );
  }
}

class NotePageScafold extends StatelessWidget {
  const NotePageScafold({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (previous, current) =>
              previous.isEditing != current.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            onPressed: () {
              context.bloc<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
          )
        ],
      ),
    );
  }
}
