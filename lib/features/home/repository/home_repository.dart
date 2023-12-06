import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/sales_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

//here get the total sale perday where sale date grater than curent date
  Stream<List<SalesModel>> getTotalSalesPerDay(
      {required String uid, required String sid, required DateTime tody}) {
    return _firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.salesCollection)
        .where('saleDate', isGreaterThan: tody)
        .snapshots()
        .map((event) {
      List<SalesModel> totalSalesList = [];
      for (var i in event.docs) {
        totalSalesList.add(SalesModel.fromJson(i.data()));
      }
      return totalSalesList;
    });
  }

//here get the total purcase perday where purchase date grater than curent date
  Stream<List<PurchaseModel>> getTotalPurchasePerDay(
      {required String uid, required String sid, required DateTime tdy}) {
    return _firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.purchaseCollection)
        .where('purchaseDate', isGreaterThan: tdy)
        .snapshots()
        .map((event) {
      List<PurchaseModel> totalPurchaseList = [];
      for (var i in event.docs) {
        totalPurchaseList.add(PurchaseModel.fromMap(i.data()));
      }
      return totalPurchaseList;
    });
  }
}
