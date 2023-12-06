import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../../../models/stock_model.dart';
import '../../controller/stock_controller.dart';

class stockMobile extends StatefulWidget {
  final ShopModel shop;
  const stockMobile({super.key, required this.shop});

  @override
  State<stockMobile> createState() => _stockMobileState();
}

class _stockMobileState extends State<stockMobile> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  double totalStock = 0.00;
  String dropdownValuetab = 'Select Unit';

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

  stockbottomSheet(BuildContext context, ShopModel shop) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Pallete.thirdColorMob,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(deviceWidth * 0.12))),
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SizedBox(
              width: deviceWidth * 0.86,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  'Add Stock',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: deviceHeight * 0.03),
                Container(
                  width: deviceWidth * 0.85,
                  height: deviceHeight * 0.06,
                  decoration: BoxDecoration(
                    color: Pallete.primaryColor,
                    borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                  ),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(25)],
                    controller: productName,
                    decoration: InputDecoration(
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      labelText: 'Enter Product Name',
                      labelStyle: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceHeight * 0.02),
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: deviceWidth * 0.4,
                      height: deviceHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Pallete.primaryColor,
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        controller: salePrice,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          labelText: 'Sale Price',
                          labelStyle: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceHeight * 0.02),
                        ),
                      ),
                    ),
                    Container(
                      width: deviceWidth * 0.4,
                      height: deviceHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Pallete.primaryColor,
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
                        ],
                        controller: purchasePrice,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          labelText: 'Purchase Price',
                          labelStyle: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceHeight * 0.02),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: deviceWidth * 0.4,
                      height: deviceHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Pallete.primaryColor,
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6)
                        ],
                        controller: productQuantity,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Pallete.secondaryColor,
                                width: deviceWidth * 0.001),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                          ),
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceHeight * 0.02),
                        ),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.06,
                      width: deviceWidth * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                        color: Pallete.primaryColor,
                        borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      ),
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: deviceWidth * 0.04),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        dropdownColor: Pallete.primaryColor,
                        value: dropdownValuetab,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValuetab = newValue!;
                          });
                        },
                        items: <String>[
                          'Select Unit',
                          'N',
                          'KG',
                          'G',
                          'Ltr',
                          'Mtr'
                        ].map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Pallete.secondaryColor),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.03,
                ),
                Consumer(builder: (context1, ref, child) {
                  return InkWell(
                      onTap: () {
                        addStock(ref: ref, context: context);
                      },
                      child: Container(
                          height: deviceHeight * 0.07,
                          width: deviceWidth,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.04),
                            color: Pallete.secondaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Add Stock ',
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.04,
                                  color: Pallete.primaryColor),
                            ),
                          )));
                }),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = widget.shop;
    return Scaffold(
      backgroundColor: Pallete.thirdColorMob,
      appBar: AppBar(
        backgroundColor: Pallete.thirdColorMob,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "STOCKS",
          style: TextStyle(
              color: Pallete.secondaryColor,
              fontSize: deviceWidth * 0.045,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer(builder: (context, ref, child) {
                    Map<String, dynamic> map = {
                      'sid': shop.shopId,
                      'uid': shop.uid,
                    };
                    return ref.watch(totalStockProvider(jsonEncode(map))).when(
                          data: (data) {
                            return Container(
                              width: deviceWidth * 0.44,
                              height: deviceHeight * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 2)),
                                ],
                                color: Pallete.primaryColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Total Stock ',
                                      style: TextStyle(
                                          color: Pallete.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: deviceWidth * 0.03)),
                                  Text(
                                      '₹ ${calculateTotalPurchase(stock: data)}',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: deviceWidth * 0.05)),
                                ],
                              ),
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => Loader(),
                        );
                  }),
                  SizedBox(
                    width: deviceHeight * 0.01,
                  ),
                  Consumer(builder: (context, ref, child) {
                    Map<String, dynamic> map = {
                      'sid': shop.shopId,
                      'uid': shop.uid,
                    };
                    return ref.watch(totalSale(jsonEncode(map))).when(
                          data: (data) {
                            return Container(
                              width: deviceWidth * 0.44,
                              height: deviceHeight * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                      spreadRadius: 0.5,
                                      offset: Offset(0, 2)),
                                ],
                                color: Pallete.primaryColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total sales',
                                    style: TextStyle(
                                        color: Pallete.secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceWidth * 0.03),
                                  ),
                                  Text('₹ ${calculateTotalSale(sale: data)}',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: deviceWidth * 0.05))
                                ],
                              ),
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => Loader(),
                        );
                  }),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.005,
            ),
            Padding(
              padding: EdgeInsets.all(deviceWidth * 0.035),
              child: InkWell(
                onTap: () {
                  stockbottomSheet(context, widget.shop);
                },
                child: Container(
                    height: deviceHeight * 0.06,
                    // width: deviceWidth * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 1,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2)),
                      ],
                      color: Pallete.primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            Icons.add_circle_outline_sharp,
                            color: Pallete.secondaryColor,
                            size: deviceWidth * 0.04,
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.009),
                        Text(
                          'Add Stock Items ',
                          style: TextStyle(
                              fontSize: deviceWidth * 0.04,
                              color: Pallete.secondaryColor),
                        )
                      ],
                    )),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            SizedBox(
              height: deviceHeight * 0.55,
              width: deviceWidth * 0.92,
              // color: Colors.red,
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
                            ? const Center(
                                child: Text('no stock'),
                              )
                            : DataTable(
                                columnSpacing: deviceWidth * 0.04,
                                border: TableBorder.all(width: 0.04),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Item Name',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.012),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Purchase Price',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.012),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Unit',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.012),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Quantity',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.012),
                                    ),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Sale Price',
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.012),
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
                                        width: deviceWidth * 0.13,
                                        child: Text(
                                          stock.itemName,
                                          style: TextStyle(
                                              fontSize: deviceHeight * 0.012),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.purchasePrice.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.012),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.unit,
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.012),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.quantity.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.012),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        stock.salePrice.toString(),
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.012),
                                      ),
                                    ),
                                  ]);
                                })),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader());
                  })),
            ),
          ],
        ),
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
      salePrice: double.parse(salePrice.text.trim()),
      purchasePrice: double.parse(purchasePrice.text.trim()),
      unit: dropdownValuetab,
      quantity: int.parse(productQuantity.text.trim()),
      setSearch: setSearchParam(
          '${productName.text.trim()} ${salePrice.text.toString()}'),
      deleted: false,
    );

    ref.read(stockControllerProvider.notifier).addStock(
          uid: widget.shop.uid,
          shopId: widget.shop.shopId,
          stockModel: stockModel,
          context: context,
        );
    Routemaster.of(context).pop();
    productName.clear();
    productQuantity.clear();
    purchasePrice.clear();
    salePrice.clear();
  }
}
