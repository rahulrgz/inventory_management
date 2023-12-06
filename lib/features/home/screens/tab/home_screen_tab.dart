import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreenTab extends StatefulWidget {
  final ShopModel shop;
  const HomeScreenTab({super.key, required this.shop});
  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
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

  String selectedOption = 'Nahla Medicals';
  List gridView = [
    {
      'icons': Icons.shopping_cart_outlined,
      'category': 'Sales',
    },
    {
      'icons': Icons.remove_shopping_cart_outlined,
      'category': 'Sales_Return',
    },
    {
      'icons': Icons.shopping_bag,
      'category': 'Purchase',
    },
    {
      'icons': Icons.leave_bags_at_home_sharp,
      'category': 'Purchase_Return',
    },
    {
      'icons': Icons.nature_people_outlined,
      'category': 'Suppliers',
    },
    {
      'icons': Icons.people_alt_outlined,
      'category': 'Customers',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    ShopModel shop = widget.shop;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.secondaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                popUpMessage(context);
              },
              icon: Icon(
                Icons.info_outline,
                size: deviceHeight * 0.04,
                color: Pallete.containerColor,
              ))
        ],
      ),
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: gridView.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                encodeAndNavigate(
                    context: context,
                    shop: shop,
                    pageCategory: gridView[index]['category']);
              },
              child: Container(
                width: deviceWidth * 0.01,
                margin: EdgeInsets.all(deviceHeight * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.05),
                  color: Pallete.secondaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: deviceWidth * 0.02,
                        ),
                        Icon(
                          gridView[index]['icons'],
                          size: deviceWidth * 0.03,
                          color: Pallete.primaryColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.02,
                          ),
                          Text(
                            gridView[index]['category'],
                            style: TextStyle(
                              color: Pallete.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: deviceWidth * 0.025,
                              overflow: TextOverflow.fade,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.02,
                          ),
                          Text(
                            'To access ${gridView[index]['category']} section,\n and you can view or update\n ${gridView[index]['category']} reports.',
                            style: TextStyle(
                              color: Pallete.primaryColor,
                              fontWeight: FontWeight.w200,
                              fontSize: deviceWidth * 0.01,
                              overflow: TextOverflow.ellipsis,
                            ),
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        ),
      ),
    ));
  }
}
