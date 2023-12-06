import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/controller/addStore_controller.dart';
import 'package:inventory_management_shop/features/addstore/screens/tab/store_list_tab.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class NoStoreScreenTab extends ConsumerStatefulWidget {
  const NoStoreScreenTab({super.key});

  @override
  ConsumerState<NoStoreScreenTab> createState() => _NoStoreScreenTabState();
}

class _NoStoreScreenTabState extends ConsumerState<NoStoreScreenTab> {
  bool deleteStore = false;
  logout(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut();
    Routemaster.of(context).replace('/welcome');
  }

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

    void popUpMessage(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Pallete.primaryColor,
              fontSize: deviceHeight * 0.025),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Pallete.secondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
          actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
          content: Text(
            '\nDo you want to connect helpdesk',
            style: TextStyle(fontSize: deviceHeight * 0.035),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.primaryColor)),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: deviceHeight * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Pallete.primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _launchPhone('+91 7510 22 77 66');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                ),
              ),
              child: Text(
                'Contact',
                style: TextStyle(
                    fontSize: deviceHeight * 0.03,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            ),
          ],
        ),
      );
    }

    final user = ref.watch(userProvider);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Pallete.primaryColor,
            toolbarHeight: deviceWidth * 0.08,
            leadingWidth: deviceWidth * 0.5,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/store/userprofile');
              },
              child: Row(
                children: [
                  SizedBox(width: deviceWidth * 0.02),
                  CircleAvatar(
                    foregroundImage: NetworkImage(user!.profilePic),
                    radius: deviceHeight * 0.032,
                  ),
                  SizedBox(width: deviceWidth * 0.01),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Pallete.blackColor,
                            fontSize: deviceWidth * 0.015),
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Pallete.blackColor,
                            fontSize: deviceWidth * 0.017),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  popUpMessage(context);
                },
                icon: Icon(
                  Icons.headset_mic_outlined,
                  color: Pallete.blackColor,
                  size: deviceWidth * 0.02,
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.05,
                width: deviceWidth * 0.2,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        deleteStore = !deleteStore;
                      });
                    },
                    child: Text('deleted Store')),
              ),
              Consumer(builder: (context, ref, child) {
                Map<String, dynamic> map = {
                  'uid': user.uid,
                  'del': deleteStore
                };
                return ref.watch(getUserShopsProvider(jsonEncode(map))).when(
                      data: (data) {
                        return data.isNotEmpty
                            ? Container(
                                height: deviceHeight * 0.75,
                                width: deviceWidth,
                                child: StoreListTab(data: data))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: deviceWidth * 0.45,
                                    // color: Colors.red,
                                    child: Lottie.network(
                                      'https://lottie.host/e8859ea3-c96c-4c8d-ad82-b2687bbf59d2/sYDi3SILeq.json',
                                      height: deviceHeight * 0.41,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(80),
                                              topLeft: Radius.circular(80)),
                                          color: Pallete.secondaryColor,
                                        ),
                                        height: deviceHeight * 0.75,
                                        width: deviceWidth * 0.4,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: deviceHeight * 0.1,
                                              top: deviceHeight * 0.02),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: deviceWidth * 0.05,
                                              ),
                                              Text(
                                                "Oops!",
                                                style: TextStyle(
                                                    color: Pallete.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        deviceWidth * 0.027),
                                              ),
                                              SizedBox(
                                                height: deviceWidth * 0.015,
                                              ),
                                              Text(
                                                "You haven't added any stores,\nRegister Your store first",
                                                style: TextStyle(
                                                    color: Pallete.primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        deviceWidth * 0.017),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: deviceWidth * 0.05,
                                                    left: deviceWidth * 0.14),
                                                child: InkWell(
                                                  onTap: () =>
                                                      Routemaster.of(context)
                                                          .push('addstore'),
                                                  child: Container(
                                                    height: deviceWidth * 0.05,
                                                    width: deviceWidth * 0.15,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Pallete
                                                            .primaryColor),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("Add Store",
                                                            style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.018)),
                                                        Icon(
                                                          Icons.arrow_forward,
                                                          color: Pallete
                                                              .secondaryColor,
                                                          size: deviceWidth *
                                                              0.018,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              }),
            ],
          )),
    );
  }
}
