import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/export/export_as_exel.dart';
import '../../../../core/commons/export/export_as_pdf.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/billitem_model.dart';

class SalesReturnSingleViewTab extends ConsumerWidget {
  final String encode;
  const SalesReturnSingleViewTab({super.key, required this.encode});
  List<BillItems> toBillItems({required List<Map<String, dynamic>> srl}) {
    List<BillItems> items = [];
    for (var i in srl) {
      items.add(BillItems(
          itemName: i['itemName'],
          itemQuantity: i['itemQuantity'],
          salePrice: i['salePrice'],
          total: i['total'],
          unit: '',
          purchasePrice: i['purchasePrice'] ?? 0.0,
          itemReturned: 0));
    }
    return items;
  }

  SaleReturnModel decode(String encode) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(encode));
    return SaleReturnModel(
        saleId: map['saleId'],
        saleReturnId: map['saleReturnId'],
        saleReturnDate: DateTime.parse(map['saleReturnDate']),
        products: List<Map<String, dynamic>>.from(map['products']),
        total: map['total'],
        setSearch: []);
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    SaleReturnModel sr = decode(encode);
    List<BillItems> items = toBillItems(srl: sr.products);
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
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.secondaryColor,
          ),
        ),
        title: Text(
          'Sales Return Bill - ${sr.saleId}',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceHeight * 0.037),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
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
                            blurRadius: 3,
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
                        height: deviceHeight * 0.01,
                      ),
                      const Text("Invoice No :"),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(sr.saleId),
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
                            blurRadius: 3,
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
                        height: deviceHeight * 0.01,
                      ),
                      const Text("Invoice Date :"),
                      SizedBox(
                        height: deviceHeight * 0.005,
                      ),
                      Text(DateFormat.yMMMd().format(sr.saleReturnDate)),
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
            // color: Colors.blue,
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          'Name',
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
                          sr.total,
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceWidth * 0.02),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                SizedBox(
                  width: deviceWidth * 0.46,
                  child: SingleChildScrollView(
                    child: DataTable(
                      // columnSpacing: deviceWidth * 0.02,
                      showBottomBorder: true,
                      columns: const [
                        DataColumn(label: Text('Item')),
                        DataColumn(label: Text('Qty')),
                        DataColumn(label: Text('Price')),
                        // DataColumn(label: Text('Returned')),
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
                            // DataCell(Text(products.itemReturned.toString())),
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
            width: deviceWidth * 0.25,
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
