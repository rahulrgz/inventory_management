import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../addstore/controller/addStore_controller.dart';
import '../../../auth/controller/auth_controller.dart';
import 'edit_shop_tab.dart';

class ShopProfileScreenTab extends StatefulWidget {
  final ShopModel shop;

  const ShopProfileScreenTab({super.key, required this.shop});

  @override
  State<ShopProfileScreenTab> createState() => _ShopProfileScreenTabState();
}

class _ShopProfileScreenTabState extends State<ShopProfileScreenTab> {
  logout(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut();
    Routemaster.of(context).replace('/welcome');
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
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.primaryColor)),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Pallete.primaryColor, fontSize: deviceWidth * 0.017),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                shop = shop.copyWith(deleted: true);
                ref
                    .read(addStoreControllerProvider.notifier)
                    .deleteShop(context: context, shop: shop);
                Routemaster.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Delete',
                style: TextStyle(
                    color: Pallete.blackColor, fontSize: deviceWidth * 0.017),
              ),
            ),
          ],
        );
      },
    );
  }

  logoutAlert() {
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
            borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: SizedBox(
          height: deviceHeight * 0.12,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to logout ?',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
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
              minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            onPressed: () {
              Routemaster.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: deviceWidth * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                logout(ref, context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                    fontSize: deviceWidth * 0.02,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  shopSwitchAlert() {
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
            borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: SizedBox(
          height: deviceHeight * 0.12,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to switch shop ?',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
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
              minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            onPressed: () {
              Routemaster.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: deviceWidth * 0.02,
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
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                    fontSize: deviceWidth * 0.02,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  encodeAndNavigate(
      {required ShopModel shop,
      required String pageCategory,
      required BuildContext context}) {
    Map<String, dynamic> map = {
      'uid': shop.uid,
      'shopProfile': shop.shopProfile,
      'category': shop.category,
      'name': shop.name,
      'shopId': shop.shopId,
      'subscriptionId': shop.subscriptionId,
      'createdTime': shop.createdTime.toIso8601String(),
      'deleted': shop.deleted,
      'setSearch': shop.setSearch,
      'accepted': shop.accepted,
      'blocked': shop.blocked,
      'reason': shop.reason
    };
    final String encode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/${shop.shopId}/$pageCategory/${Uri.encodeComponent(encode)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = widget.shop;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: deviceWidth,
            height: deviceHeight * 0.35,
            color: Pallete.secondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: deviceHeight * 0.2,
                  width: deviceWidth,
                  // color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      shop.shopProfile.isEmpty
                          ? CircleAvatar(
                              radius: deviceHeight * 0.08,
                              backgroundImage: const AssetImage(
                                  'assets/images/defaultStoreImage-web.png'),
                              backgroundColor: Colors.white,
                            )
                          : CircleAvatar(
                              radius: deviceHeight * 0.08,
                              backgroundImage: NetworkImage(shop.shopProfile),
                            ),
                      SizedBox(
                        width: deviceWidth * 0.015,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: TextStyle(
                              fontSize: deviceHeight * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Pallete.primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'Created Date : ${DateFormat("dd-MM-yyyy").format(shop.createdTime)}',
                            style: TextStyle(
                              fontSize: deviceHeight * 0.03,
                              color: Pallete.primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.03,
                  width: deviceWidth,
                  // color: Colors.red,
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.075,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: deviceHeight * 0.4,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(4, 4))
                    ],
                    image: const DecorationImage(
                        image: AssetImage(AssetConstants.plan),
                        fit: BoxFit.cover),
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(deviceHeight * 0.05)),
                child: Padding(
                  padding: EdgeInsets.only(left: deviceHeight * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.02,
                            right: deviceHeight * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('View More >',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceHeight * 0.024))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.07,
                      ),
                      Text(
                        shop.subscriptionId,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: deviceHeight * 0.06,
                            color: Pallete.primaryColor),
                      ),
                      // Text(
                      //   'MEMBERSHIP',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: deviceHeight * 0.06,
                      //       color: Pallete.primaryColor),
                      // ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      Text(
                        'Valid Upto: ${DateFormat('yMMMd').format(shop.expirationDate)}',
                        style: TextStyle(
                            fontSize: deviceHeight * 0.03,
                            color: Pallete.primaryColor),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.03,
                      ),
                      // Container(
                      //   height: deviceHeight * 0.065,
                      //   width: deviceWidth * 0.13,
                      //   decoration: BoxDecoration(
                      //     color: Pallete.primaryColor,
                      //     borderRadius:
                      //         BorderRadius.circular(deviceHeight * 0.01),
                      //   ),
                      //   child: Center(
                      //     child: Text(
                      //       'UPGRADE PLAN',
                      //       style: TextStyle(
                      //           fontSize: deviceHeight * 0.027,
                      //           fontWeight: FontWeight.bold,
                      //           color: Pallete.secondaryColor),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: deviceWidth * 0.3,
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // editProfile(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditShopProfileTab(
                                shopId: shop.shopId,
                              ),
                            ));
                      },
                      leading: const Icon(Icons.edit),
                      title: const Text('Edit Shop Profile'),
                    ),
                    ListTile(
                      onTap: () {
                        shopSwitchAlert();
                      },
                      leading: const Icon(Icons.login_outlined),
                      title: const Text('Switch Shop'),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return ListTile(
                          onTap: () {
                            deleteShop(shop: shop, ref: ref, context: context);
                          },
                          leading: const Icon(CupertinoIcons.bin_xmark),
                          title: const Text('Delete Shop'),
                        );
                      },
                    ),
                    ListTile(
                      onTap: () {
                        logoutAlert();
                      },
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
