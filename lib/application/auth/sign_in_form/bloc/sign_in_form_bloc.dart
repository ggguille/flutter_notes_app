import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_event.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_state.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {

  final IAuthFacade _authFacade;

  static final SignInFormState _initialState = SignInFormState.inital();

  SignInFormBloc(this._authFacade) : super(_initialState);

  @override
  Stream<SignInFormState> mapEventToState(SignInFormEvent event) {
    // TODO: implement
  }
}