import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../../core/utils.dart';
import '../../../../../models/shope_model.dart';
import '../../../controller/addStore_controller.dart';

class SingleStoreTile extends ConsumerWidget {
  final ShopModel shop;

  const SingleStoreTile({super.key, required this.shop});

  deleteShop(
      {required WidgetRef ref,
      required BuildContext context,
      required ShopModel shop}) {
    shop = shop.copyWith(deleted: true);
    ref
        .read(addStoreControllerProvider.notifier)
        .deleteShop(context: context, shop: shop);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(shopProvider.notifier).update((state) => shop);
        shop.deleted
            ? showSnackBar(context, 'cant open deleted Store')
            : shop.blocked
                ? blockAlert(context: context)
                : shop.accepted
                    ? declineAlert(context: context)
                    : shop.subscriptionId.isEmpty
                        ? planAlert(context: context)
                        : Routemaster.of(context)
                            .replace('/store/homescreen/${shop.shopId}');
      },
      onLongPress: () {
        deleteConfirmBoxMobile(context: context, ref: ref, shop: shop);
      },
      child: Container(
        height: deviceHeight * .15,
        width: deviceWidth,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                spreadRadius: 1,
                offset: Offset(0, 2))
          ],
          color: Pallete.thirdColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: EdgeInsets.all(deviceHeight * 0.02),
          child: Row(
            children: [
              Container(
                width: deviceWidth * .25,
                height: deviceHeight * .13,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(2, 2))
                  ],
                  color: Pallete.containerColor,
                  borderRadius: BorderRadius.circular(deviceHeight * 0.03),
                  image: shop.shopProfile.isEmpty
                      ? const DecorationImage(
                          image: AssetImage(AssetConstants.noShop),
                          fit: BoxFit.contain)
                      : DecorationImage(
                          image: NetworkImage(shop.shopProfile),
                          fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: deviceWidth * .05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: deviceWidth * 0.5,
                    child: Text(
                      shop.name,
                      style: TextStyle(
                          overflow: TextOverflow.fade,
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceHeight * 0.025),
                    ),
                  ),
                  Text(
                    shop.category,
                    style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceHeight * 0.012,
                    ),
                  ),
                  Text(
                    "Expire on ${shop.expirationDate}",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: Pallete.secondaryColor,
                      fontSize: deviceHeight * 0.013,
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.002,
                  ),
                  Row(
                    children: [
                      Text(
                        'Plan: ',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                          color: Pallete.secondaryColor,
                          fontSize: deviceHeight * 0.017,
                        ),
                      ),
                      shop.subscriptionId.isEmpty
                          ? Text(
                              'Purchase a valid plan',
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.red,
                                fontSize: deviceHeight * 0.017,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              '${shop.subscriptionId} Subscription',
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: deviceHeight * 0.017,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade900),
                            ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteConfirmBoxMobile(
      {required BuildContext context,
      required WidgetRef ref,
      required ShopModel shop}) {
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
        content: const Text('Are you sure you want to delete?'),
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
              deleteShop(context: context, ref: ref, shop: shop);
              Routemaster.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
              backgroundColor: Pallete.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.secondaryColor)),
            ),
            child: Text(
              'Delete',
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

  planAlert({required BuildContext context}) {
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
          borderRadius: BorderRadius.circular(deviceWidth * 0.08),
        ),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You didn't Subscribed plans yet!",
              style: TextStyle(fontSize: deviceWidth * 0.05),
            ),
          ],
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
              'later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/${shop.shopId}');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  blockAlert({required BuildContext context}) {
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
              Text('Your shop has been blocked by admin panel '),
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
              'later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/plansubscription');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }

  declineAlert({required BuildContext context}) {
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
              Text('You shop declined by admin '),
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
              'later',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(shopProvider.notifier).update((state) => shop);
                Routemaster.of(context).pop();
                Routemaster.of(context).push('/store/plansubscription');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            );
          }),
        ],
      ),
    );
  }
}
