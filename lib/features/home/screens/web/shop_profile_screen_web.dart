import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/alert_dialog_boxes_web.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/no_store_screen_mobile.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../router.dart';
import '../../../addstore/controller/addStore_controller.dart';
import '../../../addstore/screens/web/store_screen_web.dart';
import '../../../addstore/screens/web/subscription_screen_web.dart';
import '../../../analysis/screens/web/shop_analysis_screen_web.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../shopprofile/screens/web/edit_shop_profile_web.dart';

class Shop_Profile_Screen_Web extends ConsumerWidget {
  final String shopId;
  final ShopModel shopeModel;
  const Shop_Profile_Screen_Web(
      {super.key, required this.shopeModel, required this.shopId});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  showLogoutAlertDialog(BuildContext context, Function logOutCallback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Pallete.secondaryColor,

          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          // Set the background color to red
          title: Text(
            'Log Out',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            TextButton(
              onPressed: () {
                logOutCallback(); // Call the logOut function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Yes',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ShopModel shop = shopeModel;
    return Container(
      child: Column(
        children: [
          SizedBox(height: deviceHeight * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: deviceHeight * 0.6,
                width: deviceWidth * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Pallete.containerColor,
                ),
                child: Column(
                  children: [
                    SizedBox(height: deviceHeight * 0.03),
                    shopeModel.shopProfile.isEmpty
                        ? CircleAvatar(
                            radius: 75,
                            backgroundImage: AssetImage(
                                'assets/images/defaultStoreImage-web.png'),
                            backgroundColor: Colors.white,
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                heightFactor: deviceHeight * 0.14,
                                widthFactor: deviceWidth * 0.05,
                                child: CircleAvatar(
                                  radius: 20.1,
                                  backgroundColor: Pallete.blackColor,
                                  child: GestureDetector(
                                    onTap: () => Routemaster.of(context).push(
                                        '/store/homescreen/$shopId/editShopProfile'),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Pallete.primaryColor,
                                      child: Center(
                                        child: Icon(Icons.edit_rounded,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth * 0.016),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          )
                        : CircleAvatar(
                            radius: 75,
                            backgroundImage:
                                NetworkImage(shopeModel.shopProfile),
                            backgroundColor: Colors.transparent,
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                heightFactor: deviceHeight * 0.14,
                                widthFactor: deviceWidth * 0.05,
                                child: CircleAvatar(
                                  radius: 20.1,
                                  backgroundColor: Pallete.blackColor,
                                  child: GestureDetector(
                                    onTap: () => Routemaster.of(context).push(
                                        '/store/homescreen/$shopId/editShopProfile'),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Pallete.primaryColor,
                                      child: Center(
                                        child: Icon(Icons.edit_rounded,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth * 0.016),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                    SizedBox(height: deviceHeight * 0.01),
                    Text(
                      shopeModel.name,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: textColor,
                          fontSize: deviceWidth * 0.02),
                    ),
                    Text(
                      shopeModel.category,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: textColor,
                          fontSize: deviceWidth * 0.01),
                    ),
                    SizedBox(height: deviceHeight * 0.05),
                    Container(
                      width: deviceWidth * 0.310,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Pallete.secondaryColor,
                      ),
                      height: deviceWidth * 0.08,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: deviceWidth * 0.01),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: deviceWidth * 0.02),
                                  child: Text(shopeModel.subscriptionId,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Pallete.primaryColor,
                                          fontSize: deviceWidth * 0.015)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: deviceWidth * 0.03),
                                  child: Text(
                                    'Expire on  : ${DateFormat('dd/MM/yyyy').format(shopeModel.expirationDate)}',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Pallete.primaryColor,
                                        fontSize: deviceWidth * 0.012,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: deviceWidth * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                Routemaster.of(context).replace(
                                    '/store/addStore/:planSubscription');
                              },
                              child: Container(
                                height: deviceHeight * 0.06,
                                width: deviceWidth * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.withOpacity(0.5)),
                                child: Center(
                                    child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Pallete.primaryColor,
                                  size: deviceWidth * 0.02,
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: deviceWidth * 0.04),
              Container(
                height: deviceHeight * 0.6,
                width: deviceWidth * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Pallete.containerColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceHeight * 0.09, left: deviceWidth * 0.03),
                      child: Row(children: [
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditShopProfileWeb(
                                      shopId: shopId,
                                    )),
                          ),
                          child: Icon(Icons.edit,
                              color: textColor, size: deviceWidth * 0.02),
                        ),
                        SizedBox(height: deviceHeight * 0.05),
                        SizedBox(width: deviceWidth * 0.01),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditShopProfileWeb(shopId: shopId)),
                          ),
                          child: Text(
                            'edit Shop Profiler',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: deviceWidth * 0.02,
                                color: textColor),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceHeight * 0.08, left: deviceWidth * 0.03),
                      child: Row(children: [
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StoreScreenWeb(data: [shop]))),
                          child: Icon(Icons.switch_access_shortcut,
                              color: textColor, size: deviceWidth * 0.02),
                        ),
                        SizedBox(width: deviceWidth * 0.01),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StoreScreenWeb(data: [shop]))),
                          child: Text('Switch Shop',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: deviceWidth * 0.02,
                                  color: textColor)),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceHeight * 0.08, left: deviceWidth * 0.03),
                      child: Row(children: [
                        InkWell(
                          onTap: () => deleteShop(
                              shop: shop, ref: ref, context: context),
                          child: Icon(CupertinoIcons.settings,
                              color: textColor, size: deviceWidth * 0.02),
                        ),
                        SizedBox(width: deviceWidth * 0.01),
                        InkWell(
                          onTap: () => deleteShop(
                              shop: shop, ref: ref, context: context),
                          child: Text(
                            'Delete Shop',
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: deviceWidth * 0.02,
                                color: textColor),
                          ),
                        )
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceHeight * 0.08, left: deviceWidth * 0.03),
                      child: Row(children: [
                        Consumer(
                          builder: (context, ref, child) => InkWell(
                            onTap: () {
                              showLogoutAlertDialog(context, () {
                                logOut(ref);
                                Routemaster.of(context).push('/welcome');
                              });
                            },
                            child: Icon(Icons.logout,
                                color: textColor, size: deviceWidth * 0.02),
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.01),
                        Consumer(
                          builder: (context, ref, child) => InkWell(
                            onTap: () {
                              showLogoutAlertDialog(context, () {
                                logOut(ref);
                                Routemaster.of(context).push('/welcome');
                              });
                            },
                            child: Text(
                              'LOG OUT',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: deviceWidth * 0.02,
                                  color: textColor),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
