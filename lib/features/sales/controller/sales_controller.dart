import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils.dart';
import '../../../models/customer_model.dart';
import '../../../models/sales_model.dart';
import '../../../models/stock_model.dart';
import '../repository/sales_repository.dart';

final salesControllerProvider =
    StateNotifierProvider<SalesController, bool>((ref) {
  return SalesController(
      repository: ref.read(salesRepositoryProvider), ref: ref);
});

final salesReturnStreamProvider = StreamProvider.family((ref, String data) =>
    ref.read(salesControllerProvider.notifier).salesReturnStream(data: data));
final sortedSalesStreamProvider = StreamProvider.family((ref, String data) =>
    ref.read(salesControllerProvider.notifier).sortedSalesStream(data));
final sigleSaleProvider = StateProvider<SalesModel?>((ref) {
  return null;
});
final singleSaleReturnProvider = StateProvider<SaleReturnModel?>((ref) => null);
final sortedSalesReturnStreamProvider = StreamProvider.family((ref,
        String data) =>
    ref.read(salesControllerProvider.notifier).sortedSalesReturnStream(data));
final salesStreamProvider = StreamProvider.family((ref, String data) =>
    ref.read(salesControllerProvider.notifier).salesStream(data));
final salesInvoiceStreamProvider = StreamProvider.family((ref, String sid) =>
    ref.read(salesControllerProvider.notifier).salesInvoice(spId: sid));

final totalSaleReturnProvider = StreamProvider.family((ref, String data) =>
    ref.read(salesControllerProvider.notifier).TotalSaleReturns(data: data));

final salesRepositoryProvider = Provider((ref) {
  return SalesRepository(firestore: ref.read(firestoreProvider));
});
final rawAutoFieldCustomerProvider = StreamProvider<List<CustomerModel>>(
    (ref) => ref.read(salesControllerProvider.notifier).getCustomer());

class SalesController extends StateNotifier<bool> {
  final SalesRepository _repository;
  final Ref _ref;
  SalesController({required SalesRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  addSales(
      {required SalesModel salesModel,
      required String sId,
      required CustomerModel customerModel,
      required BuildContext context}) async {
    final userId = _ref.read(userProvider)?.uid ?? '';
    state = true;
    var res = await _repository.addSales(
        salesModel: salesModel,
        uid: userId,
        shopId: sId,
        customerModel: customerModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, r);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<SaleReturnModel>> TotalSaleReturns({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.TotalSaleReturn(uid: map['uid'], sid: map['sid']);
  }

  Stream<List<SaleReturnModel>> salesReturnStream({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.salesReturnStream(
        uid: map['uid'], spId: map['sid'], search: map['search']);
  }

  Stream<List<SaleReturnModel>> sortedSalesReturnStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.sortedSalesReturnStream(
        uid: map['uid'],
        sid: map['sid'],
        search: map['search'],
        fDate: DateTime.parse(map['fDate']),
        tDate: DateTime.parse(map['tDate']));
  }

  Stream<List<SalesModel>> sortedSalesStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.sortedSalesStream(
        uid: map['uid'],
        sid: map['sid'],
        search: map['search'],
        fDate: DateTime.parse(map['fDate']),
        tDate: DateTime.parse(map['tDate']));
  }

  Stream<List<SalesModel>> salesStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.salesStream(map['uid'], map['sid'], map['search']);
  }

  Stream<List<CustomerModel>> getCustomer() {
    return _repository.getCustomer();
  }

  addSalesReturn(
      {required String spId,
      required String sid,
      required BuildContext context,
      required SaleReturnModel saleReturnModel,
      required SalesModel salesModel}) async {
    state = true;
    final userId = _ref.read(userProvider)?.uid ?? '';
    final res = await _repository.addSalesReturn(
        uid: userId,
        shopId: spId,
        sid: sid,
        saleReturnModel: saleReturnModel,
        salesModel: salesModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'sales return added');
      Routemaster.of(context).pop();
    });
  }

  Future<SalesModel> getSale({required String spId, required String sid}) {
    final userId = _ref.read(userProvider)?.uid ?? '';
    return _repository.getSale(uid: userId, spId: spId, sid: sid);
  }

  Stream<Map<String, dynamic>> salesInvoice({
    required String spId,
  }) {
    final userId = _ref.read(userProvider)?.uid ?? '';
    return _repository.salesInvoice(uid: userId, spId: spId);
  }
}
