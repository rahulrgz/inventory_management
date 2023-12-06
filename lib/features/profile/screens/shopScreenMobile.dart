import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../core/constants/asset_constants/asset_constants.dart';
import '../../addstore/controller/addStore_controller.dart';

class ShopProfileMobile extends ConsumerWidget {
  final ShopModel shop;
  const ShopProfileMobile({super.key, required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        toolbarHeight: deviceHeight * 0.06,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              left: deviceWidth * 0.03, right: deviceWidth * 0.03),
          child: Column(
            children: [
              shop.shopProfile.isEmpty
                  ? CircleAvatar(
                      backgroundColor: Pallete.thirdColorMob,
                      radius: deviceHeight * 0.065,
                      backgroundImage: AssetImage(AssetConstants.noShop),
                    )
                  : CircleAvatar(
                      radius: deviceHeight * 0.065,
                      backgroundImage: NetworkImage(shop.shopProfile),
                    ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              SizedBox(
                width: deviceWidth * 0.8,
                child: Center(
                  child: Text(
                    shop.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor,
                        fontSize: deviceWidth * 0.07),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.001,
              ),
              Text(shop.category,
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth * 0.028)),
              SizedBox(
                height: deviceHeight * 0.04,
              ),
              Container(
                height: deviceHeight * 0.13,
                width: deviceWidth * 0.9,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/images/plan.jpg'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(deviceWidth * 0.03),
                  child: Row(
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Plan: ${shop.subscriptionId}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Pallete.primaryColor,
                                fontSize: deviceWidth * 0.05),
                          ),
                          Text(
                            "Expire : ${DateFormat("dd/MM/yyyy").format(shop.expirationDate)} ",
                            style: TextStyle(
                                color: Pallete.primaryColor,
                                fontSize: deviceWidth * 0.03),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Routemaster.of(context)
                              .replace('/store/${shop.shopId}');
                        },
                        child: Container(
                          height: deviceHeight * 0.075,
                          width: deviceWidth * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.3),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.right_chevron,
                              color: Pallete.primaryColor,
                              size: deviceHeight * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.pencil,
                  color: Pallete.secondaryColor,
                ),
                title: Text(
                  'EDIT PROFILE',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.05),
                ),
                onTap: () {
                  Routemaster.of(context)
                      .push('/store/homescreen/${shop.shopId}/editShop');
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.switch_access_shortcut,
                  color: Pallete.secondaryColor,
                ),
                title: Text(
                  'Switch Shop',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.05),
                ),
                onTap: () {
                  shopSwitchAlert(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.bell,
                  color: Pallete.secondaryColor,
                ),
                title: Text(
                  'Delete Shop',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.05),
                ),
                onTap: () {
                  deleteShop(context: context, shop: shop, ref: ref);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.login_outlined,
                  color: Pallete.secondaryColor,
                ),
                title: Text(
                  'LOG OUT',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.05),
                ),
                onTap: () {
                  logoutAlert(context);
                },
              ),
              SizedBox(
                height: deviceHeight * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  shopSwitchAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Pallete.primaryColor,
            fontSize: deviceWidth * 0.045),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Pallete.secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.08)),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: SizedBox(
          height: deviceHeight * 0.09,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to switch shop ?',
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            onPressed: () {
              Routemaster.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                Routemaster.of(context).replace('/store');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  void deleteShop(
      {required ShopModel shop,
      required WidgetRef ref,
      required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
          backgroundColor: Pallete.secondaryColor,
          title: const Text(
            'Are you sure you want to delete ?',
            style: TextStyle(color: Pallete.primaryColor),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.05),
                    side: const BorderSide(color: Pallete.primaryColor)),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Pallete.primaryColor, fontSize: deviceWidth * 0.04),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                shop = shop.copyWith(deleted: true);
                ref
                    .read(addStoreControllerProvider.notifier)
                    .deleteShop(context: context, shop: shop);
                Routemaster.of(context).replace('/store');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                    color: Pallete.blackColor, fontSize: deviceWidth * 0.04),
              ),
            ),
          ],
        );
      },
    );
  }

  void logoutAlert(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Pallete.primaryColor,
            fontSize: deviceWidth * 0.045),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Pallete.secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.08)),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: SizedBox(
          height: deviceHeight * 0.09,
          width: deviceWidth * 0.3,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Are you sure you want to log out?'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Routemaster.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logOut();
                Routemaster.of(context).replace('/signUp');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }
}
