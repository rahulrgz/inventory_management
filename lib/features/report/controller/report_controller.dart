import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/report/repository/report_repository.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';

import '../../../models/sales_model.dart';

final reportControllerProvider =
    StateNotifierProvider<ReportController, bool>((ref) {
  final reportRepository = ref.watch(repostRepositoryProvider);
  return ReportController(ref: ref, reportRepository: reportRepository);
});

final reportSalesStreamProvider = StreamProvider.family((ref, String data) =>
    ref.watch(reportControllerProvider.notifier).reportStreamSales(data: data));
final reportPurchaseStreamProvider = StreamProvider.family((ref, String data) =>
    ref
        .watch(reportControllerProvider.notifier)
        .reportStreamPurchase(data: data));

final fetchTotalSalesProvider = FutureProvider.family((ref, String data) =>
    ref.watch(reportControllerProvider.notifier).fetchTotalSales(data: data));

class ReportController extends StateNotifier<bool> {
  final ReportRepository _repository;
  final Ref _ref;
  ReportController(
      {required ReportRepository reportRepository, required Ref ref})
      : _repository = reportRepository,
        _ref = ref,
        super(false);

  Stream<List<SalesModel>> reportStreamSales({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.reportStreamSales(shopId: map['sid'], uid: map['uid']);
  }

  Stream<List<PurchaseModel>> reportStreamPurchase({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.reportStreamPurchase(
        shopId: map['sid'], uid: map['uid']);
  }

  Future<List<SalesModel>> fetchTotalSales({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.fetchTotalSales(uid: map['uid'], shopId: map['shopId']);
  }
}
