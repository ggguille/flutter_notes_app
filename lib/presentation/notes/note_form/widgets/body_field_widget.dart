import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';

class BodyField extends StatelessWidget {
  const BodyField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Note',
          counterText: '',
        ),
        maxLength: NoteBody.maxLength,
        maxLines: null,
        minLines: 5,
        onChanged: (value) =>
            context.bloc<NoteFormBloc>().add(NoteFormEvent.bodyChanged(value)),
        validator: (_) =>
            context.bloc<NoteFormBloc>().state.note.body.value.fold(
                  (failure) => failure.maybeMap(
                    empty: (_) => 'Cannot be empty',
                    exceedingLength: (f) => 'Exceeding length, max: ${f.max}',
                    orElse: () => null,
                  ),
                  (r) => null,
                ),
      ),
    );
  }
}
