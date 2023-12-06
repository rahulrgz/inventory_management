import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/stocks/repository/stock_repository.dart';
import '../../../core/utils.dart';
import '../../../models/sales_model.dart';
import '../../../models/stock_model.dart';

final stockControllerProvider =
    StateNotifierProvider<StockController, bool>((ref) {
  final stockRepository = ref.watch(stockRepositoryProvider);
  return StockController(stockRepository: stockRepository, ref: ref);
});
final stockStreamProvider = StreamProvider.family((ref, String data) {
  return ref.watch(stockControllerProvider.notifier).getStock(data: data);
});

final totalStockProvider = StreamProvider.family((ref, String data) =>
    ref.read(stockControllerProvider.notifier).totalStock(data: data));
final totalSale = StreamProvider.family((ref, String data) =>
    ref.read(stockControllerProvider.notifier).totalSales(data: data));

class StockController extends StateNotifier<bool> {
  final StockRepository _repository;
  StockController({required StockRepository stockRepository, required Ref ref})
      : _repository = stockRepository,
        super(false);
  addStock(
      {required String uid,
      required String shopId,
      required StockModel stockModel,
      required BuildContext context}) async {
    state = true;
    final res = await _repository.addStock(
        stockModel: stockModel, uid: uid, shopId: shopId);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Stock Added Successfully');
    });
  }

  Stream<List<StockModel>> getStock({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.getStock(
        uid: map['uid'], shopId: map['shopId'], search: map['search']);
  }

  Stream<List<StockModel>> stockCheck({
    required String uid,
    required String sid,
    required String search,
  }) {
    return _repository.getStock(uid: uid, shopId: sid, search: search);
  }

  Stream<List<StockModel>> totalStock({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.totalStock(uid: map['uid'], sid: map['sid']);
  }

  Stream<List<SalesModel>> totalSales({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.totalSales(uid: map['uid'], sid: map['sid']);
  }
}
