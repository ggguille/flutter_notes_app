import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_block.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_state.dart';
import 'package:flutter_notes_app/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:flutter_notes_app/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) =>
              const Center(child: CircularProgressIndicator()),
          loadSuccess: (state) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final note = state.notes.toList()[index];
                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(
                    note: note,
                  );
                }
                return NoteCard(
                  note: note,
                );
              },
              itemCount: state.notes.length(),
            );
          },
          loadFailure: (state) {
            return Container(
              color: Colors.yellow,
              width: 200,
              height: 200,
            );
          },
        );
      },
    );
  }
}
