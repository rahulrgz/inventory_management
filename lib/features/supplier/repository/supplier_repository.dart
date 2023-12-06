import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import '../../../core/constants/firebase_constants/firebase_constants.dart';
import '../../../core/failure.dart';

final supplierRepositoryProvider = Provider((ref) {
  return SupplierRepository(firestore: ref.watch(firestoreProvider));
});

class SupplierRepository {
  final FirebaseFirestore _firestore;
  SupplierRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _supplier =>
      _firestore.collection(FirebaseConstants.supplierCollection);
  FutureEither<SupplierModel> addSuppliers(
      {required SupplierModel supplierModel}) async {
    try {
      var docPhone = await _supplier.doc(supplierModel.phoneNumber).get();
      if (docPhone.exists) {
        throw "Phone number already exists!";
      }
      await _supplier
          .doc(supplierModel.phoneNumber)
          .set(supplierModel.tojson());
      return right(supplierModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<SupplierModel>> getSupplier(String shopId) {
    return _firestore
        .collection(FirebaseConstants.supplierCollection)
        .where("shopId", arrayContains: shopId)
        .where("deleted", isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => SupplierModel.fromMap(e.data())).toList());
  }

  FutureVoid deleteSupplier(SupplierModel supplierModel) async {
    try {
      return right(await _firestore
          .collection(FirebaseConstants.supplierCollection)
          .doc(supplierModel.phoneNumber)
          .update(supplierModel.tojson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure("An error occurred: $e"));
    }
  }
}
