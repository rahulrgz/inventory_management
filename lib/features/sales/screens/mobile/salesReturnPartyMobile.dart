import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';

import '../../../../core/commons/export/export_as_exel.dart';
import '../../../../core/commons/export/export_as_pdf.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/billitem_model.dart';

class SalesReturnPartyScreenMobile extends ConsumerWidget {
  final String encode;
  const SalesReturnPartyScreenMobile({super.key, required this.encode});

  List<BillItems> toBillItems({required List<Map<String, dynamic>> srl}) {
    List<BillItems> items = [];
    for (var i in srl) {
      items.add(BillItems(
          unit: '',
          total: i['total'],
          salePrice: i['salePrice'],
          purchasePrice: i['purchasePrice'] ?? 0.0,
          itemReturned: 0,
          itemName: i['itemName'],
          itemQuantity: i['itemQuantity']));
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
        elevation: 0,
        backgroundColor: Pallete.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.secondaryColor,
          ),
        ),
        title: Text(sr.saleId,
            style: const TextStyle(color: Pallete.secondaryColor)),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(deviceWidth * 0.1),
                      topRight: Radius.circular(deviceWidth * 0.1),
                    ),
                  ),
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: deviceHeight * 0.15,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: deviceHeight * 0.025),
                            child: Text(
                              'Share as',
                              style: TextStyle(fontSize: deviceHeight * 0.02),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => generateAndSavePdf(items),
                                child: CircleAvatar(
                                  radius: deviceWidth * 0.08,
                                  backgroundColor: Pallete.thirdColorMob,
                                  foregroundImage:
                                      const AssetImage(AssetConstants.pdf),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => exportToExcel(items),
                                child: CircleAvatar(
                                  radius: deviceWidth * 0.08,
                                  backgroundColor: Pallete.thirdColorMob,
                                  foregroundImage:
                                      const AssetImage(AssetConstants.excel),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.share,
                color: Pallete.secondaryColor,
                size: deviceWidth * 0.055,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              left: deviceWidth * 0.05, right: deviceWidth * 0.05),
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.03,
              ),
              SizedBox(
                height: deviceHeight * 0.1,
                width: deviceWidth,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.025),
                        child: Container(
                          width: deviceWidth * 0.35,
                          // height: deviceHeight * 0.06,
                          color: Pallete.primaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Invoice  No:',
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontSize: deviceWidth * 0.036),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.007,
                              ),
                              Text(
                                sr.saleId,
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth * 0.032),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(deviceWidth * 0.025),
                        child: Container(
                          width: deviceWidth * 0.35,
                          // height: deviceHeight * 0.06,
                          color: Pallete.primaryColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date :",
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontSize: deviceWidth * 0.036),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.007,
                              ),
                              Text(
                                DateFormat.yMMMd().format(sr.saleReturnDate),
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth * 0.032),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: deviceWidth * 0.12,
                    showBottomBorder: true,
                    columns: const [
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('Qty')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows: items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final products = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(SizedBox(
                              height: deviceHeight * 0.1,
                              width: deviceWidth * 0.1,
                              child: Text(products.itemName))),
                          DataCell(SizedBox(
                              height: deviceHeight * 0.1,
                              width: deviceWidth * 0.1,
                              child: Text(products.itemQuantity.toString()))),
                          DataCell(SizedBox(
                              height: deviceHeight * 0.1,
                              width: deviceWidth * 0.1,
                              child:
                                  Text(products.salePrice.toStringAsFixed(2)))),
                          DataCell(SizedBox(
                            height: deviceHeight * 0.1,
                            width: deviceWidth * 0.1,
                            child: Text(
                                (products.itemQuantity * products.salePrice)
                                    .toStringAsFixed(2)),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              ClipPath(
                clipper: PointsClipper(),
                child: Container(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03,
                      top: deviceWidth * 0.05,
                      bottom: deviceWidth * 0.07),
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount',
                              style: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: deviceWidth * 0.25,
                          ),
                          Center(
                            child: Text('₹ ${sr.total}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.dashed,
                                    shadows: [
                                      Shadow(
                                          offset: Offset(0, -5),
                                          color: Pallete.secondaryColor)
                                    ],
                                    color: Colors.transparent,
                                    decorationColor: Pallete.secondaryColor)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: deviceWidth * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Received amount',
                              style: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: deviceWidth * 0.25,
                          ),
                          Text(
                            '₹ ${sr.total}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                                shadows: [
                                  Shadow(
                                      offset: Offset(0, -5),
                                      color: Pallete.secondaryColor)
                                ],
                                color: Colors.transparent,
                                decorationColor: Pallete.secondaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
