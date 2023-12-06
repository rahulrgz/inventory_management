import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../models/sales_model.dart';
import '../../controller/home_controller.dart';

class ShopHomeMobile extends StatefulWidget {
  final ShopModel shop;

  const ShopHomeMobile({super.key, required this.shop});

  @override
  State<ShopHomeMobile> createState() => _ShopHomeMobileState();
}

class _ShopHomeMobileState extends State<ShopHomeMobile> {
  calculateTotal({required List<SalesModel> sale}) {
    double a = 0;
    for (var i in sale) {
      a = a + double.parse(i.totalPrice);
    }
    return a;
  }

  calculatePurchaseTotal({required List<PurchaseModel> purchase}) {
    double b = 0;
    for (var i in purchase) {
      b = b + double.parse(i.totalPrice);
    }
    return b;
  }

  encodeAndNavigate(
      {required ShopModel shop,
      required String pageCategory,
      required BuildContext context}) {
    ShopModel shop = widget.shop;
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
    String encode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/${shop.shopId}/$pageCategory/${Uri.encodeComponent(encode)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = widget.shop;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.07,
                  ),
                  Padding(
                    padding: EdgeInsets.all(deviceHeight * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.015,
                            ),
                            Padding(
                              padding: EdgeInsets.all(deviceHeight * 0.015),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: deviceWidth * 0.7,
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Welcome ',
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.025,
                                            color: Pallete.secondaryColor),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: shop.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Pallete.secondaryColor,
                                                fontSize: deviceHeight * 0.025),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.005,
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.66,
                                    child: Text(
                                        'Your ${shop.subscriptionId} plan activated  on ${DateFormat('d MMM, y').format(shop.createdTime)}',
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.014,
                                            color: Pallete.secondaryColor)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: deviceHeight * 0.026,
                              backgroundColor: Pallete.secondaryColor,
                              child: shop.shopProfile.isEmpty
                                  ? InkWell(
                                      onTap: () {
                                        Routemaster.of(context).push(
                                            '/store/homescreen/${shop.shopId}/editShop');
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Pallete.primaryColor,
                                        backgroundImage: AssetImage(
                                          AssetConstants.noShop,
                                        ),
                                        radius: deviceHeight * 0.025,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Routemaster.of(context).push(
                                            '/store/homescreen/${shop.shopId}/editShop');
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(shop.shopProfile),
                                        radius: deviceHeight * 0.025,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.04,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.02,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: deviceHeight * 0.03, bottom: deviceHeight * 0.03),
              child: SizedBox(
                width: deviceWidth,
                child: CarouselSlider(
                  items: [
                    Consumer(
                      builder: (child, ref, context) {
                        Map<String, dynamic> map = {
                          'sid': shop.shopId,
                          'uid': shop.uid,
                          'tody': DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day,
                                  0,
                                  0,
                                  0)
                              .toIso8601String()
                        };
                        return ref
                            .watch(getTotalSalePerDayStreamProvider(
                                jsonEncode(map)))
                            .when(
                                data: (data) {
                                  return Container(
                                    width: deviceWidth * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Pallete.secondaryColor),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: deviceHeight * 0.03),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: Pallete.primaryColor,
                                                size: deviceWidth * 0.03,
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.01,
                                              ),
                                              Text(
                                                DateFormat.yMMMd()
                                                    .format(DateTime.now()),
                                                style: TextStyle(
                                                    color: Pallete.primaryColor,
                                                    fontSize:
                                                        deviceWidth * 0.033),
                                              ),
                                              SizedBox(
                                                width: deviceWidth * 0.03,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: deviceWidth * 0.04,
                                            ),
                                            Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Colors.white24,
                                              size: deviceWidth * 0.21,
                                            ),
                                            SizedBox(
                                              width: deviceWidth * 0.02,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: deviceHeight * 0.03,
                                                ),
                                                Text(
                                                  'Today Sales',
                                                  style: TextStyle(
                                                      color:
                                                          Pallete.primaryColor,
                                                      fontSize:
                                                          deviceWidth * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '₹ ${calculateTotal(sale: data)}/-',
                                                  style: TextStyle(
                                                      color:
                                                          Pallete.primaryColor,
                                                      fontSize:
                                                          deviceWidth * 0.035),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => Loader());
                      },
                    ),
                    Consumer(builder: (context, ref, child) {
                      Map<String, dynamic> map = {
                        'sid': shop.shopId,
                        'uid': shop.uid,
                        'tdy': DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                0,
                                0,
                                0)
                            .toIso8601String()
                      };
                      return ref
                          .watch(
                              getTotalPurchasePerDayProvider(jsonEncode(map)))
                          .when(
                            data: (data) {
                              return Container(
                                width: deviceWidth * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Pallete.secondaryColor),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: deviceHeight * 0.03),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Pallete.primaryColor,
                                            size: deviceWidth * 0.03,
                                          ),
                                          SizedBox(
                                            width: deviceWidth * 0.01,
                                          ),
                                          Text(
                                            DateFormat.yMMMd()
                                                .format(DateTime.now()),
                                            style: TextStyle(
                                                color: Pallete.primaryColor,
                                                fontSize: deviceWidth * 0.033),
                                          ),
                                          SizedBox(
                                            width: deviceWidth * 0.03,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: deviceWidth * 0.04,
                                        ),
                                        Icon(
                                          Icons.stacked_bar_chart_outlined,
                                          color: Colors.white24,
                                          size: deviceWidth * 0.21,
                                        ),
                                        SizedBox(
                                          width: deviceWidth * 0.02,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: deviceHeight * 0.03,
                                            ),
                                            Text(
                                              'Today Purchase',
                                              style: TextStyle(
                                                  color: Pallete.primaryColor,
                                                  fontSize: deviceWidth * 0.05,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              ' ₹${calculatePurchaseTotal(purchase: data)}-',
                                              style: TextStyle(
                                                  color: Pallete.primaryColor,
                                                  fontSize:
                                                      deviceWidth * 0.035),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            error: (error, stackTrace) {
                              return ErrorText(error: error.toString());
                            },
                            loading: () => Loader(),
                          );
                    }),
                  ],
                  options: CarouselOptions(
                    enableInfiniteScroll: true,
                    initialPage: 0,
                    scrollDirection: Axis.horizontal,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlay: true,
                    aspectRatio: 2.4,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context, shop: shop, pageCategory: 'Sales');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.038,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'Sales',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access sales section,\n and you can view or update \n sales reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.025,
                                color: Pallete.secondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context, shop: shop, pageCategory: 'Purchase');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.shopping_basket,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.038,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'Purchase',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access purchase section,\n and you can view or update \n purchase reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.025,
                                color: Pallete.secondaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context,
                        shop: shop,
                        pageCategory: 'SalesReturn');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.shopping_cart_checkout_sharp,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.038,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'SalesReturn',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access sales return section,\n and you can view or update \n sales return reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.025,
                                color: Pallete.secondaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context,
                        shop: shop,
                        pageCategory: 'PurchaseReturn');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.shopping_basket_outlined,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.035,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'PurchaseReturn',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access p return section,\n and you can view or update \n purchase return reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.024,
                                color: Pallete.secondaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context, shop: shop, pageCategory: 'Customer');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.people_outline,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.035,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'Customer',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access customer section,\n and you can view or update \n customer reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.025,
                                color: Pallete.secondaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    encodeAndNavigate(
                        context: context, shop: shop, pageCategory: 'Supplier');
                  },
                  child: Container(
                    width: deviceWidth * 0.42,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: Pallete.thirdColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: deviceWidth * 0.04,
                        top: deviceWidth * 0.017,
                        right: deviceWidth * 0.03,
                        bottom: deviceHeight * 0.036,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                          Icon(
                            Icons.nature_people_outlined,
                            color: Pallete.secondaryColor,
                            size: deviceHeight * 0.035,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.01,
                          ),
                          Text(
                            'Supplier',
                            style: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.002,
                          ),
                          Text(
                            'To access supplier section,\n and you can view or update \n supplier reports',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.025,
                                color: Pallete.secondaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: deviceHeight * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

//tosearch
setSearchParam(String caseNumber) {
  List<String> caseSearchList = <String>[];
  String temp = "";

  List<String> nameSplits = caseNumber.split(" ");
  for (int i = 0; i < nameSplits.length; i++) {
    String name = "";

    for (int k = i; k < nameSplits.length; k++) {
      name = name + nameSplits[k] + " ";
    }
    temp = "";

    for (int j = 0; j < name.length; j++) {
      temp = temp + name[j];
      caseSearchList.add(temp.toUpperCase());
    }
  }
  return caseSearchList;
}
