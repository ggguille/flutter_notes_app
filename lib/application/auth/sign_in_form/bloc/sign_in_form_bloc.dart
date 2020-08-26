import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_event.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_state.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {

  final IAuthFacade _authFacade;

  static final SignInFormState _initialState = SignInFormState.inital();

  SignInFormBloc(this._authFacade) : super(_initialState);

  @override
  Stream<SignInFormState> mapEventToState(SignInFormEvent event) async* {
    yield* event.map(
        emailChanged: (e) async* {
          yield state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccess: none()
          );
        },
        passwordChanged: (e) async* {
          yield state.copyWith(
              password: Password(e.passwordStr),
              authFailureOrSuccess: none()
          );
        },
        registerWithEmailAndPasswordPressed: (e) async* {
          yield* _performActionOnAuthFacadeWithEmailAndPassword(
              _authFacade.registerWithEmailAndPassword
          );
        },
        signInWithEmailAndPasswordPressed: (e) async* {
          yield* _performActionOnAuthFacadeWithEmailAndPassword(
              _authFacade.signInWithEmailAndPassword
          );
        },
        signInWithGooglePressed: (e) async* {
          yield state.copyWith(
              isSubmitting: true,
              authFailureOrSuccess: none()
          );
          final failureOrSuccess = await _authFacade.signInWithGoogle();
          yield state.copyWith(
              isSubmitting: false,
              authFailureOrSuccess: some(failureOrSuccess)
          );
        }
    );
  }

  Stream<SignInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function({
      @required EmailAddress email,
      @required Password password
    }) forwardedCall
  ) async* {
    Either<AuthFailure, Unit> failureOrSuccess;
    final isEmailAddressValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();
    if (isEmailAddressValid && isPasswordValid) {
      yield state.copyWith(
          isSubmitting: true,
          authFailureOrSuccess: none()
      );
      failureOrSuccess = await forwardedCall(
          email: state.emailAddress, password: state.password
      );
    }
    yield state.copyWith(
        isSubmitting: false,
        showErrorMessages: isEmailAddressValid && isPasswordValid,
        authFailureOrSuccess: optionOf(failureOrSuccess)
    );
  }
}