import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/failure.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/core/type_def.dart';

import '../../../models/shope_model.dart';

final editShopRepositoryProvider = Provider((ref) {
  return EditShopRepository(firestore: ref.watch(firestoreProvider));
});

class EditShopRepository {
  final FirebaseFirestore _firestore;
  EditShopRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollections);
  FutureVoid editShop(ShopModel shopeModel) async {
    try {
      return right(await _users
          .doc(shopeModel.uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopeModel.shopId)
          .update(shopeModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
