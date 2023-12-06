import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/firebase_constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_def.dart';
import '../../../models/plans_model.dart';
import '../../../models/shope_model.dart';

final addStoreRepositoryProvider = Provider((ref) {
  return AddStoreRepository(firestore: ref.watch(firestoreProvider));
});

class AddStoreRepository {
  final FirebaseFirestore _firestore;

  AddStoreRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollections);
  FutureEither<ShopModel> addStore({required ShopModel shopeModel}) async {
    try {
      await _users
          .doc(shopeModel.uid)
          .collection(FirebaseConstants.shopsCollections)
          .add(shopeModel.toMap())
          .then((value) async {
        ShopModel updateShop = shopeModel.copyWith(shopId: value.id);
        value.update(updateShop.toMap());
        await value
            .collection(FirebaseConstants.settingsCollection)
            .doc('settings')
            .set({
          'saleInvoice': 100,
          'purchaseInvoice': 100,
          'reference': value
        });
      });
      return right(shopeModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<ShopModel>> getUserShops(String uid, bool del) {
    return _users
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .where('deleted', isEqualTo: del)
        .snapshots()
        .map((event) {
      List<ShopModel> shops = [];
      for (var doc in event.docs) {
        shops.add(ShopModel.fromMap(doc.data()));
      }
      return shops;
    });
  }

  Stream<List<PlanModel>> getplans() {
    return _firestore
        .collection(FirebaseConstants.plansCollections)
        .orderBy('price', descending: false)
        .where("deleted", isEqualTo: false)
        .snapshots()
        .map(
      (event) {
        List<PlanModel> plan = [];
        for (var i in event.docs) {
          plan.add(PlanModel.fromMap(i.data()));
        }
        return plan;
      },
    );
  }

  Stream<ShopModel> getCurrentShop(String sid, String uid) {
    return _users
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .snapshots()
        .map((event) => ShopModel.fromMap(event.data()!));
  }

  Stream<ShopModel> getCurrentShopWeb(String sid, String uid) {
    return _users
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .snapshots()
        .map(
            (event) => ShopModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid updateShop({required ShopModel shop}) async {
    try {
      return right(await _users
          .doc(shop.uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shop.shopId)
          .update(shop.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
