// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
// import 'package:inventory_management_shop/models/supplier_model.dart';
// import '../../../core/providers/storage_firebase.dart';
// import '../../../core/utils.dart';
// import '../repository/supplier_repository.dart';
//
// final supplierControllerProvider =
//     StateNotifierProvider<SupplierController, bool>((ref) {
//   final supplierRepository = ref.watch(supplierRepositoryProvider);
//   final storageRepository = ref.watch(storageRepositoryProvider);
//   return SupplierController(
//       supplierRepository: supplierRepository,
//       storageRepository: storageRepository,
//       ref: ref);
// });
// final getSupplierProvider =
//     StreamProvider.family.autoDispose((ref, String shopId) {
//   return ref.watch(supplierControllerProvider.notifier).getSupplier(shopId);
// });
//
// class SupplierController extends StateNotifier<bool> {
//   final SupplierRepository _supplierRepository;
//   final StorageRepository _storageRepository;
//   final Ref _ref;
//   SupplierController({
//     required SupplierRepository supplierRepository,
//     required StorageRepository storageRepository,
//     required Ref ref,
//   })  : _supplierRepository = supplierRepository,
//         _storageRepository = storageRepository,
//         _ref = ref,
//         super(false);
//   addSuppliers(
//       {required BuildContext context,
//       required SupplierModel supplierModel,
//       required File? androidFile,
//       required Uint8List? profileFile}) async {
//     final userId = _ref.read(userProvider)?.uid ?? "";
//     state = true;
//     final image = await _storageRepository.storeFile(
//       path: 'suppliers/profile/',
//       id: userId + DateTime.now().toString(),
//       file: kIsWeb ? profileFile! : null,
//       androidFile: kIsWeb ? null : androidFile!,
//     );
//     state = false;
//     image.fold((l) => showSnackBar(context, l.message), (url) async {
//       supplierModel = supplierModel.copyWith(supplierProfile: url);
//       final res = await _supplierRepository.addSuppliers(
//         supplierModel: supplierModel,
//       );
//       res.fold((l) => showSnackBar(context, l.message), (r) {
//         showSnackBar(context, "Supplier Profile Added Successfully");
//       });
//     });
//   }
//
//   Stream<List<SupplierModel>> getSupplier(String shopId) {
//     return _supplierRepository.getSupplier(shopId);
//   }
//
//   deleteSupplier(SupplierModel supplierModel, BuildContext context) async {
//     var dele = await _supplierRepository.deleteSupplier(supplierModel);
//     dele.fold((l) => showSnackBar(context, l.message),
//         (r) => showSnackBar(context, "Supplier Details deleted successfully"));
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import '../../../core/utils.dart';
import '../repository/supplier_repository.dart';

final supplierControllerProvider =
    StateNotifierProvider<SupplierController, bool>((ref) {
  final supplierRepository = ref.watch(supplierRepositoryProvider);
  return SupplierController(supplierRepository: supplierRepository, ref: ref);
});
final getSupplierProvider =
    StreamProvider.family<List<SupplierModel>, String>((ref, shopId) {
  return ref.watch(supplierControllerProvider.notifier).getSupplier(shopId);
});

class SupplierController extends StateNotifier<bool> {
  final SupplierRepository _supplierRepository;
  final Ref _ref;

  SupplierController({
    required SupplierRepository supplierRepository,
    required Ref ref,
  })  : _supplierRepository = supplierRepository,
        _ref = ref,
        super(false);

  addSuppliers(
      {required BuildContext context,
      required SupplierModel supplierModel}) async {
    state = true;
    final res = await _supplierRepository.addSuppliers(
      supplierModel: supplierModel,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Supplier Profile Added Successfully"),
    );
  }

  Stream<List<SupplierModel>> getSupplier(String shopId) {
    return _supplierRepository.getSupplier(shopId);
  }

  deleteSupplier(SupplierModel supplierModel, BuildContext context) async {
    var delete = await _supplierRepository.deleteSupplier(supplierModel);
    delete.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, "Supplier Details deleted successfully"),
    );
  }
}
