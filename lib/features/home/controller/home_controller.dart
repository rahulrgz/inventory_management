import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/features/home/repository/home_repository.dart';
import 'package:inventory_management_shop/models/sales_model.dart';

import '../../../models/purchase_model.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(repository: ref.read(homeRepositoryProvider), ref: ref);
});

final getTotalSalePerDayStreamProvider = StreamProvider.family((ref,
        String data) =>
    ref.read(homeControllerProvider.notifier).getTotalSalesPerDay(data: data));

final getTotalPurchasePerDayProvider = StreamProvider.family(
    (ref, String data) => ref
        .read(homeControllerProvider.notifier)
        .getTotalPurchasePerDay(data: data));

final homeRepositoryProvider =
    Provider((ref) => HomeRepository(firestore: ref.read(firestoreProvider)));

class HomeController extends StateNotifier<bool> {
  final HomeRepository _repository;
  final Ref _ref;
  HomeController({required HomeRepository repository, required Ref ref})
      : _repository = repository,
        _ref = ref,
        super(false);

  Stream<List<SalesModel>> getTotalSalesPerDay({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.getTotalSalesPerDay(
        sid: map['sid'], uid: map['uid'], tody: DateTime.parse(map['tody']));
  }

  Stream<List<PurchaseModel>> getTotalPurchasePerDay({required String data}) {
    Map<String, dynamic> map = jsonDecode(data);
    return _repository.getTotalPurchasePerDay(
        uid: map['uid'], sid: map['sid'], tdy: DateTime.parse(map['tdy']));
  }
}
