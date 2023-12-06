import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

class PurchaseReturnScreenMobile extends StatefulWidget {
  final String encode;
  const PurchaseReturnScreenMobile({super.key, required this.encode});

  @override
  State<PurchaseReturnScreenMobile> createState() =>
      _PurchaseReturnScreenMobileState();
}

class _PurchaseReturnScreenMobileState
    extends State<PurchaseReturnScreenMobile> {
  final searchProvider = StateProvider<String>((ref) => '');
  DateTime? _selectedfromDate;
  DateTime? _selectedtoDate;
  TextEditingController searchController = TextEditingController();

  ///Date picker from
  void _pickDateDialogfrom() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedfromDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
      });
    });
  }

  ///date picker to
  void _pickDateDialogto() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedtoDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
      });
    });
  }

  decode(String encode) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(encode));
    ShopModel shop = ShopModel(
        uid: map['uid'],
        category: map['category'],
        name: map['name'],
        shopId: map['shopId'],
        subscriptionId: map['subscriptionId'],
        createdTime: DateTime.parse(map['createdTime']),
        shopProfile: map['shopProfile'],
        deleted: map['deleted'],
        setSearch: List<String>.from(map['setSearch']),
        accepted: map['accepted'],
        blocked: map['blocked'],
        reason: map['reason'],
        expirationDate: DateTime.now());
    return shop;
  }

  pushEncodeParty({required PurchaseReturnModel pr}) {
    Map<String, dynamic> map = {
      'purchaseId': pr.purchaseId,
      'purchaseReturnId': pr.purchaseReturnId,
      'purchaseReturnDate': pr.purchaseReturnDate.toIso8601String(),
      'products': pr.products,
      'total': pr.total,
      'search': ''
    };
    String enc = jsonEncode(map);
    Routemaster.of(context).push("prp/${Uri.encodeComponent(enc)}");
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode(widget.encode);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: Icon(CupertinoIcons.left_chevron),
          color: Pallete.secondaryColor,
        ),
        title: Text(
          'PURCHASE RETURN',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceHeight * 0.022),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: deviceWidth,
            child: Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.025),
                    child: GestureDetector(
                      onTap: () {
                        _pickDateDialogfrom();
                      },
                      child: Container(
                        width: deviceWidth * 0.35,
                        // height: deviceHeight * 0.06,
                        color: Pallete.primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date From :",
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.032)),
                            SizedBox(
                              height: deviceHeight * 0.007,
                            ),
                            Text(
                              _selectedfromDate == null
                                  ? 'Choose Date'
                                  : DateFormat.yMMMd()
                                      .format(_selectedfromDate!),
                              style: TextStyle(fontSize: deviceWidth * 0.036),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.025),
                    child: GestureDetector(
                      onTap: () {
                        _pickDateDialogto();
                      },
                      child: Container(
                        width: deviceWidth * 0.35,
                        // height: deviceHeight * 0.06,
                        color: Pallete.primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date to :",
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.032)),
                            SizedBox(
                              height: deviceHeight * 0.007,
                            ),
                            Text(
                                _selectedtoDate == null
                                    ? 'Choose Date'
                                    : DateFormat.yMMMd()
                                        .format(_selectedtoDate!),
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.036)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          Consumer(builder: (context, ref, child) {
            return SizedBox(
                height: deviceHeight * 0.06,
                width: deviceWidth * 0.8,
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      labelText: 'Search Your PS ID',
                      labelStyle: TextStyle(
                        fontSize: deviceHeight * 0.02,
                        color: Pallete.secondaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Pallete.secondaryColor,
                        ),
                        onPressed: () {
                          ref
                              .watch(searchProvider.notifier)
                              .update((state) => '');
                          searchController.clear();
                        },
                      )),
                  controller: searchController,
                  onChanged: (value) => ref
                      .read(searchProvider.notifier)
                      .update((state) => value),
                ));
          }),
          Expanded(
            child: (_selectedfromDate == null || _selectedtoDate == null)
                ? Consumer(builder: (context, ref, child) {
                    String temp = ref.watch(searchProvider);
                    Map<String, dynamic> map = {
                      'uid': shop.uid,
                      'sid': shop.shopId,
                      'search': temp.toUpperCase().trim()
                    };
                    return ref
                        .watch(purchaseReturnStreamProvider(jsonEncode(map)))
                        .when(
                          data: (data) {
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PurchaseReturnModel purchaseReturn =
                                      data[index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: deviceWidth * 0.05,
                                        right: deviceWidth * 0.05,
                                        top: deviceHeight * 0.03),
                                    child: GestureDetector(
                                      onTap: () {
                                        pushEncodeParty(pr: purchaseReturn);
                                      },
                                      child: Container(
                                        height: deviceHeight * 0.1,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Pallete.thirdColor,
                                              offset: Offset(
                                                5.0,
                                                5.0,
                                              ),
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            ), //BoxShadow
                                            BoxShadow(
                                              color: Pallete.thirdColor,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                          ],
                                          color: Pallete.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Pallete.thirdColor),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              deviceWidth * 0.025),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${purchaseReturn.purchaseId}:${shop.name}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceHeight * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  Text(
                                                      DateFormat(
                                                              'dd/mm/yyyy    hh:mm:ss a')
                                                          .format(purchaseReturn
                                                              .purchaseReturnDate),
                                                      style: TextStyle(
                                                          color: Pallete
                                                              .secondaryColor,
                                                          fontSize:
                                                              deviceHeight *
                                                                  0.012)),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '₹ ${purchaseReturn.total}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceHeight * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  Text(
                                                    'You\'ll Get',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: deviceHeight *
                                                            0.012),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => Loader(),
                        );
                  })
                : Consumer(builder: (context, ref, child) {
                    String temp = ref.watch(searchProvider);
                    Map<String, dynamic> map = {
                      'uid': shop.uid,
                      'sid': shop.shopId,
                      'fDate': _selectedfromDate!.toIso8601String(),
                      'tDate': _selectedtoDate!.toIso8601String(),
                      'search': temp.toUpperCase().trim()
                    };
                    return ref
                        .watch(
                            sortedPurchaseReturnStreamProvider(jsonEncode(map)))
                        .when(
                          data: (data) {
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PurchaseReturnModel purchaseReturn =
                                      data[index];
                                  return InkWell(
                                    onTap: () {
                                      pushEncodeParty(pr: purchaseReturn);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: deviceWidth * 0.05,
                                          right: deviceWidth * 0.05,
                                          top: deviceHeight * 0.03),
                                      child: Container(
                                        height: deviceHeight * 0.1,
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Pallete.thirdColor,
                                              offset: Offset(
                                                5.0,
                                                5.0,
                                              ),
                                              blurRadius: 10.0,
                                              spreadRadius: 2.0,
                                            ), //BoxShadow
                                            BoxShadow(
                                              color: Pallete.thirdColor,
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 0.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                          ],
                                          color: Pallete.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Pallete.thirdColor),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              deviceWidth * 0.025),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${purchaseReturn.purchaseId}:${shop.name}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceHeight * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  Text(
                                                      DateFormat(
                                                              'dd/mm/yyyy    hh:mm:ss a')
                                                          .format(purchaseReturn
                                                              .purchaseReturnDate),
                                                      style: TextStyle(
                                                          color: Pallete
                                                              .secondaryColor,
                                                          fontSize:
                                                              deviceHeight *
                                                                  0.012)),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '₹ ${purchaseReturn.total}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceHeight * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  Text(
                                                    'You\'ll Get',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: deviceHeight *
                                                            0.012),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          error: (error, stackTrace) {
                            return ErrorText(error: error.toString());
                          },
                          loading: () => Loader(),
                        );
                  }),
          ),
          Consumer(
            builder: (context, ref, child) {
              // var shop = ref.watch(shopProvider);
              Map<String, dynamic> map = {'uid': shop.uid, 'sid': shop.shopId};
              String enc = jsonEncode(map);
              return SizedBox(
                height: deviceHeight * 0.08,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.01,
                      right: deviceWidth * 0.01,
                      bottom: deviceWidth * 0.04),
                  child: ElevatedButton(
                    onPressed: () {
                      Routemaster.of(context)
                          .push('${Uri.encodeComponent(enc)}');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(deviceWidth * 0.85, deviceHeight * 0.01),
                      backgroundColor: Pallete.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          side:
                              const BorderSide(color: Pallete.secondaryColor)),
                    ),
                    child: Text(
                      'ADD PURCHASE RETURN',
                      style: TextStyle(
                          fontSize: deviceWidth * 0.04,
                          color: Pallete.primaryColor),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
