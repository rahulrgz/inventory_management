import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/providers/storage_firebase.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/expense/repository/expense_repository.dart';
import 'package:inventory_management_shop/models/expense_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, bool>((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return ExpenseController(
      ref: ref,
      expenseRepostitory: expenseRepository,
      storageRepository: storageRepository);
});

final getExpenseProvider =
    StreamProvider.family.autoDispose((ref, String data) {
  return ref.watch(expenseControllerProvider.notifier).getExpense(data);
});

class ExpenseController extends StateNotifier<bool> {
  final ExpenseRepository _expenseRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ExpenseController(
      {required ExpenseRepository expenseRepostitory,
      required StorageRepository storageRepository,
      required Ref ref})
      : _expenseRepository = expenseRepostitory,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  addExpense(
      {required BuildContext context,
      required File? expensePickAndroid,
      required Uint8List? expensePickWeb,
      required ExpenseModel expenseModel}) async {
    final userId = _ref.read(userProvider)!.uid;
    if (expensePickAndroid != null || expensePickWeb != null) {
      state = true;
      final image = await _storageRepository.storeFile(
          path: 'expense/bill',
          id: userId + DateTime.now().toString(),
          file: kIsWeb ? expensePickWeb : null,
          androidFile: kIsWeb ? null : expensePickAndroid);
      state = false;
      image.fold((l) => showSnackBar(context, l.toString()),
          (r) => expenseModel = expenseModel.copyWith(expenseImage: r));
    }
    state = true;
    final res = await _expenseRepository.addExpense(
        expenseModel: expenseModel, uid: userId);
    state = false;
    res.fold((l) {
      showSnackBar(context, l.message);
    }, (r) {
      showSnackBar(context, 'Expense Added Successfully');
    });
  }

  Stream<List<ExpenseModel>> getExpense(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _expenseRepository.getExpense(uid: map['uid'], shopId: map['sid']);
  }
}
