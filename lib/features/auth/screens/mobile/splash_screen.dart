import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenMobile extends ConsumerStatefulWidget {
  const SplashScreenMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreenMobile> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<SplashScreenMobile> {
  getLocalStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey('uid')) {
      final user = pref.getString('uid');
      UserModel userModel = await ref
          .watch(authControllerProvider.notifier)
          .getUserData(user!)
          .first;
      ref.read(userProvider.notifier).update((state) => userModel);
      Routemaster.of(context).replace("/store");
    } else {
      Routemaster.of(context).replace("/welcome");
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      getLocalStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return const Scaffold(
      body: Center(child: Image(image: AssetImage(AssetConstants.appLogo))),
    );
  }
}
