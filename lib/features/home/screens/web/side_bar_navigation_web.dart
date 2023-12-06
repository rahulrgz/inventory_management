import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/home/screens/web/shop_home_screen_web.dart';
import 'package:inventory_management_shop/features/home/screens/web/shop_profile_screen_web.dart';
import 'package:marquee/marquee.dart';
import 'package:routemaster/routemaster.dart';
import '../../../addstore/controller/addstore_controller.dart';
import '../../../report/screens/web/reportScreenWeb.dart';
import '../../../stocks/screens/web/add_stock_web.dart';

class SideBarNavigationWeb extends ConsumerStatefulWidget {
  final String shopId;
  const SideBarNavigationWeb({Key? key, required this.shopId})
      : super(key: key);

  @override
  ConsumerState<SideBarNavigationWeb> createState() =>
      _SideBarNavigationWebState();
}

class _SideBarNavigationWebState extends ConsumerState<SideBarNavigationWeb> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  DateTime currentDate = DateTime.now();

  Widget calculateDiff({required DateTime exp}) {
    DateTime threeDaysBeforeExpiration = exp.subtract(Duration(days: 3));
    if (DateTime.now().isAfter(threeDaysBeforeExpiration)) {
      return Marquee(
        text:
            'Remember, Your plan will  expire on ${DateFormat('dd-MM-yyyy hh:mm a').format(exp)}',
        style: TextStyle(
            fontWeight: FontWeight.w200,
            color: Colors.red[700],
            fontSize: deviceWidth * 0.0125),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: deviceWidth * 0.7,
        velocity: 100.0,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      );
    } else {
      return Text('');
    }
  }

  @override
  void initState() {
    // getCurrentShop(widget.encode);
    // print(shopeModel);
    //
    // print(widget.encode);
    // print("@@@@@@@@@@@@@@@@@@@@");
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

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
  // getCurrentShop(String id) async {
  //   print("&&&&&&&&&&&&&&&&&&&&&&&&&&&77");
  //   shopeModel= await ref.read(addStoreControllerProvider.notifier).getCurrentShopWeb(id);
  //   setState(() {
  //
  //   });
  //   print(shopeModel);
  //   print("%%%%%%%%%%%%%%%%");
  //   print(widget.encode);
  //   print("++++++++++++++++++++");
  //
  // }

  @override
  void dispose() {
    sideMenu.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserShopWebProvider(widget.shopId)).when(
          data: (data) {
            return Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SideMenu(
                    showToggle: true,
                    controller: sideMenu,
                    style: SideMenuStyle(
                        openSideMenuWidth: deviceWidth * 0.15,
                        toggleColor: Pallete.primaryColor,
                        showTooltip: true,
                        displayMode: SideMenuDisplayMode.compact,
                        hoverColor: Pallete.blackColor,
                        unselectedIconColor: Pallete.primaryColor,
                        unselectedTitleTextStyle:
                            const TextStyle(color: Pallete.primaryColor),
                        selectedHoverColor: Pallete.primaryColor,
                        selectedColor: Pallete.primaryColor,
                        selectedTitleTextStyle:
                            const TextStyle(color: Colors.black),
                        selectedIconColor: Colors.black,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(deviceHeight * 0.05),
                              bottomRight:
                                  Radius.circular(deviceHeight * 0.05)),
                        ),
                        backgroundColor: Pallete.secondaryColor),
                    title: Column(
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: deviceHeight * 0.25,
                            maxWidth: deviceWidth * 0.15,
                          ),
                          child: Image.asset(
                            AssetConstants.appLogoNoBg,
                            color: Pallete.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                        Divider(
                          thickness: deviceHeight * 0.003,
                          indent: 8.0,
                          endIndent: 8.0,
                          color: Pallete.blackColor,
                        ),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ],
                    ),
                    footer: SizedBox(
                      width: deviceWidth * 0.1,
                      height: deviceHeight * 0.07,
                      child: Column(
                        children: [
                          Expanded(
                            child: Text(
                              "Powered By",
                              style: GoogleFonts.dancingScript(
                                textStyle: TextStyle(
                                    color: Pallete.primaryColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: deviceWidth * 0.007),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "First logic meta lab",
                              style: GoogleFonts.barlowCondensed(
                                textStyle: TextStyle(
                                    color: Pallete.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth * 0.009),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    items: [
                      SideMenuItem(
                        title: 'Dashboard',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(CupertinoIcons.home),
                      ),
                      SideMenuItem(
                        builder: (context, displayMode) => SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ),
                      SideMenuItem(
                        title: 'Reports',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(Icons.edit_note_rounded),
                      ),
                      SideMenuItem(
                        builder: (context, displayMode) => SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ),
                      SideMenuItem(
                        title: 'Stock Report',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(Icons.analytics_outlined),
                      ),
                      SideMenuItem(
                        builder: (context, displayMode) => SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ),
                      SideMenuItem(
                        title: 'Profile',
                        onTap: (index, _) {
                          sideMenu.changePage(index);
                        },
                        icon: const Icon(CupertinoIcons.person),
                      ),
                      SideMenuItem(
                        builder: (context, displayMode) => SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ),
                      SideMenuItem(
                        builder: (context, displayMode) {
                          return Divider(
                            thickness: deviceHeight * 0.003,
                            indent: 8.0,
                            endIndent: 8.0,
                            color: Pallete.blackColor,
                          );
                        },
                      ),
                      SideMenuItem(
                        title: 'Log Out',
                        onTap: (index, _) {
                          showLogoutAlertDialog(context, () {
                            logOut(ref); // Call the logOut function
                            Routemaster.of(context).push('/welcome');
                          });
                        },
                        icon: const Icon(Icons.exit_to_app),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Pallete.secondaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(deviceHeight * 0.1),
                              bottomRight: Radius.circular(deviceHeight * 0.1),
                            ),
                          ),
                          height: deviceHeight * 0.16,
                          width: deviceWidth * 0.8,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.02),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: deviceWidth * 0.03),
                                          child: IconButton(
                                            onPressed: () =>
                                                Routemaster.of(context).pop(),
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Pallete.primaryColor,
                                              size: deviceHeight * 0.04,
                                            ),
                                          ),
                                        ),
                                        if (data.shopProfile.isEmpty)
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/defaultStoreImage-web.png'),
                                            radius: deviceHeight * 0.040,
                                            backgroundColor: Colors.white,
                                          )
                                        else
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                data.shopProfile ?? ''),
                                            radius: deviceHeight * 0.040,
                                          ),
                                        SizedBox(width: deviceWidth * 0.01),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Welcome to,",
                                              style: TextStyle(
                                                fontSize: deviceWidth * 0.012,
                                                color: Pallete.primaryColor,
                                              ),
                                            ),
                                            Text(
                                              data.name ?? '',
                                              style: TextStyle(
                                                fontSize: deviceWidth * 0.012,
                                                fontWeight: FontWeight.bold,
                                                color: Pallete.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: deviceWidth * 0.1),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.03),
                                    child: Row(
                                      children: [
                                        Container(
                                            width: deviceWidth * 0.3,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                                'Your Pack Date${data.createdTime}')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ///for showing marque text for expire date.....before 3 days
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.10,
                                    right: deviceHeight * 0.01),
                                child: SizedBox(
                                    height: deviceHeight * 0.05,
                                    width: deviceWidth * 0.6,
                                    child: calculateDiff(
                                        exp: data.expirationDate)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            children: [
                              Shop_Home_screen_web(
                                  shopeModel: data, shopId: widget.shopId),
                              Container(),
                              ShopReportScreenweb(shopId: widget.shopId),
                              Container(),
                              // Shop_Analysis_screen_web(),
                              Shop_StockScreenWeb(shopId: widget.shopId),
                              Container(),
                              Shop_Profile_Screen_Web(
                                  shopeModel: data, shopId: widget.shopId),
                              Container(),
                              Container(),
                              Container(
                                width: deviceWidth * 0.8,
                                height: deviceHeight * 0.07,
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  'NOW NOT AVAILABLE ,\n COMING SOON!',
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.05,
                                      color: Pallete.secondaryColor,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              Container(
                                width: deviceWidth * 0.8,
                                height: deviceHeight * 0.07,
                                color: Colors.white,
                                child: const Center(child: Text('LOG-OUT')),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // pages.elementAt(selectedIndex)
                ],
              ),
            );
          },
          error: (error, stackTrace) => Column(
            children: [
              Center(child: ErrorText(error: error.toString())),
            ],
          ),
          loading: () => const Loader(),
        );
  }
}
