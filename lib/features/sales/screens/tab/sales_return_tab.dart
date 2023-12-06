import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/sale_return_model.dart';
import '../../../../models/shope_model.dart';
import '../../controller/sales_controller.dart';

class SalesReturnTab extends ConsumerStatefulWidget {
  final String encode;

  const SalesReturnTab({super.key, required this.encode});

  @override
  ConsumerState<SalesReturnTab> createState() => _SalesReturnTabState();
}

class _SalesReturnTabState extends ConsumerState<SalesReturnTab> {
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TextEditingController searchController = TextEditingController();
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  calculateTotalReturnSale({required List<SaleReturnModel> saleReturn}) {
    double tot = 0;
    for (var i in saleReturn) {
      tot = tot + double.parse(i.total);
    }
    return tot;
  }

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
        selectedFromDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
      });
    });
  }

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
        selectedToDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
      });
    });
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
    String temp = ref.watch(searchProvider);
    Map<String, dynamic> map = {
      'uid': shop.uid,
      'sid': shop.shopId,
      'search': temp.toUpperCase().trim(),
    };
    int dataLength =
        ref.watch(salesReturnStreamProvider(jsonEncode(map))).value?.length ??
            0;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: deviceHeight * 0.13,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
            )),
        title: const Text(
          "Sales Return",
          style: TextStyle(
              color: Pallete.secondaryColor, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: deviceHeight * 0.003),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: deviceWidth * 0.03,
            ),
            Column(
              children: [
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                InkWell(
                  onTap: () async {
                    _pickDateDialogfrom();
                  },
                  child: Container(
                    height: deviceWidth * 0.07,
                    width: deviceWidth * 0.15,
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
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        const Text("Date From :"),
                        SizedBox(
                          height: deviceHeight * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(selectedFromDate == null
                                ? 'Choose Date'
                                : DateFormat.yMMMd().format(selectedFromDate!)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                InkWell(
                  onTap: () async {
                    _pickDateDialogto();
                  },
                  child: Container(
                    height: deviceWidth * 0.07,
                    width: deviceWidth * 0.15,
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
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        const Text("Date To :"),
                        SizedBox(
                          height: deviceHeight * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(selectedToDate == null
                                ? 'Choose Date'
                                : DateFormat.yMMMd().format(selectedToDate!)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: deviceWidth * 0.05,
            ),
            SizedBox(
                width: deviceWidth * 0.4,
                child: (selectedFromDate == null || selectedToDate == null)
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
                                      ? Center(
                                          child: Text('no SalesReturns'),
                                        )
                                      : Container(
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
                                          width: deviceWidth * 0.45,
                                          height: deviceHeight,
                                          child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                SaleReturnModel salesReturn =
                                                    data[index];
                                                return InkWell(
                                                  onTap: () {
                                                    pushEncodeParty(
                                                        sr: salesReturn);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        deviceWidth * 0.01),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 5,
                                                                spreadRadius: 1,
                                                                offset: Offset(
                                                                    4, 4))
                                                          ],
                                                          color: Pallete
                                                              .thirdColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  deviceHeight *
                                                                      0.03)),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            deviceHeight *
                                                                0.01),
                                                        child: ListTile(
                                                          title: Text(
                                                            'Bill No : ${salesReturn.saleId}',
                                                            style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.033,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          subtitle: Text(
                                                              DateFormat(
                                                                      'yMMMd')
                                                                  .format(salesReturn
                                                                      .saleReturnDate),
                                                              style: TextStyle(
                                                                  color: Pallete
                                                                      .secondaryColor,
                                                                  fontSize:
                                                                      deviceHeight *
                                                                          0.025)),
                                                          trailing: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '₹ ${salesReturn.total}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontSize:
                                                                        deviceHeight *
                                                                            0.03,
                                                                  )),
                                                              Text(
                                                                'Successfully Returned',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        deviceHeight *
                                                                            0.017),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
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
                            'search': temp.toUpperCase().trim(),
                            'fDate': selectedFromDate!.toIso8601String(),
                            'tDate': selectedToDate!.toIso8601String()
                          };

                          return ref
                              .watch(sortedSalesReturnStreamProvider(
                                  jsonEncode(map)))
                              .when(
                                data: (data) {
                                  return data.isEmpty
                                      ? Center(
                                          child: Text('no SaleReturn'),
                                        )
                                      : Container(
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
                                          width: deviceWidth * 0.45,
                                          height: deviceHeight,
                                          child: ListView.builder(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemCount: data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                SaleReturnModel salesReturn =
                                                    data[index];
                                                return InkWell(
                                                  onTap: () {
                                                    pushEncodeParty(
                                                        sr: salesReturn);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        deviceWidth * 0.01),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius: 5,
                                                                spreadRadius: 1,
                                                                offset: Offset(
                                                                    4, 4))
                                                          ],
                                                          color: Pallete
                                                              .thirdColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  deviceHeight *
                                                                      0.03)),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            deviceHeight *
                                                                0.01),
                                                        child: ListTile(
                                                          title: Text(
                                                            'Bill No : ${salesReturn.saleId}',
                                                            style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.033,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          subtitle: Text(
                                                              DateFormat(
                                                                      'yMMMd')
                                                                  .format(salesReturn
                                                                      .saleReturnDate),
                                                              style: TextStyle(
                                                                  color: Pallete
                                                                      .secondaryColor,
                                                                  fontSize:
                                                                      deviceHeight *
                                                                          0.025)),
                                                          trailing: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                  '₹ ${salesReturn.total}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontSize:
                                                                        deviceHeight *
                                                                            0.03,
                                                                  )),
                                                              Text(
                                                                'Successfully Returned',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        deviceHeight *
                                                                            0.017),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      )),
            SizedBox(
              width: deviceWidth * 0.05,
            ),
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) => SizedBox(
                    height: deviceHeight * 0.1,
                    width: deviceWidth * 0.27,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Search Data",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.03))),
                      onChanged: (value) => ref
                          .read(searchProvider.notifier)
                          .update((state) => value),
                      controller: searchController,
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                Container(
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.27,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(4, 4))
                      ],
                      color: Pallete.thirdColor,
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No of Transactions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceHeight * 0.028,
                              color: Pallete.secondaryColor),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.006,
                        ),
                        Text(
                          '$dataLength',
                          style: TextStyle(
                              fontSize: deviceHeight * 0.036,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
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
                            height: deviceWidth * 0.07,
                            width: deviceWidth * 0.27,
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Sales Return",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceHeight * 0.028,
                                        color: Pallete.secondaryColor),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.006,
                                  ),
                                  Text(
                                    calculateTotalReturnSale(saleReturn: data)
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceHeight * 0.033),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                }),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.03),
                  child: InkWell(
                    onTap: () => Routemaster.of(context).push(
                        '/store/${shop.shopId}/Sales_Return/${widget.encode}/addSales_Return'),
                    child: Container(
                      height: deviceWidth * 0.05,
                      width: deviceWidth * 0.17,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          color: Pallete.secondaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            color: Pallete.primaryColor,
                            size: deviceHeight * 0.03,
                          ),
                          const Text(
                            " Add Sales return",
                            style: TextStyle(color: Pallete.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: deviceWidth * 0.03,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
