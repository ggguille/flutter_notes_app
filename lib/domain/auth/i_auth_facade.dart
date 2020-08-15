import 'package:flutter/foundation.dart';
import 'package:flutter_notes_app/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<void> registerWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password
  });
  Future<void> signInWithEmailAndPassword({
    @required EmailAddress email,
    @required Password password
  });
  Future<void> signInWithGoogle();
}