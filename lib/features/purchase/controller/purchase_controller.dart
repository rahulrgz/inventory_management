import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/purchase/repository/purchase_repository.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';

final purchaseControlProvider =
    StateNotifierProvider<PurchaseController, bool>((ref) {
  return PurchaseController(
      repository: ref.read(purchaseRepositoryProvider), ref: ref);
});

final purchasesStreamProvider = StreamProvider.family((ref, String data) =>
    ref.read(purchaseControlProvider.notifier).purchasesStream(data));
final totalPurchaseReturnProvider = StreamProvider.family((ref, String data) =>
    ref
        .read(purchaseControlProvider.notifier)
        .totalPurchaseReturns(data: data));
final purchaseReturnStreamProvider = StreamProvider.family((ref, String data) =>
    ref
        .read(purchaseControlProvider.notifier)
        .purchaseReturnStream(data: data));
final sortedPurchaseReturnStreamProvider = StreamProvider.family(
    (ref, String data) => ref
        .read(purchaseControlProvider.notifier)
        .sortedPurchaseReturnStream(data));
final sortedPurchaseStreamProvider = StreamProvider.family((ref, String data) =>
    ref.read(purchaseControlProvider.notifier).sortedPurchaseStream(data));

final rawAutoFieldSupplierProvider = StreamProvider<List<SupplierModel>>(
    (ref) => ref.read(purchaseControlProvider.notifier).getSupplier());

class PurchaseController extends StateNotifier<bool> {
  final PurchaseRepository _repository;
  final Ref _ref;
  PurchaseController({required PurchaseRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  addPurchase({
    required PurchaseModel purchaseModel,
    required String shopId,
    required SupplierModel supplierModel,
    required BuildContext context,
  }) async {
    final userId = _ref.read(userProvider)?.uid ?? '';
    state = true;
    var res = await _repository.addPurchase(
      uid: userId,
      purchaseModel: purchaseModel,
      shopId: shopId,
      supplierModel: supplierModel,
    );
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'purchase  added successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<PurchaseModel>> purchasesStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.purchasesStream(map['uid'], map['sid'], map['search']);
  }

  Stream<List<PurchaseReturnModel>> totalPurchaseReturns(
      {required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.totalPurchaseReturn(uid: map['uid'], sid: map['sid']);
  }

  Stream<List<PurchaseReturnModel>> sortedPurchaseReturnStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.sortedPurchaseReturnStream(
        uid: map['uid'],
        sid: map['sid'],
        search: map['search'],
        fDate: DateTime.parse(map['fDate']),
        tDate: DateTime.parse(map['tDate']));
  }

  Stream<List<PurchaseModel>> sortedPurchaseStream(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.sortedPurchaseStream(
        uid: map['uid'],
        sid: map['sid'],
        search: map['search'],
        fDate: DateTime.parse(map['fDate']),
        tDate: DateTime.parse(map['tDate']));
  }

  Stream<List<SupplierModel>> getSupplier() {
    return _repository.getSupplier();
  }

  addPurchaseReturn(
      {required String spId,
      required String pid,
      required BuildContext context,
      required PurchaseReturnModel purchaseReturnModel,
      required PurchaseModel purchaseModel}) async {
    final userId = _ref.read(userProvider)?.uid ?? '';
    state = true;
    final res = await _repository.addPurchaseReturn(
        uid: userId,
        shopId: spId,
        pid: pid,
        purchaseReturnModel: purchaseReturnModel,
        purchaseModel: purchaseModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
    });
  }

  Future<PurchaseModel> getPurchase(
      {required String spId, required String pid}) {
    final userId = _ref.read(userProvider)?.uid ?? '';
    return _repository.getPurchase(uid: userId, spId: spId, pid: pid);
  }

  Stream<List<PurchaseReturnModel>> purchaseReturnStream(
      {required String data}) {
    Map<String, dynamic> map = jsonDecode(data);

    return _repository.purchaseReturnStream(
        uid: map['uid'], shopid: map['sid'], search: map['search']);
  }
}
