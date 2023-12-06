import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/stocks/controller/stock_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/stock_model.dart';

class Shop_StockScreenWeb extends ConsumerStatefulWidget {
  final String shopId;

  const Shop_StockScreenWeb({super.key, required this.shopId});

  @override
  ConsumerState<Shop_StockScreenWeb> createState() =>
      _Shop_StockScreenWebState();
}

class _Shop_StockScreenWebState extends ConsumerState<Shop_StockScreenWeb> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  double totalStock = 0.00;
  String dropdownValuetab = 'N';
  double totalPurchasePrice = 0.0;
  TextEditingController productName = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  String name1 = '';
  String name2 = '';
  int count = 0;

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
  // void calculateTotal() {
  //   setState(() {
  //     totalPurchasePrice = stockItems.fold(
  //       0.0,
  //       (double sum, StockModel item) =>
  //           sum + (item.purchasePrice * item.quantity),
  //     );
  //   });
  // }

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
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    controller: productName,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
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
                    controller: salePrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Pallete.secondaryColor), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        label: const Text(
                          '  Enter sales price',
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        label: const Text(
                          '  Enter purchase price',
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
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                                borderRadius: BorderRadius.circular(10.0),
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
                                    color: Pallete.secondaryColor),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                                borderRadius: BorderRadius.circular(10.0),
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
                          items: <String>['N', 'KG', 'G', 'Ltr', 'Mtr']
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
                              addStrock(ref: ref, context: context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(deviceWidth * 0.3, deviceHeight * 0.09),
                              backgroundColor: Pallete.secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
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
    var uid = ref.watch(userProvider)!.uid;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Row(children: [
            Consumer(builder: (context, ref, child) {
              return Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.02, left: deviceWidth * 0.13),
                child: Consumer(builder: (context, ref, child) {
                  Map<String, dynamic> map = {
                    'sid': widget.shopId,
                    'uid': uid,
                  };
                  return ref.watch(totalStockProvider(jsonEncode(map))).when(
                        data: (data) {
                          return Container(
                            height: deviceHeight * 0.15,
                            width: deviceWidth * 0.2,
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
                                  SizedBox(
                                    width: deviceWidth * 0.34,
                                    child: Text(
                                      '₹ ${calculateTotalPurchase(stock: data)}',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                          fontSize: deviceHeight * 0.04),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => Loader(),
                      );
                }),
              );
            }),
            Consumer(builder: (context, ref, child) {
              Map<String, dynamic> map = {
                'sid': widget.shopId,
                'uid': uid,
              };
              return ref.watch(totalSale(jsonEncode(map))).when(
                    data: (data) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.02, left: deviceWidth * 0.3),
                        child: Container(
                          height: deviceHeight * 0.15,
                          width: deviceWidth * 0.2,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Total Sales',
                                  style: TextStyle(
                                      color: Pallete.secondaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: deviceHeight * 0.03),
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.34,
                                  child: Text(
                                    '₹ ${calculateTotalSale(sale: data)}',
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                        fontSize: deviceHeight * 0.04),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => Loader(),
                  );
            }),
          ]),
          Padding(
            padding: EdgeInsets.only(
                top: deviceHeight * 0.05,
                left: deviceHeight * 0.22,
                right: deviceHeight * 0.22),
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
                    String uid = ref.read(userProvider)!.uid;
                    var search = ref.watch(searchProvider);

                    Map<String, dynamic> map = {
                      'uid': uid,
                      'shopId': widget.shopId,
                      'search': search
                    };
                    return ref.watch(stockStreamProvider(jsonEncode(map))).when(
                        data: (data) => data.isEmpty
                            ? Center(
                                child: Text('no stock'),
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
                                      SizedBox(
                                        width: deviceWidth * 0.1,
                                        child: Text(
                                          stock!.itemName,
                                          style: TextStyle(
                                              fontSize: deviceHeight * 0.03),
                                        ),
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
                        loading: () => Loader());
                  })),
            ),
          ),
          SizedBox(height: deviceHeight * 0.03),
          ElevatedButton(
            // onPressed: () => Routemaster.of(context).pop(),
            onPressed: () => addItemtostock(context),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.15, deviceHeight * 0.09),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Add Stock',
              style: TextStyle(
                  fontSize: deviceWidth * 0.012,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
        ]),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     addItemtostock(context);
      //   },
      //   label: const Text("Add Stock"),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(20.0),
      //   ),
      //        ),
    );
  }

  void addStrock({required WidgetRef ref, required BuildContext context}) {
    if (productName.text.trim().isEmpty ||
        salePrice.text.trim().isEmpty ||
        purchasePrice.text.trim().isEmpty ||
        productQuantity.text.trim().isEmpty) {
      showSnackBar(context, 'please fill all those field');
    }
    String uid = ref.read(userProvider)!.uid;
    StockModel stockModel = StockModel(
      itemName: productName.text.trim(),
      salePrice: double.parse(salePrice.text.trim()),
      purchasePrice: double.parse(purchasePrice.text.trim()),
      unit: dropdownValuetab,
      quantity: int.parse(productQuantity.text.trim()),
      setSearch: setSearchParam(
          '${productName.text.trim()}${salePrice.text.toString()}'),
      deleted: false,
    );
    ref.read(stockControllerProvider.notifier).addStock(
        uid: uid,
        shopId: widget.shopId,
        stockModel: stockModel,
        context: context);
    Routemaster.of(context).pop();
    productName.clear();
    productQuantity.clear();
    purchasePrice.clear();
    salePrice.clear();
  }
}
