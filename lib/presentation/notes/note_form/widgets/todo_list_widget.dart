import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_state.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';
import 'package:flutter_notes_app/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_notes_app/presentation/notes/note_form/misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: 'Want longer list? Activate premium',
            button: const FlatButton(
              onPressed: null,
              child: Text(
                'BUY NOW',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.length(),
            itemBuilder: (context, index) {
              return TodoTile(
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;

  const TodoTile({
    @required this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = context.formTodos.foldLeftWithIndex<TodoItemPrimitive>(
      TodoItemPrimitive.empty(),
      (TodoItemPrimitive previous, int todoItemIndex,
          TodoItemPrimitive todoItem) {
        if (index == todoItemIndex) {
          return todoItem;
        }
        return previous;
      },
    );
    final textEditingController = useTextEditingController(text: todo.name);

    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          context.formTodos = context.formTodos.map(
            (todoItem) =>
                todoItem == todo ? todo.copyWith(done: value) : todoItem,
          );
          context
              .bloc<NoteFormBloc>()
              .add(NoteFormEvent.todosChanged(context.formTodos));
        },
      ),
      title: TextFormField(
        controller: textEditingController,
        decoration: const InputDecoration(
          hintText: 'Todo',
          counterText: '',
          border: InputBorder.none,
        ),
        maxLength: TodoName.maxLength,
        onChanged: (value) {
          context.formTodos = context.formTodos.map(
            (todoItem) =>
                todoItem == todo ? todo.copyWith(name: value) : todoItem,
          );
          context
              .bloc<NoteFormBloc>()
              .add(NoteFormEvent.todosChanged(context.formTodos));
        },
        validator: (value) {
          return context.bloc<NoteFormBloc>().state.note.todos.value.fold(
                (failure) => null,
                (todoList) => todoList.toList()[index].name.value.fold(
                      (failure) => failure.maybeMap(
                        empty: (_) => 'Cannot be empty',
                        exceedingLength: (_) => 'Too long',
                        multiline: (_) => 'Has to be in a single line',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
              );
        },
      ),
    );
  }
}
