import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/store_screen_mobile.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/addstore_controller.dart';

class NoStoreScreenMobile extends ConsumerStatefulWidget {
  const NoStoreScreenMobile({super.key});

  @override
  ConsumerState<NoStoreScreenMobile> createState() =>
      _NoStoreScreenMobileState();
}

class _NoStoreScreenMobileState extends ConsumerState<NoStoreScreenMobile> {
  bool deleteStore = false;
  @override
  Widget build(BuildContext context) {
    _launchPhone(String phoneNumber) async {
      String url = "tel:$phoneNumber";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void PopoupMessage(BuildContext context) {
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
                Text('Contact us our company please wait'),
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
            ElevatedButton(
              onPressed: () {
                _launchPhone('+91 7510 22 77 66');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Contact',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            ),
          ],
        ),
      );
    }

    final user = ref.watch(userProvider);
    return user == null
        ? Loader()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              toolbarHeight: deviceHeight * 0.1,
              leading: Row(
                children: [
                  SizedBox(
                    width: deviceWidth * 0.05,
                  ),
                  InkWell(
                    onTap: () {
                      Routemaster.of(context).push('/store/edit');
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user?.profilePic ?? ''),
                      backgroundColor: Pallete.secondaryColor,
                      radius: deviceWidth * 0.045,
                    ),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.015,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * 0.03,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * 0.04,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              leadingWidth: deviceWidth * 0.9,
              backgroundColor: Pallete.primaryColor,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    PopoupMessage(context);
                  },
                  icon: const Icon(
                    Icons.headset_mic_outlined,
                    color: Pallete.secondaryColor,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            deleteStore = !deleteStore;
                          });
                        },
                        child: Text(' deleted Store '))
                  ],
                ),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    Map<String, dynamic> map = {
                      'uid': user.uid,
                      'del': deleteStore
                    };
                    return ref
                        .watch(getUserShopsProvider(jsonEncode(map)))
                        .when(
                          data: (data) {
                            return data.isNotEmpty
                                ? StoreListScreenMobile(data: data)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Lottie.asset(AssetConstants.noDataLottie,
                                          width: deviceWidth * 0.75),
                                      SizedBox(
                                        height: deviceHeight * .05,
                                      ),
                                      Container(
                                        height: deviceHeight * 0.375,
                                        width: deviceWidth,
                                        decoration: const BoxDecoration(
                                          color: Pallete.secondaryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(35),
                                            topRight: Radius.circular(35),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: deviceWidth * 0.05,
                                            right: deviceWidth * 0.05,
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: deviceHeight * 0.06,
                                              ),
                                              Text(
                                                "Oops !",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        deviceWidth * 0.06),
                                              ),
                                              SizedBox(
                                                height: deviceHeight * 0.006,
                                              ),
                                              Text(
                                                "You haven't added any stores,\nRegister your store first",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        deviceWidth * 0.04),
                                              ),
                                              SizedBox(
                                                height: deviceHeight * 0.03,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(
                                                    width: deviceWidth * .35,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        minimumSize: Size(
                                                            deviceWidth * .3,
                                                            deviceHeight * .06),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      deviceWidth *
                                                                          0.1),
                                                        ),
                                                      ),
                                                      onPressed: () => Routemaster
                                                              .of(context)
                                                          .push(
                                                              '/store/addstore'),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Add Store",
                                                            style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: deviceWidth *
                                                                0.013,
                                                          ),
                                                          Icon(
                                                            CupertinoIcons
                                                                .arrow_right,
                                                            color: Pallete
                                                                .secondaryColor,
                                                            size: deviceWidth *
                                                                0.045,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: deviceHeight * 0.04,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => Loader(),
                        );
                  },
                ),
              ],
            )
            // ? StoreListScreenMobile()
            // :
            );
  }
}
