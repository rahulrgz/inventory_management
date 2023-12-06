import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/constants/firebase_constants/firebase_constants.dart';
import 'package:inventory_management_shop/core/providers/firebase_providers.dart';
import 'package:inventory_management_shop/core/providers/storage_firebase.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/shopprofile/repository/edit_shop_repository.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';

final editShopControllerProvider =
    StateNotifierProvider<EditShopController, bool>((ref) {
  final editShopRepository = ref.watch(editShopRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return EditShopController(
      firestore: ref.watch(firestoreProvider),
      editShopRepository: editShopRepository,
      storageRepository: storageRepository,
      ref: ref);
});

class EditShopController extends StateNotifier<bool> {
  final EditShopRepository _editShopRepository;
  final StorageRepository _storageRepository;
  final FirebaseFirestore _firestore;
  final Ref _ref;
  EditShopController(
      {required EditShopRepository editShopRepository,
      required StorageRepository storageRepository,
      required Ref ref,
      required FirebaseFirestore firestore})
      : _editShopRepository = editShopRepository,
        _storageRepository = storageRepository,
        _firestore = firestore,
        _ref = ref,
        super(false);

  CollectionReference get _shops =>
      _firestore.collection(FirebaseConstants.shopsCollections);

  editShopProfile(
      {required BuildContext context,
      required Uint8List? file,
      required File? androidFile,
      required ShopModel shopeModel}) async {
    final userId = _ref.read(userProvider)?.uid ?? '';
    state = true;
    if (file != null || androidFile != null) {
      final image = await _storageRepository.storeFile(
          path: 'shops/profile/',
          id: userId,
          file: kIsWeb ? file : null,
          androidFile: kIsWeb ? null : androidFile);
      image.fold((l) => showSnackBar(context, l.message), (r) {
        shopeModel = shopeModel.copyWith(shopProfile: r);
        Routemaster.of(context).replace('/store');
      });
    }
    final res = await _editShopRepository.editShop(shopeModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {});
  }
}
