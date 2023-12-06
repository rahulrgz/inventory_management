import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/export/export_as_exel.dart';
import '../../../../core/commons/export/export_as_pdf.dart';
import '../../../../models/billitem_model.dart';

class SalesSingleViewTab extends ConsumerWidget {
  final String sales;

  const SalesSingleViewTab({super.key, required this.sales});

  List<BillItems> toBillItems({required SalesModel sales}) {
    List<BillItems> items = [];
    for (var i in sales.products) {
      items.add(BillItems.fromMap(i));
    }
    return items;
  }

  decode(String encode) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(encode));
    return SalesModel(
        name: map['name'],
        saleDate: DateTime.parse(map['saleDate']),
        products: List<Map<String, dynamic>>.from(map['products']),
        customerId: map['customerId'],
        totalPrice: map['totalPrice'],
        id: map['id'],
        setSearch: []);
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    SalesModel sale = decode(sales);
    List<BillItems> items = toBillItems(sales: sale);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Pallete.primaryColor,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
              size: deviceWidth * 0.03,
            )),
        title: Text(
          'Sales Bill - ${sale.name}',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceHeight * 0.04),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: deviceHeight,
            width: deviceWidth * 0.2,
            // color: Colors.red,
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                Container(
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
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.006,
                      ),
                      Text(
                        "Invoice No :",
                        style: TextStyle(fontSize: deviceHeight * 0.03),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(
                        sale.id,
                        style: TextStyle(fontSize: deviceHeight * 0.025),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                Container(
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
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.007,
                      ),
                      Text(
                        "Invoice Date :",
                        style: TextStyle(fontSize: deviceHeight * 0.03),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(DateFormat.yMMMd().format(sale.saleDate),
                          style: TextStyle(fontSize: deviceHeight * 0.025)),
                    ],
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
              ],
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: deviceHeight * 0.08,
                      width: deviceWidth * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(
                            deviceWidth * 0.01),
                        border: Border.all(
                          color: Pallete.secondaryColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sale.name,
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceWidth * 0.02),
                        ),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.08,
                      width: deviceWidth * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(
                            deviceWidth * 0.01),
                        border: Border.all(
                          color: Pallete.secondaryColor,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sale.totalPrice,
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceWidth * 0.02),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: deviceWidth * 0.5,
                  child: SingleChildScrollView(
                    child: DataTable(
                      showBottomBorder: true,
                      columns: const [
                        DataColumn(label: Text('Item')),
                        DataColumn(label: Text('Qty')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Returned')),
                        DataColumn(label: Text('Total')),
                      ],
                      rows: items.asMap().entries.map((entry) {
                        final products = entry.value;
                        return DataRow(
                          cells: [
                            DataCell(Text(products.itemName)),
                            DataCell(Text(products.itemQuantity.toString())),
                            DataCell(
                                Text(products.salePrice.toStringAsFixed(2))),
                            DataCell(Text(products.itemReturned.toString())),
                            DataCell(Text(
                                (products.itemQuantity * products.salePrice)
                                    .toStringAsFixed(2))),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight,
            width: deviceWidth * 0.26,
            // color: Colors.orange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: deviceHeight * 0.03, top: deviceHeight * 0.017),
                  child: Container(
                    height: deviceWidth * 0.05,
                    width: deviceWidth * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(2, 3))
                      ],
                      color: Pallete.thirdColor,
                    ),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          "Share as Excel",
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceHeight * 0.03),
                        ),
                        onPressed: () => exportToExcel(items),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: deviceHeight * 0.03, top: deviceHeight * 0.017),
                  child: Container(
                    height: deviceWidth * 0.05,
                    width: deviceWidth * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(2, 3))
                      ],
                      color: Pallete.thirdColor,
                    ),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          "Share as PDF",
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceHeight * 0.03),
                        ),
                        onPressed: () => previewPdfSales(items),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
