import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/providers/storage_firebase.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/utils.dart';
import '../../../models/plans_model.dart';
import '../../../models/shope_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/addstore_repository.dart';

final addStoreControllerProvider =
    StateNotifierProvider<AddStoreController, bool>((ref) {
  final addStoreRepository = ref.watch(addStoreRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return AddStoreController(
    addStoreRepository: addStoreRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final shopProvider = StateProvider<ShopModel?>((ref) => null);

final getUserShopWebProvider = StreamProvider.family((ref, String sid) {
  return ref.watch(addStoreControllerProvider.notifier).getCurrentShopWeb(sid);
});

final getUserShopsProvider =
    StreamProvider.family.autoDispose((ref, String data) {
  return ref.watch(addStoreControllerProvider.notifier).getUserShops(data);
});
final plansProvider = StreamProvider(
    (ref) => ref.read(addStoreControllerProvider.notifier).getplans());

class AddStoreController extends StateNotifier<bool> {
  final AddStoreRepository _addStoreRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  AddStoreController({
    required AddStoreRepository addStoreRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _addStoreRepository = addStoreRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  addShop({
    required BuildContext context,
    required ShopModel shopeModel,
    required Uint8List? profilePic,
    required File? androidFile,
  }) async {
    if (profilePic != null || androidFile != null) {
      final userid = _ref.read(userProvider)?.uid ?? '';
      state = true;
      final image = await _storageRepository.storeFile(
          path: 'shops/profile/',
          id: userid + DateTime.now().toString(),
          file: kIsWeb ? profilePic : null,
          androidFile: kIsWeb ? null : androidFile);
      state = false;
      image.fold((l) => showSnackBar(context, l.toString()),
          (r) => shopeModel = shopeModel.copyWith(shopProfile: r));
    }
    state = true;
    final res = await _addStoreRepository.addStore(shopeModel: shopeModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Store Added Successfully');
      Routemaster.of(context).pop();
    });
  }

  addShopMobile(
      {required BuildContext context, required ShopModel shopeModel}) async {
    final userid = _ref.read(userProvider)?.uid ?? '';
    state = true;
    final res = await _addStoreRepository.addStore(shopeModel: shopeModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Store Added Successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<ShopModel>> getUserShops(String data) {
    Map<String, dynamic> map = jsonDecode(data);
    return _addStoreRepository.getUserShops(map['uid'], map['del']);
  }

  Stream<List<PlanModel>> getplans() {
    return _addStoreRepository.getplans();
  }

  Stream<ShopModel> getCurrentShop(String sid, String uid) {
    return _addStoreRepository.getCurrentShop(sid, uid);
  }

  Stream<ShopModel> getCurrentShopWeb(String sid) {
    String userId = _ref.read(userProvider)!.uid;
    return _addStoreRepository.getCurrentShopWeb(sid, userId);
  }

  Future<void> addSub(
      {required BuildContext context, required ShopModel shop}) async {
    state = true;
    var res = await _addStoreRepository.updateShop(shop: shop);
    state = false;
    res.fold((l) => showSnackBar(context, l.toString()), (r) {
      showSnackBar(context, 'Subscribed Successfully');
      Routemaster.of(context).pop();
    });
  }

  Future<void> deleteShop(
      {required BuildContext context, required ShopModel shop}) async {
    var res = await _addStoreRepository.updateShop(shop: shop);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'deleted');
      Routemaster.of(context).pop();
    });
  }
}
