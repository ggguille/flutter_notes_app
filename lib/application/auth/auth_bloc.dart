import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/auth/auth_event.dart';
import 'package:flutter_notes_app/application/auth/auth_state.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    yield* event.map(
      authCheckRequested: (e) async* {
        final userOption = await _authFacade.getSignedUser();
        yield userOption.fold(() => const AuthState.unauthenticated(),
            (_) => const AuthState.authenticated());
      },
      signedOut: (e) async* {
        await _authFacade.signOut();
        yield const AuthState.unauthenticated();
      },
    );
  }
}
