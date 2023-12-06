import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/sales/controller/sales_controller.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class SalesReturnMobile extends ConsumerStatefulWidget {
  final String name;
  final String encode;
  const SalesReturnMobile(
      {super.key, required this.encode, required this.name});
  @override
  ConsumerState<SalesReturnMobile> createState() => _SalesReturnMobileState();
}

class _SalesReturnMobileState extends ConsumerState<SalesReturnMobile> {
  final searchProvider = StateProvider<String>((ref) => '');
  TextEditingController searchController = TextEditingController();

  DateTime? _selectedfromDate;
  DateTime? _selectedtoDate;
  double totalsalesreturn = 0;

  calculateTotalReturnSale({required List<SaleReturnModel> saleReturn}) {
    double tot = 0;
    for (var i in saleReturn) {
      tot = tot + double.parse(i.total);
    }
    return tot;
  }

  decode() {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
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

  pushEncode({required String sid, required String uid}) {
    Map<String, dynamic> map = {'uid': uid, 'sid': sid};
    String ids = jsonEncode(map);
    Routemaster.of(context).push(
        "/store/homescreen/$sid/SalesReturn/${widget.encode}/${Uri.encodeComponent(ids)}");
  }

  pushEncodeParty({required SaleReturnModel sr}) {
    Map<String, dynamic> map = {
      'saleId': sr.saleId,
      'saleReturnId': sr.saleReturnId,
      'saleReturnDate': sr.saleReturnDate.toIso8601String(),
      'products': sr.products,
      'total': sr.total,
    };
    String enc = jsonEncode(map);
    Routemaster.of(context).push("srp/${Uri.encodeComponent(enc)}");
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode();
    Map<String, dynamic> map = {
      'uid': shop.uid,
      'sid': shop.shopId,
      'search': ''
    };
    int dataLength =
        ref.watch(salesReturnStreamProvider(jsonEncode(map))).value?.length ??
            0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.left_chevron),
          color: Pallete.secondaryColor,
        ),
        title: Text(
          'SALES RETURN',
          style: TextStyle(
            fontSize: deviceHeight * 0.022,
            color: Pallete.secondaryColor,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            width: deviceWidth,
            // height: deviceHeight * 0.1,
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
          SizedBox(
            height: deviceHeight * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: deviceWidth * 0.25,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Pallete.containerColor,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ],
                      color: Pallete.primaryColor,
                      borderRadius:
                          BorderRadius.circular(deviceHeight * 0.015)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No.of Txtns',
                          style: TextStyle(
                            fontSize: deviceHeight * 0.014,
                          )),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(
                        dataLength.toString(),
                        style: TextStyle(
                            fontSize: deviceHeight * 0.02,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                Consumer(builder: (context, ref, child) {
                  Map<String, dynamic> map = {
                    'sid': shop.shopId,
                    'uid': shop.uid,
                  };
                  return ref
                      .watch(totalSaleReturnProvider(jsonEncode(map)))
                      .when(
                        data: (data) {
                          return Container(
                            width: deviceWidth * 0.27,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Pallete.containerColor,
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                      offset: Offset(0, 1))
                                ],
                                color: Pallete.primaryColor,
                                borderRadius: BorderRadius.circular(
                                    deviceHeight * 0.015)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Total Returns',
                                    style: TextStyle(
                                      fontSize: deviceHeight * 0.014,
                                    )),
                                SizedBox(
                                  height: deviceHeight * 0.005,
                                ),
                                Text(
                                  calculateTotalReturnSale(saleReturn: data)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: deviceHeight * 0.02,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                }),
                // Container(
                //   width: deviceWidth * 0.27,
                //   decoration: BoxDecoration(
                //       boxShadow: const [
                //         BoxShadow(
                //             color: Pallete.containerColor,
                //             blurRadius: 2,
                //             spreadRadius: 1,
                //             offset: Offset(0, 1))
                //       ],
                //       color: Pallete.primaryColor,
                //       borderRadius:
                //           BorderRadius.circular(deviceHeight * 0.015)),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('Balance Due',
                //           style: TextStyle(
                //             fontSize: deviceHeight * 0.014,
                //           )),
                //       SizedBox(
                //         height: deviceHeight * 0.005,
                //       ),
                //       Text(
                //         '2300.00',
                //         style: TextStyle(
                //             fontSize: deviceHeight * 0.02,
                //             fontWeight: FontWeight.bold),
                //       )
                //     ],
                //   ),
                // ),
              ],
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
                    labelText: 'Search Your SL ID',
                    labelStyle: TextStyle(
                      fontSize: deviceHeight * 0.02,
                      color: Pallete.secondaryColor,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          ref
                              .watch(searchProvider.notifier)
                              .update((state) => '');
                          searchController.clear();
                        },
                        icon: Icon(
                          CupertinoIcons.clear,
                          color: Pallete.secondaryColor,
                        )),
                  ),
                  controller: searchController,
                  onChanged: (value) => ref
                      .read(searchProvider.notifier)
                      .update((state) => value),
                ));
          }),
          Expanded(
              child: (_selectedfromDate == null || _selectedtoDate == null)
                  ? Consumer(
                      builder: (context, ref, child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'search': temp.toUpperCase().trim()
                        };
                        return ref
                            .watch(salesReturnStreamProvider(jsonEncode(map)))
                            .when(
                              data: (data) {
                                return data.isEmpty
                                    ? const Center(
                                        child: Text('no salesReturn yet!!!'),
                                      )
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          SaleReturnModel salesReturn =
                                              data[index];
                                          totalsalesreturn = (totalsalesreturn +
                                              double.parse(salesReturn.total));
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.05,
                                                right: deviceWidth * 0.05,
                                                top: deviceHeight * 0.03),
                                            child: GestureDetector(
                                              onTap: () {
                                                pushEncodeParty(
                                                    sr: salesReturn);
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
                                                      color:
                                                          Pallete.thirdColor),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      deviceWidth * 0.025),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            salesReturn.saleId,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                              DateFormat(
                                                                      'dd/mm/yyyy    hh:mm:ss a')
                                                                  .format(
                                                                      salesReturn
                                                                          .saleReturnDate),
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
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '₹ ${salesReturn.total}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                            'You\'ll Get',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize:
                                                                    deviceHeight *
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
                              loading: () => const Loader(),
                            );
                      },
                    )
                  : Consumer(
                      builder: (context, ref, child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'fDate': _selectedfromDate!.toIso8601String(),
                          'tDate': _selectedtoDate!.toIso8601String(),
                          'search': temp.toUpperCase().trim()
                        };
                        print(_selectedfromDate);
                        print(_selectedtoDate);
                        return ref
                            .watch(sortedSalesReturnStreamProvider(
                                jsonEncode(map)))
                            .when(
                              data: (data) {
                                return data.isEmpty
                                    ? const Center(
                                        child: Text('no salesReturn yet!!!'),
                                      )
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          SaleReturnModel salesReturn =
                                              data[index];
                                          totalsalesreturn = (totalsalesreturn +
                                              double.parse(salesReturn.total));
                                          return InkWell(
                                            onTap: () {
                                              pushEncodeParty(sr: salesReturn);
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
                                                      color:
                                                          Pallete.thirdColor),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      deviceWidth * 0.025),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            salesReturn.saleId,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                              DateFormat(
                                                                      'dd/mm/yyyy    hh:mm:ss a')
                                                                  .format(
                                                                      salesReturn
                                                                          .saleReturnDate),
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
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            '₹ ${salesReturn.total}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                            'You\'ll Get',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize:
                                                                    deviceHeight *
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
                              loading: () => const Loader(),
                            );
                      },
                    )),
          SizedBox(
            height: deviceHeight * 0.08,
            child: Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.01,
                  right: deviceWidth * 0.01,
                  bottom: deviceWidth * 0.04),
              child: ElevatedButton(
                onPressed: () {
                  pushEncode(sid: shop.shopId, uid: shop.uid);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceWidth * 0.85, deviceHeight * 0.01),
                  backgroundColor: Pallete.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                      side: const BorderSide(color: Pallete.secondaryColor)),
                ),
                child: Text(
                  'ADD SALES RETURN',
                  style: TextStyle(
                      fontSize: deviceWidth * 0.04,
                      color: Pallete.primaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
