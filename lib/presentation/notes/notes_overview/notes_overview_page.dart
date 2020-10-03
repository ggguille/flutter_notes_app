import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/auth/auth_bloc.dart';
import 'package:flutter_notes_app/application/auth/auth_event.dart';
import 'package:flutter_notes_app/application/auth/auth_state.dart';
import 'package:flutter_notes_app/application/notes/note_actor/note_actor_block.dart';
import 'package:flutter_notes_app/application/notes/note_actor/note_actor_state.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_block.dart';
import 'package:flutter_notes_app/application/notes/note_watcher/note_watcher_event.dart';
import 'package:flutter_notes_app/injection.dart';
import 'package:flutter_notes_app/presentation/routes/router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unauthenticated: (_) =>
                    ExtendedNavigator.of(context).replace(Routes.signInPage),
                orElse: () {},
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    duration: const Duration(seconds: 5),
                    message: state.failure.map(
                      unexpected: (_) =>
                          'Unexpected error occured while deleting, please contact support.',
                      insufficientPermissions: (_) =>
                          'Insufficient permissions ❌',
                      unableToUpdate: (_) => 'Impossible error',
                    ),
                  ).show(context);
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.bloc<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.indeterminate_check_box),
                onPressed: () {},
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO navigate to NoteFormPage
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}