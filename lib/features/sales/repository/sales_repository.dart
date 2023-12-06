import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/failure.dart';
import 'package:inventory_management_shop/core/type_def.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/models/billitem_model.dart';
import 'package:inventory_management_shop/models/customer_model.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import '../../../models/stock_model.dart';

class SalesRepository {
  final FirebaseFirestore firestore;
  SalesRepository({required this.firestore});

  FutureEither<String> addSales(
      {required SalesModel salesModel,
      required String uid,
      required String shopId,
      required CustomerModel customerModel}) async {
    try {
      for (var i in salesModel.products) {
        BillItems items = BillItems.fromMap(i);
        StockModel? existingStock;
        existingStock = await getStock(
          uid: uid,
          shopId: shopId,
          stockId: items.itemName,
        );
        if (existingStock != null) {
          existingStock = existingStock.copyWith(
            quantity: existingStock.quantity - items.itemQuantity,
          );
          await firestore
              .collection(FirebaseConstants.usersCollections)
              .doc(uid)
              .collection(FirebaseConstants.shopsCollections)
              .doc(shopId)
              .collection(FirebaseConstants.stockCollection)
              .doc(items.itemName)
              .set(existingStock.toMap());
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
        count = int.tryParse(value.data()!['saleInvoice'].toString())!;
        await firestore
            .collection(FirebaseConstants.usersCollections)
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.settingsCollection)
            .doc(FirebaseConstants.settingsCollection)
            .update({'saleInvoice': FieldValue.increment(1)});
      });
      await firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.salesCollection)
          .doc('${count.toString()}')
          .set(salesModel.toJson());
      salesModel = salesModel.copyWith(
          id: "${count.toString()}",
          setSearch:
              setSearchParam('${salesModel.name.trim()} ${count.toString()}'));

      firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.salesCollection)
          .doc('${count.toString()}')
          .update(salesModel.toJson());
      List<String> salesIds = customerModel.saleId;
      salesIds.add('${count.toString()}');
      List<String> shopIds = customerModel.shopId;
      if (!shopIds.contains(shopId)) {
        shopIds.add(shopId);
      }
      customerModel = customerModel.copyWith(saleId: salesIds);
      firestore
          .collection(FirebaseConstants.customerCollection)
          .doc(customerModel.phoneNumber)
          .set(customerModel.toMap());
      return right('Added Successfully');
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (error) {
      return left(Failure(error.toString()));
    }
  }

  Stream<List<SalesModel>> salesStream(String uid, String sid, String search) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.salesCollection)
        .orderBy('saleDate', descending: true)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<SalesModel> sales = [];
      for (var data in event.docs) {
        sales.add(SalesModel.fromJson(data.data()));
      }
      return sales;
    });
  }

  Stream<List<SaleReturnModel>> sortedSalesReturnStream(
      {required String uid,
      required String sid,
      required String search,
      required DateTime fDate,
      required DateTime tDate}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.salesReturnCollection)
        .where('saleReturnDate', isGreaterThan: fDate)
        .where('saleReturnDate', isLessThanOrEqualTo: tDate)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<SaleReturnModel> sales = [];
      for (var data in event.docs) {
        sales.add(SaleReturnModel.fromMap(data.data()));
      }
      return sales;
    });
  }

  Stream<List<SalesModel>> sortedSalesStream(
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
        .collection(FirebaseConstants.salesCollection)
        .where('saleDate', isGreaterThan: fDate)
        .where('saleDate', isLessThanOrEqualTo: tDate)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<SalesModel> sales = [];
      for (var data in event.docs) {
        sales.add(SalesModel.fromJson(data.data()));
      }
      return sales;
    });
  }

  Stream<List<CustomerModel>> getCustomer() {
    return firestore
        .collection(FirebaseConstants.customerCollection)
        .snapshots()
        .map((event) {
      List<CustomerModel> customer = [];
      for (var i in event.docs) {
        customer.add(CustomerModel.fromMap(i.data()));
      }
      return customer;
    });
  }

  FutureVoid addSalesReturn(
      {required String uid,
      required String shopId,
      required String sid,
      required SaleReturnModel saleReturnModel,
      required SalesModel salesModel}) async {
    try {
      for (var i in saleReturnModel.products) {
        // BillItems item = BillItems.fromMap(i);
        StockModel? existingStock;
        existingStock = await getStock(
          uid: uid,
          shopId: shopId,
          stockId: i['itemName'],
        );
        if (existingStock != null) {
          existingStock = existingStock.copyWith(
            quantity: existingStock.quantity + i['itemQuantity'] as int,
          );
          await firestore
              .collection(FirebaseConstants.usersCollections)
              .doc(uid)
              .collection(FirebaseConstants.shopsCollections)
              .doc(shopId)
              .collection(FirebaseConstants.stockCollection)
              .doc(i['itemName'])
              .update(existingStock.toMap());
        } else {
          StockModel stockModel = StockModel(
            itemName: i['itemName'],
            salePrice: i['salePrice'],
            purchasePrice: i['purchasePrice'],
            unit: i['unit'],
            quantity: i['itemQuantity'],
            setSearch: [i['itemName']],
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
      return right(await firestore
          .collection(FirebaseConstants.usersCollections)
          .doc(uid)
          .collection(FirebaseConstants.shopsCollections)
          .doc(shopId)
          .collection(FirebaseConstants.salesCollection)
          .doc(sid)
          .update(salesModel.toJson())
          .then((value) async {
        await firestore
            .collection(FirebaseConstants.usersCollections)
            .doc(uid)
            .collection(FirebaseConstants.shopsCollections)
            .doc(shopId)
            .collection(FirebaseConstants.salesReturnCollection)
            .add(saleReturnModel.toMap())
            .then((value) {
          SaleReturnModel saleReturn =
              saleReturnModel.copyWith(saleReturnId: value.id);
          value.update(saleReturn.toMap());
        });
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

//streming sales return user and its iteems
  Stream<List<SaleReturnModel>> salesReturnStream({
    required String uid,
    required String spId,
    required search,
  }) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(spId)
        .collection(FirebaseConstants.salesReturnCollection)
        .where('setSearch', arrayContains: search.isEmpty ? null : search)
        .snapshots()
        .map((event) {
      List<SaleReturnModel> salesReturn = [];
      for (var i in event.docs) {
        salesReturn.add(SaleReturnModel.fromMap(i.data()));
      }
      return salesReturn;
    });
  }

  Stream<Map<String, dynamic>> salesInvoice({
    required String uid,
    required String spId,
  }) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(spId)
        .collection('settings')
        .doc('settings')
        .snapshots()
        .map((event) => event.data() as Map<String, dynamic>);
  }

  Stream<List<SaleReturnModel>> TotalSaleReturn(
      {required String uid, required String sid}) {
    return firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(sid)
        .collection(FirebaseConstants.salesReturnCollection)
        .snapshots()
        .map((event) {
      List<SaleReturnModel> totalReturns = [];
      for (var i in event.docs) {
        totalReturns.add(SaleReturnModel.fromMap(i.data()));
      }
      return totalReturns;
    });
  }

  Future<SalesModel> getSale(
      {required String uid, required String spId, required String sid}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(FirebaseConstants.usersCollections)
        .doc(uid)
        .collection(FirebaseConstants.shopsCollections)
        .doc(spId)
        .collection(FirebaseConstants.salesCollection)
        .doc(sid)
        .get();
    SalesModel salesModel = SalesModel.fromJson(snapshot.data()!);
    return salesModel;
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
