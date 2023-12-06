import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import '../../../core/failure.dart';
import '../../../models/expense_model.dart';

final expenseRepositoryProvider = Provider((ref) {
  return ExpenseRepository(firestore: ref.watch(firestoreProvider));
});

class ExpenseRepository {
  final FirebaseFirestore _firestore;
  ExpenseRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollections);

  FutureEither<ExpenseModel> addExpense({
    required ExpenseModel expenseModel,
    required String uid,
  }) async {
    try {
      _user
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(expenseModel.shopId)
          .collection(FirebaseConstants.expenseCollection)
          .add(expenseModel.toMap())
          .then((value) {
        ExpenseModel updatedExpense = expenseModel.copyWith(eid: value.id);
        value.update(updatedExpense.toMap());
      });
      return right(expenseModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ExpenseModel>> getExpense(
      {required String shopId, required String uid}) {
    return _user
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.expenseCollection)
        .where("deleted", isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => ExpenseModel.fromMap(e.data())).toList());
  }
}
