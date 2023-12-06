import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import '../../../core/constants/firebase_constants/firebase_constants.dart';
import '../../../models/sales_model.dart';
import '../../../models/shope_model.dart';

final repostRepositoryProvider = Provider((ref) {
  return ReportRepository(firestore: ref.watch(firestoreProvider));
});

class ReportRepository {
  final FirebaseFirestore firestore;
  ReportRepository({required this.firestore});

  Stream<List<SalesModel>> reportStreamSales(
      {required String uid, required String shopId}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.salesCollection)
        .snapshots()
        .map((event) {
      List<SalesModel> totalSale = [];
      for (var i in event.docs) {
        totalSale.add(SalesModel.fromJson(i.data()));
      }
      return totalSale;
    });
  }

  Stream<List<PurchaseModel>> reportStreamPurchase(
      {required String uid, required String shopId}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.purchaseCollection)
        .snapshots()
        .map((event) {
      List<PurchaseModel> totalPurchase = [];
      for (var i in event.docs) {
        totalPurchase.add(PurchaseModel.fromMap(i.data()));
      }
      return totalPurchase;
    });
  }

  Future<List<SalesModel>> fetchTotalSales(
      {required String uid, required String shopId}) async {
    final querySnapshot = await firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.salesCollection)
        .get();
    return querySnapshot.docs
        .map((doc) => SalesModel.fromJson(doc.data()))
        .toList();
  }
}
