import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/providers/storage_firebase.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/userProfile/repository/edit_user_profile_repository.dart';
import 'package:inventory_management_shop/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';

final editUserProfileControllerProvider =
    StateNotifierProvider<EditUserProfileController, bool>((ref) {
  return EditUserProfileController(
      editUserProfileRepository: ref.watch(editUserProfileRepositoryProvider),
      storageRepository: ref.watch(storageRepositoryProvider),
      ref: ref);
});

class EditUserProfileController extends StateNotifier<bool> {
  final EditUserProfileRepository _editUserProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  EditUserProfileController(
      {required EditUserProfileRepository editUserProfileRepository,
      required StorageRepository storageRepository,
      required Ref ref})
      : _editUserProfileRepository = editUserProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);
  editUserProfilePic(
      {required BuildContext context,
      required Uint8List? file,
      required File? androidFile,
      required UserModel userModel}) async {
    final userId = _ref.read(userProvider)?.uid ?? '';
    state = true;
    if (file != null || androidFile != null) {
      final image = await _storageRepository.storeFile(
          path: 'users/profile/',
          id: userId,
          file: kIsWeb ? file : null,
          androidFile: kIsWeb ? null : androidFile);
      image.fold((l) => showSnackBar(context, l.message), (r) {
        userModel = userModel.copyWith(profilePic: r);
        Routemaster.of(context).pop();
      });
    }
    final res = await _editUserProfileRepository.editUserProfilePic(userModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => r);
    });
  }
}
