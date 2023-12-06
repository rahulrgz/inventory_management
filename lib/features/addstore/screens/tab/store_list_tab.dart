import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/utils.dart';
import '../../controller/addstore_controller.dart';

class StoreListTab extends StatefulWidget {
  final List<ShopModel> data;
  const StoreListTab({super.key, required this.data});
  @override
  State<StoreListTab> createState() => _StoreListTabState();
}

class _StoreListTabState extends State<StoreListTab> {
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
          title: const Text('Are you sure want to delete ?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Pallete.primaryColor, fontSize: deviceWidth * 0.015),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                shop = shop.copyWith(deleted: true);
                ref
                    .read(addStoreControllerProvider.notifier)
                    .deleteShop(context: context, shop: shop);
                Navigator.of(context).pop();
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
                    color: Pallete.secondaryColor,
                    fontSize: deviceWidth * 0.015),
              ),
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
          height: deviceHeight * 0.12,
          width: deviceWidth * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You have not subscribed to plans yet!',
                style: TextStyle(
                    fontSize: deviceWidth * 0.015, color: Pallete.primaryColor),
              ),
              Text(
                'Please purchase a valid plan ',
                style: TextStyle(
                    fontSize: deviceWidth * 0.015, color: Pallete.primaryColor),
              ),
            ],
          ),
        ),
        actions: [
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
              'Later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.02,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                // ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/addStore/${shop.shopId}');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.015),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
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
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Text(
                'approved by Admin',
                style: TextStyle(
                    fontSize: deviceHeight * 0.036,
                    color: Pallete.primaryColor),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              Text(
                shop.reason.isEmpty
                    ? '( Maybe Admin has not seen your request yet )'
                    : shop.reason,
                style: TextStyle(
                    fontSize: deviceHeight * 0.027,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: deviceHeight * 0.05, right: deviceHeight * 0.05),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: deviceHeight * 0.035,
          mainAxisSpacing: deviceHeight * 0.035,
          childAspectRatio: 2.5,
        ),
        itemCount: widget.data.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.all(deviceHeight * 0.01),
              child: GestureDetector(
                onTap: () {
                  Routemaster.of(context).push('/store/addstore');
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(2, 2))
                    ],
                    color: Pallete.thirdColor,
                    borderRadius: BorderRadius.circular(deviceHeight * 0.05),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_business_sharp,
                        size: deviceHeight * 0.06,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.015,
                      ),
                      Text(
                        "Add New Shop",
                        style: TextStyle(
                          fontSize: deviceHeight * 0.024,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            ShopModel shops = widget.data[index - 1];
            return Padding(
              padding: EdgeInsets.all(deviceHeight * 0.01),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return GestureDetector(
                    onLongPress: () {
                      deleteShop(shop: shops, ref: ref, context: context);
                    },
                    onTap: () {
                      shops.deleted
                          ? showSnackBar(context, 'cant open the shop')
                          : shops.blocked
                              ? blockAlert(context: context, shop: shops)
                              : shops.accepted
                                  ? declineAlert(context: context, shop: shops)
                                  : shops.subscriptionId.isEmpty
                                      ? planAlert(context: context, shop: shops)
                                      : Routemaster.of(context)
                                          .replace('/store/${shops.shopId}');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                spreadRadius: 1,
                                offset: Offset(2, 2))
                          ],
                          color: Pallete.thirdColor,
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.05)),
                      child: Center(
                        child: SizedBox(
                          height: deviceHeight * 0.23,
                          width: deviceWidth * 0.39,
                          // color: Colors.red,
                          child: Row(
                            children: [
                              Container(
                                height: deviceHeight * 0.23,
                                width: deviceHeight * 0.23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.05),
                                  // border: Border.all(color: Pallete.secondaryColor),
                                  color: Pallete.secondaryColor,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        deviceWidth * 0.015),
                                    child: shops.shopProfile.isEmpty
                                        ? const Image(
                                            image: AssetImage(
                                                'assets/images/defaultStoreImage-web.png'))
                                        : Image.network(
                                            shops.shopProfile,
                                            fit: BoxFit.fill,
                                          )),
                              ),
                              SizedBox(
                                width: deviceHeight * 0.03,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    shops.name,
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.044),
                                  ),
                                  Text(
                                    'Created Date: ${DateFormat("dd MMM,y").format(shops.createdTime)}',
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.026),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.05,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Plan: ',
                                        style: TextStyle(
                                          fontSize: deviceHeight * 0.026,
                                        ),
                                      ),
                                      shops.subscriptionId.isEmpty
                                          ? Text(
                                              'Purchase a valid plan',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: deviceHeight * 0.026,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                          : Text(
                                              '${shops.subscriptionId} Subscription',
                                              style: TextStyle(
                                                  fontSize:
                                                      deviceHeight * 0.026,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.green.shade900),
                                            ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
