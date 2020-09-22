import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_notes_app/domain/auth/i_auth_facade.dart';
import 'package:flutter_notes_app/domain/core/error.dart';
import 'package:flutter_notes_app/injection.dart';

extension FirestoreEx on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedUser();
    final user = userOption.getOrElse(() => throw NotAuthenticateError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection("notes");
}
