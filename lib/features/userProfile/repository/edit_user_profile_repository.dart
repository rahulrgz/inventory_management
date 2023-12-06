import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/failure.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import 'package:inventory_management_shop/models/user_model.dart';

final editUserProfileRepositoryProvider = Provider((ref) {
  return EditUserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class EditUserProfileRepository {
  final FirebaseFirestore _firestore;
  EditUserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollections);

  FutureEither<UserModel> editUserProfilePic(UserModel userModel) async {
    try {
      await _users.doc(userModel.uid).update(userModel.toMap());
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
