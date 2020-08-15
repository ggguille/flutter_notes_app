import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_notes_app/domain/auth/auth_failure.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}