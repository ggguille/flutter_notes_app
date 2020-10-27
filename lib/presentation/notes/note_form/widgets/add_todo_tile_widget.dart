import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_state.dart';
import 'package:flutter_notes_app/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        Provider.of<FormTodos>(context, listen: false).value =
            state.note.todos.value.fold(
          (failure) => IList.from([]),
          (todoItemList) => todoItemList
              .map((todoItem) => TodoItemPrimitive.fromDomain(todoItem)),
        );
      },
      buildWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a todo'),
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          onTap: () {
            Provider.of<FormTodos>(context, listen: false).value =
                Provider.of<FormTodos>(context, listen: false)
                    .value
                    .appendElement(TodoItemPrimitive.empty());
            context.bloc<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(
                      Provider.of<FormTodos>(context, listen: false).value),
                );
          },
        );
      },
    );
  }
}
