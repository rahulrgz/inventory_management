import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/stocks/controller/stock_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/stock_model.dart';

class StockScreenTab extends StatefulWidget {
  final ShopModel shop;
  const StockScreenTab({super.key, required this.shop});

  @override
  State<StockScreenTab> createState() => _StockScreenTabState();
}

class _StockScreenTabState extends State<StockScreenTab> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  double totalStock = 0.00;
  String dropdownValuetab = 'Num';
  double totalPurchasePrice = 0.0;
  TextEditingController productName = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController salePrice = TextEditingController();

  // void _handleDelete(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       contentTextStyle: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           color: Pallete.primaryColor,
  //           fontSize: deviceWidth * 0.015),
  //       actionsAlignment: MainAxisAlignment.center,
  //       backgroundColor: Pallete.secondaryColor,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
  //       actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Are you sure you want to ',
  //             style: TextStyle(
  //                 fontSize: deviceWidth * 0.022, color: Pallete.primaryColor),
  //           ),
  //           Text(
  //             'delete?',
  //             style: TextStyle(
  //                 fontSize: deviceWidth * 0.022, color: Pallete.primaryColor),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: Size(deviceWidth * 0.11, deviceHeight * 0.06),
  //             backgroundColor: Pallete.secondaryColor,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(deviceHeight * 0.02),
  //                 side: const BorderSide(color: Pallete.primaryColor)),
  //           ),
  //           child: Text(
  //             'Cancel',
  //             style: TextStyle(
  //                 fontSize: deviceWidth * 0.02,
  //                 fontWeight: FontWeight.bold,
  //                 color: Pallete.primaryColor),
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           style: ElevatedButton.styleFrom(
  //             minimumSize: Size(deviceWidth * 0.11, deviceHeight * 0.06),
  //             backgroundColor: Pallete.primaryColor,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(deviceHeight * 0.02),
  //                 side: const BorderSide(color: Pallete.secondaryColor)),
  //           ),
  //           child: Text(
  //             'Delete',
  //             style: TextStyle(
  //                 fontSize: deviceWidth * 0.02,
  //                 fontWeight: FontWeight.bold,
  //                 color: Pallete.secondaryColor),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  calculateTotalSale({required List<SalesModel> sale}) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    double tot = 0;
    for (var i in sale) {
      DateTime saleDate = DateTime.parse(i.saleDate.toString());
      if (saleDate.month == currentMonth && saleDate.year == currentYear) {
        tot = tot + double.parse(i.totalPrice);
      }
    }
    return tot;
  }

  double calculateTotalPurchase({required List<StockModel> stock}) {
    double tot = 0;
    for (var i in stock) {
      tot += i.purchasePrice * i.quantity;
    }
    return tot;
  }

  void addItemtostock(BuildContext context) {
    showDialog(
      context: context,
      builder: (context2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.015)),
        content: SizedBox(
          height: deviceHeight * 0.68,
          width: deviceWidth * 0.45,
          child: Padding(
            padding: EdgeInsets.only(
                top: deviceWidth * 0.03,
                left: deviceWidth * 0.025,
                right: deviceWidth * 0.025,
                bottom: deviceWidth * 0.025),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  TextFormField(
                    controller: productName,
                    inputFormatters: [LengthLimitingTextInputFormatter(25)],
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        label: const Text(
                          '  Enter Product Name',
                          style: TextStyle(color: Pallete.secondaryColor),
                        )),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    controller: purchasePrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor),
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        label: const Text(
                          '  Enter purchase price',
                          style: TextStyle(color: Pallete.secondaryColor),
                        )),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    controller: salePrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor),
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
                        ),
                        label: const Text(
                          '  Enter sale price',
                          style: TextStyle(color: Pallete.secondaryColor),
                        )),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: deviceWidth * 0.23,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          controller: productQuantity,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color:
                                        Pallete.secondaryColor), //<-- SEE HERE
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                              ),
                              label: const Text(
                                '  Quantity',
                                style: TextStyle(color: Pallete.secondaryColor),
                              )),
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.15,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color:
                                        Pallete.secondaryColor), //<-- SEE HERE
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                              ),
                              label: const Text(
                                '  Select Unit',
                                style: TextStyle(color: Pallete.secondaryColor),
                              )),
                          dropdownColor: Pallete.primaryColor,
                          value: dropdownValuetab,
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValuetab = newValue!;
                            });
                          },
                          items: <String>['Num', 'KG', 'G', 'Ltr', 'Mtr']
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceHeight * 0.05,
                  ),
                  Consumer(
                      builder: (context1, ref, child) => ElevatedButton(
                            onPressed: () {
                              addStock(ref: ref, context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(deviceWidth * 0.3, deviceHeight * 0.09),
                              backgroundColor: Pallete.secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    deviceHeight * 0.02,
                                  ),
                                  side: const BorderSide(
                                      color: Pallete.secondaryColor)),
                            ),
                            child: Text(
                              'Add Stock',
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.0125,
                                  color: Pallete.primaryColor),
                            ),
                          )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Stock Report',
          style: TextStyle(
              color: Pallete.secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: deviceHeight * 0.04),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            children: [
              Consumer(builder: (context, ref, child) {
                Map<String, dynamic> map = {
                  'sid': widget.shop.shopId,
                  'uid': widget.shop.uid,
                };
                return ref.watch(totalStockProvider(jsonEncode(map))).when(
                      data: (data) {
                        return Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(deviceHeight * 0.05),
                            child: Container(
                              height: deviceHeight * 0.2,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4, 4)),
                                ],
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.02),
                                color: Pallete.primaryColor,
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: deviceHeight * 0.12,
                                  width: deviceWidth * 0.2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Total Stock Value',
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                      Text(
                                        '₹ ${calculateTotalPurchase(stock: data)}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                            fontSize: deviceHeight * 0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              }),
              Consumer(builder: (context, ref, child) {
                Map<String, dynamic> map = {
                  'sid': widget.shop.shopId,
                  'uid': widget.shop.uid,
                };
                return ref.watch(totalSale(jsonEncode(map))).when(
                      data: (data) {
                        return Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.all(deviceHeight * 0.05),
                            child: Container(
                              height: deviceHeight * 0.2,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4, 4)),
                                ],
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.02),
                                color: Pallete.primaryColor,
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: deviceHeight * 0.12,
                                  width: deviceWidth * 0.2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Total Sales This Month',
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                      Text(
                                        '₹ ${calculateTotalSale(sale: data)}',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: deviceHeight * 0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceHeight * 0.05, right: deviceHeight * 0.05),
            child: Container(
              height: deviceHeight * 0.5,
              width: deviceWidth * 0.8,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(4, 4)),
                ],
                borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                color: Pallete.primaryColor,
              ),
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Consumer(builder: (context, ref, child) {
                    var search = ref.watch(searchProvider);
                    Map<String, dynamic> map = {
                      'uid': widget.shop.uid,
                      'shopId': widget.shop.shopId,
                      'search': search,
                    };
                    return ref.watch(stockStreamProvider(jsonEncode(map))).when(
                        data: (data) => data.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('no stock'),
                                ],
                              )
                            : DataTable(
                                border: TableBorder.all(width: 0.03),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Item Name',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.025),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Purchase Price',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.025),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Unit',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.025),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Quantity',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.025),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Sale Price',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.025),
                                    ),
                                    numeric: true,
                                  ),
                                ],
                                rows: List<DataRow>.generate(data.length,
                                    (index) {
                                  StockModel stock = data[index];
                                  return DataRow(cells: [
                                    DataCell(
                                      Text(
                                        stock.itemName,
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.purchasePrice.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.unit,
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.quantity.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.salePrice.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03),
                                      ),
                                    ),
                                  ]);
                                })),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader());
                  })),
            ),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addItemtostock(context);
        },
        icon: const Icon(Icons.add_circle_outline),
        label: const Text("Add Stock"),
      ),
    );
  }

  void addStock({required WidgetRef ref, required BuildContext context}) {
    if (productName.text.trim().isEmpty ||
        salePrice.text.trim().isEmpty ||
        purchasePrice.text.trim().isEmpty ||
        productQuantity.text.trim().isEmpty) {
      Routemaster.of(context).pop();
      // Show a snackbar indicating that all fields are mandatory
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please fill all those field.'),
        ),
      );
      return; // Stop further execution of the function
    }
    StockModel stockModel = StockModel(
      itemName: productName.text.trim(),
      salePrice: double.parse(salePrice.text),
      purchasePrice: double.parse(purchasePrice.text),
      unit: dropdownValuetab,
      quantity: int.parse(productQuantity.text),
      setSearch: setSearchParam(
          '${productName.text.trim()} ${salePrice.text.toString()}'),
      deleted: false,
    );
    ref.read(stockControllerProvider.notifier).addStock(
        uid: widget.shop.uid,
        shopId: widget.shop.shopId,
        stockModel: stockModel,
        context: context);
    Routemaster.of(context).pop();
    productName.clear();
    productQuantity.clear();
    purchasePrice.clear();
    salePrice.clear();
  }
}
