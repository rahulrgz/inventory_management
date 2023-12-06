import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/controller/addStore_controller.dart';
import 'package:inventory_management_shop/features/addstore/screens/web/store_screen_web.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';

class NoStoreScreenWeb extends ConsumerStatefulWidget {
  const NoStoreScreenWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<NoStoreScreenWeb> createState() => _NoStoreScreenWebState();
}

class _NoStoreScreenWebState extends ConsumerState<NoStoreScreenWeb> {
  bool deleteStore = false;
  void logOut(WidgetRef ref, BuildContext context) {
    ref.watch(authControllerProvider.notifier).logOut();
    Routemaster.of(context).replace('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    // deviceHeight = MediaQuery.of(context).size.height;
    // deviceWidth = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceHeight * 0.1,
        leadingWidth: deviceWidth * 0.2,
        elevation: 0,
        backgroundColor: Pallete.primaryColor,
        leading: Row(
          children: [
            SizedBox(
              width: deviceWidth * 0.015,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user?.profilePic ?? ''),
              backgroundColor: Pallete.secondaryColor,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.007),
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * 0.01),
                      ),
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * 0.0125,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              logOut(ref, context);
            },
            icon: const Icon(Icons.logout),
            color: Pallete.secondaryColor,
          ),
          SizedBox(
            width: deviceWidth * 0.015,
          ),
          IconButton(
            onPressed: () =>
                Routemaster.of(context).push('/store/userSettings'),
            icon: const Icon(Icons.more_vert),
            color: Pallete.secondaryColor,
          ),
          SizedBox(
            width: deviceWidth * 0.015,
          )
        ],
      ),
      body: user == null
          ? Center(
              child: Loader(),
            )
          : Column(
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
                  builder: (context, ref1, child) {
                    Map<String, dynamic> map = {
                      'uid': user.uid,
                      'del': deleteStore
                    };
                    return ref
                        .watch(getUserShopsProvider(jsonEncode(map)))
                        .when(
                            data: (data) {
                              return data.isNotEmpty
                                  ? StoreScreenWeb(data: data)
                                  : Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Lottie.network(
                                              'https://lottie.host/10f75a75-17e7-4019-9048-15f7d9da102f/cM6kcPoqp8.json',
                                              height: deviceHeight * 0.4,
                                              width: deviceWidth * 0.5,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: deviceHeight * 0.8,
                                          width: deviceWidth * 0.5,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: deviceHeight * 0.6,
                                                width: deviceWidth * 0.5,
                                                decoration: BoxDecoration(
                                                  color: Pallete.secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        deviceWidth * 0.015),
                                                    bottomLeft: Radius.circular(
                                                        deviceWidth * 0.015),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      deviceWidth * 0.025),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Oops !',
                                                          style: TextStyle(
                                                              color: Pallete
                                                                  .primaryColor,
                                                              fontSize:
                                                                  deviceWidth *
                                                                      0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          height: deviceHeight *
                                                              0.015,
                                                        ),
                                                        Text(
                                                          "You haven't added any stores,\nRegister your store first",
                                                          style: TextStyle(
                                                            color: Pallete
                                                                .primaryColor,
                                                            fontSize:
                                                                deviceWidth *
                                                                    0.01,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: deviceHeight *
                                                              0.35,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () =>
                                                                    Routemaster.of(
                                                                            context)
                                                                        .push(
                                                                            '/store/addStore'),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      deviceWidth *
                                                                          0.015,
                                                                      deviceHeight *
                                                                          0.055),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(deviceWidth *
                                                                              0.015)),
                                                                  backgroundColor:
                                                                      Pallete
                                                                          .primaryColor,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Text(
                                                                      "Add Store",
                                                                      style: TextStyle(
                                                                          color: Pallete
                                                                              .secondaryColor,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              deviceWidth * 0.01),
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_sharp,
                                                                      size: deviceWidth *
                                                                          0.015,
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader());
                  },
                )
              ],
            ),
    );
  }
}
