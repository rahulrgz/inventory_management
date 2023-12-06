import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/purchase_model.dart';
import '../../../../models/shope_model.dart';

class PurchaseScreenTab extends StatefulWidget {
  final String encode;
  const PurchaseScreenTab({super.key, required this.encode});

  @override
  State<PurchaseScreenTab> createState() => _PurchaseScreenTabState();
}

class _PurchaseScreenTabState extends State<PurchaseScreenTab> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });

  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TextEditingController searchController = TextEditingController();

  ShopModel decode(String encode) {
    Map<String, dynamic> decode = jsonDecode(Uri.decodeComponent(encode));
    return ShopModel(
        uid: decode['uid'],
        category: decode['category'],
        name: decode['name'],
        shopId: decode['shopId'],
        subscriptionId: decode['subscriptionId'],
        createdTime: DateTime.parse(decode['createdTime']),
        shopProfile: decode['shopProfile'],
        deleted: decode['deleted'],
        setSearch: List<String>.from(decode['setSearch']),
        accepted: decode['accepted'],
        blocked: decode['blocked'],
        reason: decode['reason'],
        expirationDate: DateTime.now());
  }

  pushEncodeParty({required PurchaseModel purchase, required String sid}) {
    Map<String, dynamic> map = {
      'supplierId': purchase.supplierId,
      'id': purchase.id,
      'name': purchase.name,
      'products': purchase.products,
      'purchaseDate': purchase.purchaseDate.toIso8601String(),
      'totalPrice': purchase.totalPrice,
    };
    String encode = jsonEncode(map);
    Routemaster.of(context).push('details/${Uri.encodeComponent(encode)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode(widget.encode);
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: deviceHeight * 0.14,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop('/store/homescreen/:shop');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
            )),
        title: const Text(
          "Purchase",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Pallete.secondaryColor),
        ),
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: deviceWidth * 0.45,
              child: (selectedFromDate == null || selectedToDate == null)
                  ? Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'search': temp.toUpperCase().trim()
                        };
                        return ref
                            .watch(purchasesStreamProvider(jsonEncode(map)))
                            .when(
                          data: (data) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Pallete.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: Offset(1, 1),
                                  )
                                ],
                              ),
                              height: deviceHeight,
                              width: deviceWidth * 0.45,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    decelerationRate:
                                        ScrollDecelerationRate.fast),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var purchase = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                                offset: Offset(2, 2))
                                          ],
                                          color: Pallete.thirdColor,
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.02)),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                deviceHeight * 0.03)),
                                        title: Text(
                                          purchase.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: deviceHeight * 0.033,
                                              color: Pallete.secondaryColor),
                                        ),
                                        subtitle: Text(
                                          purchase.id,
                                          style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontSize: deviceHeight * 0.03),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '₹ ${purchase.totalPrice}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      deviceHeight * 0.033,
                                                  color:
                                                      Pallete.secondaryColor),
                                            ),
                                            Text(
                                                DateFormat('yMMMd').format(
                                                    purchase.purchaseDate),
                                                style: TextStyle(
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontSize:
                                                        deviceHeight * 0.024)),
                                          ],
                                        ),
                                        onTap: () {
                                          pushEncodeParty(
                                              purchase: purchase,
                                              sid: shop.shopId);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(error: error.toString());
                          },
                          loading: () {
                            return const Loader();
                          },
                        );
                      },
                    )
                  : Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'search': temp.toUpperCase().trim(),
                          'fDate': selectedFromDate!.toIso8601String(),
                          'tDate': selectedToDate!.toIso8601String()
                        };
                        return ref
                            .watch(
                                sortedPurchaseStreamProvider(jsonEncode(map)))
                            .when(
                          data: (data) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Pallete.primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: Offset(1, 1),
                                  )
                                ],
                              ),
                              height: deviceHeight,
                              width: deviceWidth * 0.45,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(
                                    decelerationRate:
                                        ScrollDecelerationRate.fast),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  var purchase = data[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 1,
                                                spreadRadius: 1,
                                                offset: Offset(2, 2))
                                          ],
                                          color: Pallete.thirdColor,
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.02)),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                deviceHeight * 0.03)),
                                        title: Text(
                                          purchase.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: deviceHeight * 0.033,
                                              color: Pallete.secondaryColor),
                                        ),
                                        subtitle: Text(
                                          purchase.id,
                                          style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontSize: deviceHeight * 0.03),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '₹ ${purchase.totalPrice}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      deviceHeight * 0.033,
                                                  color:
                                                      Pallete.secondaryColor),
                                            ),
                                            Text(
                                                DateFormat('yMMMd').format(
                                                    purchase.purchaseDate),
                                                style: TextStyle(
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontSize:
                                                        deviceHeight * 0.024)),
                                          ],
                                        ),
                                        onTap: () {
                                          pushEncodeParty(
                                              purchase: purchase,
                                              sid: shop.shopId);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          error: (error, stackTrace) {
                            return ErrorText(error: error.toString());
                          },
                          loading: () {
                            return const Loader();
                          },
                        );
                      },
                    )),
          SizedBox(
            width: deviceWidth * 0.055,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) => SizedBox(
                      height: deviceHeight * 0.1,
                      width: deviceWidth * 0.3,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: "Search Data",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    deviceHeight * 0.03))),
                        onChanged: (value) => ref
                            .read(searchProvider.notifier)
                            .update((state) => value),
                        controller: searchController,
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.04),
                  InkWell(
                    onTap: () async {
                      selectedFromDate = await pickDateFrom(context: context);
                      setState(() {});
                    },
                    child: Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.12,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(4, 4))
                          ],
                          color: Pallete.thirdColor,
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Date From :",
                            style: TextStyle(fontSize: deviceWidth * 0.015),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedFromDate == null
                                    ? 'Choose Date'
                                    : DateFormat.yMMMd()
                                        .format(selectedFromDate!),
                                style: TextStyle(fontSize: deviceWidth * 0.015),
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.keyboard_arrow_down))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  InkWell(
                    onTap: () async {
                      selectedToDate = await pickDateTo(
                        context: context,
                      );
                      setState(() {});
                    },
                    child: Container(
                      width: deviceWidth * 0.3,
                      height: deviceHeight * 0.12,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                spreadRadius: 1,
                                offset: Offset(4, 4))
                          ],
                          color: Pallete.thirdColor,
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Date To :",
                            style: TextStyle(fontSize: deviceWidth * 0.015),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.005,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedToDate == null
                                    ? 'Choose Date'
                                    : DateFormat.yMMMd()
                                        .format(selectedToDate!),
                                style: TextStyle(fontSize: deviceWidth * 0.015),
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.keyboard_arrow_down))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.2,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: deviceHeight * 0.035),
                child: ElevatedButton(
                  onPressed: () => Routemaster.of(context).push(
                      '/store/${shop.shopId}/Purchase/${widget.encode}/addPurchase'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.09),
                    backgroundColor: Pallete.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02),
                        side: const BorderSide(color: Pallete.secondaryColor)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_sharp,
                        color: Pallete.primaryColor,
                        size: deviceWidth * 0.0125,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.009,
                      ),
                      Text(
                        'Add Purchase',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.0125,
                            color: Pallete.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
