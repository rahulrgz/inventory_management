import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/models/billitem_model.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:inventory_management_shop/models/stock_model.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';

final purchaseRepositoryProvider = Provider((ref) {
  return PurchaseRepository(firestore: ref.read(firestoreProvider));
});

class PurchaseRepository {
  final FirebaseFirestore firestore;
  PurchaseRepository({required this.firestore});

  FutureEither<String> addPurchase({
    required PurchaseModel purchaseModel,
    required String uid,
    required String shopId,
    required SupplierModel supplierModel,
  }) async {
    try {
      for (var i in purchaseModel.products) {
        BillItems item = BillItems.fromMap(i);
        StockModel? existingStock;
        existingStock = await getStock(
          uid: uid,
          shopId: shopId,
          stockId: item.itemName,
        );
        if (existingStock != null) {
          existingStock = existingStock.copyWith(
            quantity: existingStock.quantity + item.itemQuantity,
          );
          await firestore
              .collection(FirebaseConstants.usersCollections)
              .doc(uid)
              .collection(FirebaseConstants.shopsCollections)
              .doc(shopId)
              .collection(FirebaseConstants.stockCollection)
              .doc(item.itemName)
              .update(existingStock.toMap());
        } else {
          StockModel stockModel = StockModel(
            itemName: item.itemName,
            salePrice: item.salePrice,
            purchasePrice: item.purchasePrice,
            unit: item.unit,
            quantity: int.parse(item.itemQuantity.toString()),
            setSearch: [item.itemName],
            deleted: false,
          );
          await firestore
              .collection(FirebaseConstants.usersCollections)
              .doc(uid)
              .collection(FirebaseConstants.shopsCollections)
              .doc(shopId)
              .collection(FirebaseConstants.stockCollection)
              .doc(stockModel.itemName)
              .set(stockModel.toMap());
        }
      }
      int count = 0;
      await firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.settingsCollection)
          .doc(FirebaseConstants.settingsCollection)
          .get()
          .then((value) async {
        count = int.tryParse(value.data()!['purchaseInvoice'].toString())!;
        await firestore
            .collection(FirebaseConstants.usersCollections)
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.settingsCollection)
            .doc(FirebaseConstants.settingsCollection)
            .update({'purchaseInvoice': FieldValue.increment(1)});
      });

      await firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.purchaseCollection)
          .doc('${count.toString()}')
          .set(purchaseModel.toMap());

      purchaseModel = purchaseModel.copyWith(
          id: '${count.toString()}',
          setSearch: setSearchParam(
              '${purchaseModel.name.trim()} ${count.toString()}'));
      firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.purchaseCollection)
          .doc('${count.toString()}')
          .update(purchaseModel.toMap());
      List<String> purchaseIds = supplierModel.PurchaseId;
      purchaseIds.add('${count.toString()}');
      supplierModel = supplierModel.copyWith(PurchaseId: purchaseIds);

      firestore
          .collection(FirebaseConstants.supplierCollection)
          .doc(supplierModel.phoneNumber)
          .set(supplierModel.tojson());

      return right('Added Successfully');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Stream<List<PurchaseModel>> purchasesStream(
      String uid, String pid, String search) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(pid)
        .collection(FirebaseConstants.purchaseCollection)
        // .orderBy('saleDate', descending: true)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<PurchaseModel> purchases = [];
      for (var data in event.docs) {
        purchases.add(PurchaseModel.fromMap(data.data()));
      }
      return purchases;
    });
  }

  Stream<List<PurchaseReturnModel>> sortedPurchaseReturnStream(
      {required String uid,
      required String sid,
      required DateTime fDate,
      required DateTime tDate,
      required String search}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.purchaseReturnCollection)
        .where('purchaseReturnDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(fDate))
        .where('purchaseReturnDate',
            isLessThanOrEqualTo: Timestamp.fromDate(tDate))
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<PurchaseReturnModel> purchase = [];
      for (var data in event.docs) {
        purchase.add(PurchaseReturnModel.fromMap(data.data()));
      }
      return purchase;
    });
  }

  Stream<List<PurchaseModel>> sortedPurchaseStream(
      {required String uid,
      required String sid,
      required DateTime fDate,
      required DateTime tDate,
      required String search}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.purchaseCollection)
        .where('purchaseDate', isGreaterThan: fDate)
        .where('purchaseDate', isLessThanOrEqualTo: tDate)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<PurchaseModel> purchase = [];
      for (var data in event.docs) {
        purchase.add(PurchaseModel.fromMap(data.data()));
      }
      return purchase;
    });
  }

  Stream<List<SupplierModel>> getSupplier() {
    return firestore
        .collection(FirebaseConstants.supplierCollection)
        .snapshots()
        .map((event) {
      List<SupplierModel> customer = [];
      for (var i in event.docs) {
        customer.add(SupplierModel.fromMap(i.data()));
      }
      return customer;
    });
  }

  FutureVoid addPurchaseReturn(
      {required String uid,
      required String shopId,
      required String pid,
      required PurchaseReturnModel purchaseReturnModel,
      required PurchaseModel purchaseModel}) async {
    try {
      for (var i in purchaseReturnModel.products) {
        StockModel? existingStock;
        existingStock =
            await getStock(uid: uid, shopId: shopId, stockId: i['itemName']);
        if (existingStock != null) {
          existingStock = existingStock.copyWith(
            quantity: existingStock.quantity - i['itemQuantity'] as int,
          );

          await firestore
              .collection(FirebaseConstants.usersCollections)
              .doc(uid)
              .collection(FirebaseConstants.shopsCollections)
              .doc(shopId)
              .collection(FirebaseConstants.stockCollection)
              .doc(i['itemName'])
              .set(existingStock.toMap());
        }
      }
      return right(await firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.purchaseCollection)
          .doc(pid)
          .update(purchaseModel.toMap())
          .then((value) async {
        await firestore
            .collection(FirebaseConstants.usersCollections)
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.purchaseReturnCollection)
            .add(purchaseReturnModel.toMap())
            .then((value) {
          PurchaseReturnModel purchaseReturn =
              purchaseReturnModel.copyWith(purchaseReturnId: value.id);
          value.update(purchaseReturn.toMap());
        });
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PurchaseReturnModel>> purchaseReturnStream({
    required String uid,
    required String shopid,
    required String search,
  }) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopid)
        .collection(FirebaseConstants.purchaseReturnCollection)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<PurchaseReturnModel> purchaseReturn = [];
      for (var i in event.docs) {
        purchaseReturn.add(PurchaseReturnModel.fromMap(i.data()));
      }
      return purchaseReturn;
    });
  }

  Stream<List<PurchaseReturnModel>> totalPurchaseReturn(
      {required String uid, required String sid}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.purchaseReturnCollection)
        .snapshots()
        .map((event) {
      List<PurchaseReturnModel> totalReturns = [];
      for (var i in event.docs) {
        totalReturns.add(PurchaseReturnModel.fromMap(i.data()));
      }
      return totalReturns;
    });
  }

  Future<PurchaseModel> getPurchase(
      {required String uid, required String spId, required String pid}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(spId)
        .collection(FirebaseConstants.purchaseCollection)
        .doc(pid)
        .get();
    PurchaseModel purchaseModel = PurchaseModel.fromMap(snapshot.data()!);
    return purchaseModel;
  }

  Future<StockModel?> getStock(
      {required String uid,
      required String shopId,
      required String stockId}) async {
    DocumentSnapshot<Map<String, dynamic>> res = await firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(shopId)
        .collection(FirebaseConstants.stockCollection)
        .doc(stockId)
        .get();
    if (res.exists) {
      return StockModel.fromMap(res.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
