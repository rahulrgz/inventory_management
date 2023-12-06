import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/controller/addstore_controller.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/no_store_screen_mobile.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../models/shope_model.dart';

class StoreScreenWeb extends ConsumerWidget {
  final List<ShopModel> data;
  const StoreScreenWeb({super.key, required this.data});

  void deleteShop(
      {required ShopModel shop,
      required WidgetRef ref,
      required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you Sure?'),
          content: const Text(
            'Confirm to  delete ',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No',
                  style: TextStyle(color: Pallete.secondaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes',
                  style: TextStyle(color: Pallete.secondaryColor)),
              onPressed: () {
                shop = shop.copyWith(deleted: true);
                ref
                    .read(addStoreControllerProvider.notifier)
                    .deleteShop(context: context, shop: shop);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  planAlert({required BuildContext context, required ShopModel shop}) {
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
          height: deviceHeight * 0.15,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You have not subscribed to plans yet!',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                'Please purchase a valid plan ',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Routemaster.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.12, deviceHeight * 0.07),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.015,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/addStore/${shop.shopId}');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.12, deviceHeight * 0.07),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.015,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  blockAlert({required BuildContext context, required ShopModel shop}) {
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
                'You are blocked by the admin panel',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                'Reason: ${shop.reason.isEmpty ? 'Contact Helpdesk' : shop.reason}',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Routemaster.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.12, deviceHeight * 0.07),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Okay',
              style: TextStyle(
                  fontSize: deviceWidth * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  declineAlert({required BuildContext context, required ShopModel shop}) {
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
          height: deviceHeight * 0.127,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your shop has not yet been ',
                style: TextStyle(
                    fontSize: deviceHeight * 0.025,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                'approved by Admin',
                style: TextStyle(
                    fontSize: deviceHeight * 0.025,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              Text(
                shop.reason.isEmpty
                    ? '( Maybe Admin has not seen your request yet )'
                    : shop.reason,
                style: TextStyle(
                    fontSize: deviceHeight * 0.020,
                    color: Pallete.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: deviceHeight * 0.001),
            child: ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.10, deviceHeight * 0.07),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.primaryColor)),
              ),
              child: Text(
                'Ok',
                style: TextStyle(
                    fontSize: deviceWidth * 0.015,
                    fontWeight: FontWeight.bold,
                    color: Pallete.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PlanExp({required BuildContext context, required ShopModel shop}) {
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
          height: deviceHeight * 0.15,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'your plan expired',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                'Please purchase a valid plan ',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Routemaster.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.12, deviceHeight * 0.07),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.015,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/addStore/${shop.shopId}');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.12, deviceHeight * 0.07),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.015,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // deviceHeight = MediaQuery.of(context).size.height;
    // deviceWidth = MediaQuery.of(context).size.width;

    int a = data.length + 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Stores',
            style: TextStyle(
                color: Pallete.secondaryColor, fontSize: deviceWidth * 0.03)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight * 0.6,
              width: deviceWidth * 0.95,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 200,
                    maxCrossAxisExtent: 600,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: a,
                itemBuilder: (context1, index) {
                  ShopModel shop;
                  index == 0 ? shop = data[index] : shop = data[index - 1];
                  return index == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Routemaster.of(context)
                                  .push('/store/addStore'),
                              child: Container(
                                height: deviceHeight * 0.19,
                                width: deviceWidth * 0.25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Pallete.secondaryColor),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '+ ADD MORE',
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: deviceWidth * 0.01),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ShopModel shopeModel = data[index - 1];
                                shop.blocked
                                    ? blockAlert(context: context, shop: shop)
                                    : shop.accepted
                                        ? declineAlert(
                                            context: context, shop: shop)
                                        : shop.subscriptionId.isEmpty
                                            ? planAlert(
                                                context: context, shop: shop)
                                            : shop.expirationDate
                                                    .isBefore(DateTime.now())
                                                ? PlanExp(
                                                    context: context,
                                                    shop: shop)
                                                : Routemaster.of(context).push(
                                                    '/store/homescreen/${shopeModel.shopId}');
                              },
                              child: Container(
                                height: deviceHeight * 0.3,
                                width: deviceWidth * 0.25,
                                margin: EdgeInsets.all(deviceWidth * 0.015),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Pallete.secondaryColor),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Container(
                                        height: deviceHeight * 0.20,
                                        width: deviceWidth * 0.1,
                                        margin:
                                            EdgeInsets.all(deviceWidth * 0.015),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Pallete.secondaryColor),
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.015),
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.015),
                                            child: shop.shopProfile.isEmpty
                                                ? const Image(
                                                    image: AssetImage(
                                                        'assets/images/defaultStoreImage-web.png'))
                                                : Image.network(
                                                    shop.shopProfile,
                                                    fit: BoxFit.fill,
                                                  ))),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(shop.category,
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontSize: deviceWidth * 0.010)),
                                        Text(
                                          shop.name.length >= 12
                                              ? '${shop.name.substring(0, 12)}..'
                                              : shop.name,
                                          style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: deviceWidth * 0.016,
                                          ),
                                        ),
                                        SizedBox(
                                          height: deviceHeight * 0.01,
                                        ),
                                        Text(
                                            'Expire on ${DateFormat.yMMMd().format(shop.expirationDate)}',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontSize: deviceWidth * 0.010)),
                                        shop.subscriptionId.isEmpty
                                            ? Text(
                                                'purchase a valid plan',
                                                style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.red,
                                                    fontSize:
                                                        deviceWidth * 0.010),
                                              )
                                            : Text(shop.subscriptionId,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize:
                                                        deviceWidth * 0.010)),
                                        SizedBox(
                                          height: deviceHeight * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                'Valid till: ${DateFormat('dd/MM/yyyy').format(shop.expirationDate)}',
                                                style: TextStyle(
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        deviceWidth * 0.01)),
                                            SizedBox(
                                              width: deviceWidth * 0.004,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  deleteShop(
                                                      shop: shop,
                                                      ref: ref,
                                                      context: context);
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Pallete.secondaryColor,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
