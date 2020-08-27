import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IAuthFacade)
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthFacade(
    this._firebaseAuth,
    this._googleSignIn,
  );

  @override
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password,
  }) async {
    final emailAddressStr = email.getOrCrash();
    final passwordStr = password.getOrCrash();
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
       email: emailAddressStr,
       password: passwordStr,
      );
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        return left(const AuthFailure.emailAlreadyInUse());
      }
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return left(const AuthFailure.cancelledByUser());
    }

    try {
      final googleAuthentication = await googleUser.authentication;
      final authCredentials = GoogleAuthProvider.getCredential(
        idToken: googleAuthentication.idToken,
        accessToken: googleAuthentication.accessToken,
      );
      await _firebaseAuth.signInWithCredential(authCredentials);
      return right(unit);
    } on PlatformException catch(_) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password,
  }) async {
    final emailAddressStr = email.getOrCrash();
    final passwordStr = password.getOrCrash();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddressStr,
        password: passwordStr,
      );
      return right(unit);
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD' || e.code == 'ERROR_USER_NOT_FOUND') {
        return left(const AuthFailure.invalidEmailAndPasswordCombination());
      }
      return left(const AuthFailure.serverError());
    }
  }
}
