import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/alert_dialog_boxes_web.dart';
import 'package:inventory_management_shop/core/commons/export/export_as_exel.dart';
import 'package:inventory_management_shop/core/commons/export/export_as_pdf.dart';
import 'package:inventory_management_shop/core/forWeb/salePdf_web.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/sales/controller/sales_controller.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/forWeb/salesExcel_web.dart';
import '../../../../models/billitem_model.dart';

class SingleSalesScreenWeb extends ConsumerWidget {
  const SingleSalesScreenWeb({
    super.key,
  });

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
    // SalesModel salesModel=decode(sales);
    var sale = ref.read(sigleSaleProvider)!;
    List<BillItems> items = toBillItems(sales: sale);
    return Scaffold(
        body: Column(children: [
      Padding(
        padding: EdgeInsets.only(top: deviceHeight * 0.03),
        child: SizedBox(
          width: deviceWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Routemaster.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topRight: Radius.circular(deviceHeight * 0.02),
                    bottomRight: Radius.circular(deviceHeight * 0.02),
                  )),
                ),
                child: Center(
                    child: Icon(
                  Icons.arrow_back_rounded,
                  color: Pallete.primaryColor,
                  size: deviceHeight * 0.03,
                )),
              ),
              // SizedBox(width: deviceWidth*0.4,),
              Text(
                "Sales - ${sale.name}",
                style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontSize: deviceWidth * .02,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: deviceWidth * 0.2,
              )
            ],
          ),
        ),
      ),
      SizedBox(height: deviceHeight * 0.07),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: deviceHeight * 0.07,
                  width: deviceWidth * 0.10,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.circular(deviceWidth * 0.01),
                    border: Border.all(
                      color: Pallete.secondaryColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Invoice.No:${sale.id}',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceWidth * 0.01),
                    ),
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.05,
                ),
                Container(
                  height: deviceHeight * 0.07,
                  width: deviceWidth * 0.10,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.circular(deviceWidth * 0.01),
                    border: Border.all(
                      color: Pallete.secondaryColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Date:${DateFormat('dd-MM-yyyy').format(sale.saleDate)}',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceWidth * 0.01),
                    ),
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.05,
                ),
                Container(
                  height: deviceHeight * 0.07,
                  width: deviceWidth * 0.19,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadiusDirectional.circular(deviceWidth * 0.01),
                    border: Border.all(
                      color: Pallete.secondaryColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      ' Name: ${sale.name}',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceWidth * 0.01),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: deviceWidth * 0.5,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.04),
                  child: DataTable(showBottomBorder: true, columns: const [
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Total')),
                  ], rows: [
                    ...items.asMap().entries.map((entry) {
                      final products = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(Text(products.itemName)),
                          DataCell(Text(products.itemQuantity.toString())),
                          DataCell(Text(products.salePrice.toStringAsFixed(2))),
                          DataCell(Text(
                              (products.itemQuantity * products.salePrice)
                                  .toStringAsFixed(2))),
                        ],
                      );
                    }).toList(),
                    DataRow(
                      cells: [
                        DataCell(Text('Grand Total',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text('')), // Empty cell for quantity
                        DataCell(Text('')), // Empty cell for price
                        DataCell(
                          Text(sale.totalPrice,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            )
          ]),
          // SizedBox(height: deviceHeight*0.65,)

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: deviceHeight * 0.03, top: deviceHeight * 0.017),
                child: GestureDetector(
                  onTap: () => generateAndSavePdf(items),
                  child: Container(
                    height: deviceWidth * 0.028,
                    width: deviceWidth * 0.15,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02),
                        border: Border.all(color: Pallete.secondaryColor)),
                    child: Center(
                      child: Text(
                        "Save as Pdf",
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceHeight * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: deviceHeight * 0.03, top: deviceHeight * 0.03),
                child: GestureDetector(
                  onTap: () => exportToExcel(items),
                  child: Container(
                    height: deviceWidth * 0.028,
                    width: deviceWidth * 0.15,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02),
                        border: Border.all(color: Pallete.secondaryColor)),
                    child: Center(
                      child: Text(
                        "Save as Excel",
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceHeight * 0.02),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ]));
  }
}
