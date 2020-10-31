import 'package:dartz/dartz.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_bloc.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_event.dart';
import 'package:flutter_notes_app/application/notes/note_form/note_form_state.dart';
import 'package:flutter_notes_app/domain/notes/value_objects.dart';
import 'package:flutter_notes_app/presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
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
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
            removeDuration: const Duration(),
            items: formTodos.value.toList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            itemBuilder: (context, itemAnimation, item, index) {
              return Reorderable(
                key: ValueKey(item.id),
                builder: (context, dragAnimation, inDrag) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 0.95)
                        .animate(dragAnimation),
                    child: TodoTile(
                      index: index,
                      elevation: dragAnimation.value * 4,
                    ),
                  );
                },
              );
            },
            onReorderFinished: (item, from, to, newItems) {
              context.formTodos = IList.from(newItems);
              context
                  .bloc<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.formTodos));
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;
  final double elevation;

  const TodoTile({
    @required this.index,
    double elevation,
    Key key,
  })  : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = _findTodoItemByIndex(context.formTodos);
    final textEditingController = useTextEditingController(text: todo.name);

    return Slidable(
      actionPane: const SlidableBehindActionPane(),
      actionExtentRatio: 0.15,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.formTodos = context.formTodos.filter(
              (todoItem) => todoItem != todo,
            );
            context
                .bloc<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.formTodos));
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) {
                  context.formTodos = context.formTodos.map(
                    (todoItem) => todoItem == todo
                        ? todo.copyWith(done: value)
                        : todoItem,
                  );
                  context
                      .bloc<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
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
                    (todoItem) => todoItem == todo
                        ? todo.copyWith(name: value)
                        : todoItem,
                  );
                  context
                      .bloc<NoteFormBloc>()
                      .add(NoteFormEvent.todosChanged(context.formTodos));
                },
                validator: (value) {
                  return context
                      .bloc<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
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
            ),
          ),
        ),
      ),
    );
  }

  TodoItemPrimitive _findTodoItemByIndex(
      IList<TodoItemPrimitive> listTodoItem) {
    return listTodoItem.foldLeftWithIndex<TodoItemPrimitive>(
      TodoItemPrimitive.empty(),
      (TodoItemPrimitive previous, int todoItemIndex,
          TodoItemPrimitive todoItem) {
        if (index == todoItemIndex) {
          return todoItem;
        }
        return previous;
      },
    );
  }
}
