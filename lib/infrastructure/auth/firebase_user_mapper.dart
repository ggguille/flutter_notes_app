import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notes_app/domain/auth/user.dart';
import 'package:flutter_notes_app/domain/core/value_object.dart';

extension FirebaseUserDomainX on FirebaseUser {
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(uid)
    );
  }
}