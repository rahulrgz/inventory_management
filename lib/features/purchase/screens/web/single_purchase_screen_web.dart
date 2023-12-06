import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:inventory_management_shop/core/commons/alert_dialog_boxes_web.dart';
import 'package:inventory_management_shop/models/billitem_model.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

class SinglePurchaseScreenWeb extends StatefulWidget {
  final String shopId;
  final String purchaseEncode;
  const SinglePurchaseScreenWeb(
      {Key? key, required this.shopId, required this.purchaseEncode})
      : super(key: key);

  @override
  State<SinglePurchaseScreenWeb> createState() =>
      _SinglePurchaseScreenWebState();
}

class _SinglePurchaseScreenWebState extends State<SinglePurchaseScreenWeb> {
  TextEditingController supplierName = TextEditingController();
  TextEditingController paymentMode = TextEditingController();
  TextEditingController billDate = TextEditingController();

  List<BillItems> toBillItems({required PurchaseModel purchase}) {
    List<BillItems> items = [];
    for (var i in purchase.products) {
      items.add(BillItems.fromMap(i));
    }
    return items;
  }

  @override
  void initState() {
    Map<String, dynamic> map =
        jsonDecode(Uri.decodeComponent(widget.purchaseEncode));
    String name = map['name'];
    DateTime date = DateTime.parse(map['purchaseDate']);
    String payment = 'Cash';
    supplierName = TextEditingController(text: name);
    paymentMode = TextEditingController(text: payment);
    billDate = TextEditingController(text: date.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final decode = jsonDecode(Uri.decodeComponent(widget.purchaseEncode));

    PurchaseModel purchaseModel = PurchaseModel(
        supplierId: decode['sid'],
        id: decode['id'],
        name: decode['name'],
        products: List<Map<String, dynamic>>.from(decode['products']),
        purchaseDate: DateTime.parse(decode['purchaseDate']),
        totalPrice: decode['total'],
        setSearch: []);
    List<BillItems> items = toBillItems(purchase: purchaseModel);

    return Scaffold(
      body: Column(
        children: [
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
                    "Purchase",
                    style: TextStyle(
                        color: Pallete.secondaryColor,
                        fontSize: deviceWidth * .02,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.05,
                    width: deviceWidth * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: Pallete.secondaryColor,
                          iconSize: deviceWidth * 0.02,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.ellipsis_vertical),
                          color: Pallete.secondaryColor,
                          iconSize: deviceWidth * 0.02,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.045,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Bill No.",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: deviceWidth * 0.012,
                          color: Pallete.secondaryColor),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.04,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '1',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: deviceWidth * 0.012,
                                color: Pallete.secondaryColor),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: deviceWidth * 0.0125,
                            color: Pallete.secondaryColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  color: Pallete.secondaryColor,
                  width: deviceWidth * 0.015,
                ),
                Text(
                  'Date\n${purchaseModel.purchaseDate.toString()}',
                  style: TextStyle(
                      fontSize: deviceWidth * 0.012,
                      fontWeight: FontWeight.w600,
                      color: Pallete.secondaryColor),
                )
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                height: deviceHeight * 0.6,
                width: deviceWidth * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DataTable(
                      columnSpacing: deviceWidth * 0.08,
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
                            DataCell(Text(products.itemName)),
                            DataCell(Text(products.itemQuantity.toString())),
                            DataCell(Text(
                                products.purchasePrice.toStringAsFixed(2))),
                            DataCell(Text(
                                (products.itemQuantity * products.purchasePrice)
                                    .toStringAsFixed(2))),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.5,
                width: deviceWidth * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipPath(
                      clipper: PointsClipper(),
                      child: Container(
                        height: deviceHeight * 0.25,
                        width: deviceWidth * 0.35,
                        color: Pallete.containerColor,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceWidth * 0.015,
                                  right: deviceWidth * 0.015,
                                  left: deviceWidth * 0.015),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Total Amount"),
                                  Text(
                                      "\₹ ${purchaseModel.totalPrice}\n-----------------"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceWidth * 0.015,
                                  right: deviceWidth * 0.015,
                                  left: deviceWidth * 0.015),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Recieved Amount"),
                                  Text(
                                      "\₹ ${purchaseModel.totalPrice}\n-----------------"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
