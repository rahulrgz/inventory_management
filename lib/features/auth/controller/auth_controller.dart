import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/auth/repository/auth_repository.dart';
import 'package:inventory_management_shop/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider.autoDispose<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signinWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signinWithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) async {
      _ref.read(userProvider.notifier).update((state) => userModel);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uid', userModel.uid);
      Routemaster.of(context).replace('/store');
    });
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logOut() {
    _authRepository.logOut();
  }
}
