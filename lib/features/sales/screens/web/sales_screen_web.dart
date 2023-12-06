import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/features/addstore/controller/addstore_controller.dart';
import 'package:inventory_management_shop/features/stocks/controller/stock_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/sales_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/sales_controller.dart';

class SalesScreenWeb extends ConsumerStatefulWidget {
  final String shopId;
  const SalesScreenWeb({Key? key, required this.shopId}) : super(key: key);

  @override
  ConsumerState<SalesScreenWeb> createState() => _SalesScreenWebState();
}

class _SalesScreenWebState extends ConsumerState<SalesScreenWeb> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  final searchProvider = StateProvider<String>((ref) => '');
  TextEditingController searchController = TextEditingController();

  showNoStockAlertBox(BuildContext contex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Pallete.secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Text(
            'No stock available! \n add stock / purchase it',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'ok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Date picker=> from
  void _pickDateDialogFrom() {
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
        _selectedFromDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
      });
    });
  }

  ///date picker=> to
  void _pickDateDialogTo() {
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
        _selectedToDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
      });
    });
  }

  pushEncode({required SalesModel sales, required String sid}) {
    // Map<String, dynamic> map = {
    //   'id': sales.id,
    //   'name': sales.name,
    //   'saleDate': sales.saleDate.toIso8601String(),
    //   'products': sales.products,
    //   'customerId': sales.customerId,
    //   'totalPrice': sales.totalPrice,
    // };
    ref.read(sigleSaleProvider.notifier).update((state) => sales);
    // String encode1 = jsonEncode(map);
    Routemaster.of(context)
        .push('/store/homescreen/${widget.shopId}/sales/salesSingle');
  }

  pushEncodeAddSale(
      {required String uid,
      required String sid,
      required BuildContext context}) {
    Map<String, dynamic> map = {'sid': sid, 'uid': uid};

    String idEncode = jsonEncode(map);

    Routemaster.of(context).push(
        '/store/homescreen/${widget.shopId}/sales/adds/${Uri.encodeComponent(idEncode)}');
  }

  @override
  Widget build(BuildContext context) {
    var uid = ref.watch(userProvider)!.uid;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Consumer(builder: (context, ref, child) {
          return SingleChildScrollView(
            child: ref.watch(getUserShopWebProvider(widget.shopId)).when(
                  data: (datashop) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: deviceHeight * 0.03),
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => Routemaster.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(deviceHeight * 0.02),
                                  bottomRight:
                                      Radius.circular(deviceHeight * 0.02),
                                )),
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.arrow_back_rounded,
                                color: Pallete.primaryColor,
                                size: deviceHeight * 0.03,
                              )),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.4,
                            ),
                            Text(
                              "Sales",
                              style: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontSize: deviceWidth * .02,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: deviceWidth * 0.1,
                            ),
                            Container(
                              width: deviceWidth * 0.3,
                              decoration: BoxDecoration(
                                color: Pallete.secondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                autofocus: false,
                                controller: searchController,
                                onChanged: (value) => ref
                                    .read(searchProvider.notifier)
                                    .update((state) => value),
                                cursorColor: Pallete.primaryColor,
                                style: const TextStyle(
                                    color: Pallete.primaryColor),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  contentPadding:
                                      EdgeInsets.all(deviceWidth * 0.0075),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        ref
                                            .watch(searchProvider.notifier)
                                            .update((state) => '');
                                        searchController.clear();
                                      },
                                      icon: Icon(
                                        CupertinoIcons.clear,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.055,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Date From\n${_selectedFromDate == null ? 'Choose Date' : DateFormat.yMMMd().format(_selectedFromDate!)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Pallete.secondaryColor,
                                    fontSize: deviceWidth * 0.011,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _pickDateDialogFrom();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Pallete.secondaryColor,
                                    ))
                              ],
                            ),
                            VerticalDivider(
                              width: deviceWidth * 0.05,
                              color: Pallete.secondaryColor,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Date To\n${_selectedToDate == null ? 'Choose Date' : DateFormat.yMMMd().format(_selectedToDate!)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Pallete.secondaryColor,
                                    fontSize: deviceWidth * 0.011,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _pickDateDialogTo();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Pallete.secondaryColor,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.055,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   height: deviceHeight * 0.075,
                              //   width: deviceWidth * 0.45,
                              //   child: TabBar(
                              //     indicator: UnderlineTabIndicator(
                              //       borderSide: BorderSide(
                              //           width: deviceWidth * 0.0025,
                              //           color: Pallete.secondaryColor),
                              //       borderRadius: BorderRadius.circular(
                              //           deviceWidth * 0.015),
                              //       insets: EdgeInsets.symmetric(
                              //           horizontal: deviceWidth * 0.009,
                              //           vertical: deviceWidth * 0.0045),
                              //     ),
                              //     indicatorSize: TabBarIndicatorSize.label,
                              //     indicatorColor: Pallete.secondaryColor,
                              //     labelColor: Pallete.secondaryColor,
                              //     labelStyle: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: deviceWidth * 0.0125),
                              //     tabs: const [
                              //       Tab(
                              //         text: 'All',
                              //       ),
                              //       Tab(
                              //         text: 'Customers',
                              //       ),
                              //       Tab(
                              //         text: 'Suppliers',
                              //       ),
                              //       Tab(
                              //         text: 'Transactions',
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: deviceHeight * 0.7,
                                width: deviceWidth * 0.45,
                                child:
                                    (_selectedFromDate == null ||
                                            _selectedToDate == null)
                                        ? Consumer(
                                            builder: (context1, ref, child) {
                                            String temp =
                                                ref.watch(searchProvider);
                                            Map<String, dynamic> map = {
                                              'uid': uid,
                                              'sid': widget.shopId,
                                              'search':
                                                  temp.toUpperCase().trim()
                                            };
                                            return ref
                                                .watch(salesStreamProvider(
                                                    jsonEncode(map)))
                                                .when(
                                                  data: (data) => data.isEmpty
                                                      ? Center(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height:
                                                                      deviceHeight *
                                                                          0.5,
                                                                  width:
                                                                      deviceWidth *
                                                                          0.5,
                                                                  child: Lottie.asset(
                                                                      AssetConstants
                                                                          .noSmiley)),
                                                              Text(
                                                                "Oops! No Sales Yet...",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.015,
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : ListView.builder(
                                                          itemCount:
                                                              data.length,
                                                          itemBuilder:
                                                              (context2,
                                                                  index) {
                                                            SalesModel sale =
                                                                data[index];
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  pushEncode(
                                                                      sid: widget
                                                                          .shopId,
                                                                      sales:
                                                                          sale);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      deviceWidth *
                                                                          0.2,
                                                                      deviceHeight *
                                                                          0.125),
                                                                  backgroundColor:
                                                                      Pallete
                                                                          .primaryColor,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(deviceHeight *
                                                                              0.02),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Pallete.secondaryColor)),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      deviceWidth *
                                                                          0.01),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${sale.name}:${sale.id}',
                                                                            style: TextStyle(
                                                                                overflow: TextOverflow.ellipsis,
                                                                                fontSize: deviceWidth * 0.011,
                                                                                color: Pallete.secondaryColor,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          // SizedBox(
                                                                          //   width:
                                                                          //       deviceWidth * 0.25,
                                                                          // ),
                                                                          Text(
                                                                            "\₹ ${sale.totalPrice}",
                                                                            style: TextStyle(
                                                                                fontSize: deviceWidth * 0.011,
                                                                                color: Pallete.secondaryColor,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: deviceHeight *
                                                                            0.01,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            DateFormat('dd/mm/yyyy hh:mm:ss a').format(sale.saleDate),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: deviceWidth * 0.008,
                                                                              color: Pallete.secondaryColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                deviceWidth * 0.2,
                                                                          ),
                                                                          Text(
                                                                            "You will Get",
                                                                            style:
                                                                                TextStyle(fontSize: deviceWidth * 0.008, color: Colors.green),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                          error:
                                                              error.toString()),
                                                  loading: () => const Loader(),
                                                );
                                          })
                                        : Consumer(
                                            builder: (context, ref, child) {
                                              String temp =
                                                  ref.watch(searchProvider);
                                              Map<String, dynamic> map = {
                                                'uid': uid,
                                                'sid': widget.shopId,
                                                'fDate': _selectedFromDate!
                                                    .toIso8601String(),
                                                'tDate': _selectedToDate!
                                                    .toIso8601String(),
                                                'search':
                                                    temp.toUpperCase().trim()
                                              };
                                              return ref
                                                  .watch(
                                                      sortedSalesStreamProvider(
                                                          jsonEncode(map)))
                                                  .when(
                                                    data: (data) => data.isEmpty
                                                        ? Center(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        deviceHeight *
                                                                            0.5,
                                                                    width:
                                                                        deviceWidth *
                                                                            0.5,
                                                                    child: Lottie.asset(
                                                                        AssetConstants
                                                                            .noSmiley)),
                                                                Text(
                                                                  "Oops! No Sales Yet...",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          deviceWidth *
                                                                              0.015,
                                                                      color: Pallete
                                                                          .secondaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : ListView.builder(
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              SalesModel sale =
                                                                  data[index];
                                                              String
                                                                  saleEncode =
                                                                  jsonEncode({
                                                                'name':
                                                                    sale.name,
                                                                'id': sale.id,
                                                                'saleDate': sale
                                                                    .saleDate
                                                                    .toIso8601String(),
                                                                'totalPrice': sale
                                                                    .totalPrice,
                                                                'products': sale
                                                                    .products,
                                                                'customerId': sale
                                                                    .customerId
                                                              });
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Routemaster.of(
                                                                            context)
                                                                        .push(
                                                                            '/store/homescreen/${widget.shopId}/sales/${Uri.encodeComponent(saleEncode)}/salesSingle');
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    minimumSize: Size(
                                                                        deviceWidth *
                                                                            0.2,
                                                                        deviceHeight *
                                                                            0.125),
                                                                    backgroundColor:
                                                                        Pallete
                                                                            .primaryColor,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(deviceHeight *
                                                                                0.02),
                                                                        side: const BorderSide(
                                                                            color:
                                                                                Pallete.secondaryColor)),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(
                                                                        deviceWidth *
                                                                            0.015),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              '${sale.name}:${sale.id}',
                                                                              style: TextStyle(fontSize: deviceWidth * 0.011, color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              width: deviceWidth * 0.25,
                                                                            ),
                                                                            Text(
                                                                              "\₹ ${sale.totalPrice}",
                                                                              style: TextStyle(fontSize: deviceWidth * 0.011, color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              deviceHeight * 0.01,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              DateFormat('dd/mm/yyyy    hh:mm:ss a').format(sale.saleDate),
                                                                              style: TextStyle(
                                                                                fontSize: deviceWidth * 0.008,
                                                                                color: Pallete.secondaryColor,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: deviceWidth * 0.2,
                                                                            ),
                                                                            Text(
                                                                              "You will Get",
                                                                              style: TextStyle(fontSize: deviceWidth * 0.008, color: Colors.green),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                    error: (error,
                                                            stackTrace) =>
                                                        ErrorText(
                                                            error: error
                                                                .toString()),
                                                    loading: () =>
                                                        const Loader(),
                                                  );
                                            },
                                          ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: deviceWidth * 0.055,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: deviceWidth * 0.3,
                                height: deviceHeight * 0.55,
                                child: Lottie.asset(AssetConstants.saleLottie),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // var a = await ref
                                  //     .read(stockControllerProvider.notifier)
                                  //     .stockCheck(
                                  //         uid: datashop.uid,
                                  //         sid: datashop.shopId)
                                  //     .first;
                                  // if (a.isEmpty) {
                                  //   showNoStockAlertBox(context);
                                  // } else {
                                  //   Routemaster.of(context).push(
                                  //       '/store/homescreen/${widget.shopId}/sales/adds');
                                  // }

                                  pushEncodeAddSale(
                                      uid: uid,
                                      sid: widget.shopId,
                                      context: context);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      deviceWidth * 0.3, deviceHeight * 0.09),
                                  backgroundColor: Pallete.secondaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceHeight * 0.02),
                                      side: const BorderSide(
                                          color: Pallete.secondaryColor)),
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
                                      'Add Sale',
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.0125,
                                          color: Pallete.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
          );
        }),
      ),
    );
  }
}
