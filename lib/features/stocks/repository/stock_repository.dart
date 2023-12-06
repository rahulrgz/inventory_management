import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import 'package:inventory_management_shop/models/stock_model.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../models/sales_model.dart';

final stockRepositoryProvider = Provider((ref) {
  return StockRepository(firestore: ref.watch(firestoreProvider));
});

class StockRepository {
  final FirebaseFirestore _firestore;

  StockRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollections);

  FutureEither<StockModel> addStock(
      {required String uid,
      required String shopId,
      required StockModel stockModel}) async {
    try {
      var docItemName = await _user
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.stockCollection)
          .doc(stockModel.itemName)
          .get();
      if (docItemName.exists) {
        StockModel existingStock = StockModel.fromMap(docItemName.data()!);
        stockModel.quantity += existingStock.quantity;
        existingStock.salePrice = stockModel.salePrice;
        await _user
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.stockCollection)
            .doc(stockModel.itemName)
            .update(stockModel.toMap());
      } else {
        // of the item does not exits add a new item
        await _user
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.stockCollection)
            .doc(stockModel.itemName)
            .set(stockModel.toMap());
      }

      return right(stockModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<StockModel>> getStock(
      {required String uid, required String shopId, required String search}) {
    return _user
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.stockCollection)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => StockModel.fromMap(e.data())).toList());
  }

  //Stream total stock in month ways
  Stream<List<StockModel>> totalStock(
      {required String uid, required String sid}) {
    return _firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.stockCollection)
        .snapshots()
        .map((event) {
      List<StockModel> totalStock = [];
      for (var i in event.docs) {
        totalStock.add(StockModel.fromMap(i.data()));
      }
      return totalStock;
    });
  }

  //stream the total sale

  Stream<List<SalesModel>> totalSales(
      {required String uid, required String sid}) {
    return _firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
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
}
