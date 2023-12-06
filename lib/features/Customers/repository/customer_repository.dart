import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/models/customer_model.dart';

import '../../../core/constants/firebase_constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_def.dart';

final customerRepositoryProvider = Provider((ref) {
  return CustomerRepository(firestore: ref.watch(firestoreProvider));
});

class CustomerRepository {
  final FirebaseFirestore _firestore;
  CustomerRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _customer =>
      _firestore.collection(FirebaseConstants.customerCollection);

  FutureEither<CustomerModel> addCustomers(
      {required CustomerModel customerModel}) async {
    try {
      var docPhone = await _customer.doc(customerModel.phoneNumber).get();
      if (docPhone.exists) {
        throw "Phone number already exists!";
      }
      await _customer.doc(customerModel.phoneNumber).set(customerModel.toMap());
      return right(customerModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CustomerModel>> getCustomers(String shopId) {
    return _firestore
        .collection(FirebaseConstants.customerCollection)
        .where("shopId", arrayContains: shopId)
        .where("deleted", isEqualTo: false)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => CustomerModel.fromMap(e.data())).toList());
  }

  FutureVoid deleteCustomer(CustomerModel customerModel) async {
    try {
      return right(await _firestore
          .collection(FirebaseConstants.customerCollection)
          .doc(customerModel.phoneNumber)
          .update(customerModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      print(e);
      return left(Failure("An error occurred: $e"));
    }
  }
}
