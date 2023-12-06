import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';

class AddPurchaseReturnMobile extends ConsumerStatefulWidget {
  final String encode;
  const AddPurchaseReturnMobile({
    super.key,
    required this.encode,
  });

  @override
  ConsumerState<AddPurchaseReturnMobile> createState() =>
      _AddPurchaseReturnMobileState();
}

class _AddPurchaseReturnMobileState
    extends ConsumerState<AddPurchaseReturnMobile> {
  PurchaseModel? purchaseModel;
  int selectedRowIndex = 0;

  List<Map<String, dynamic>> itemsReturned = [];
  List<BillItems> items = [];
  TextEditingController suplierNameController = TextEditingController();
  TextEditingController suplierNumberController = TextEditingController();
  TextEditingController billNo = TextEditingController();

  List<Map<String, dynamic>> addReturns() {
    List<Map<String, dynamic>> itemsReturned1 = [];
    for (var i in itemsReturned) {
      // Find the count of items with the same name
      int count = itemsReturned
          .where((item) => item['itemName'] == i['itemName'])
          .length;

      // Check if the item with the same name is already in itemsReturned1
      bool existsInItemsReturned1 =
          itemsReturned1.any((item) => item['itemName'] == i['itemName']);

      // If it doesn't exist, add it to itemsReturned1
      if (!existsInItemsReturned1) {
        Map<String, dynamic> r = {
          'itemName': i['itemName'],
          'purchasePrice': i['purchasePrice'],
          'itemQuantity': count,
          'total': i['purchasePrice'] * count,
        };
        itemsReturned1.add(r);
      }
    }
    return itemsReturned1;
  }

  void resetState() {
    itemsReturned.clear();
    items.clear();
    suplierNumberController.clear();
    suplierNameController.clear();
    setState(() {});
  }

  getCurrentPurchase(
      {required WidgetRef ref,
      required String spId,
      required String pid}) async {
    purchaseModel = await ref
        .watch(purchaseControlProvider.notifier)
        .getPurchase(spId: spId, pid: pid);
    for (var i in purchaseModel!.products) {
      items.add(BillItems.fromMap(i));
    }
    setState(() {});
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.purchasePrice;
    }
    return total;
  }

  double calculateTotalReturned() {
    double returnTotal = 0;
    for (var item in addReturns()) {
      returnTotal += item['itemQuantity'] * item['purchasePrice'];
    }
    return returnTotal;
  }

  addPurchaseReturn(
      {required String total,
      required WidgetRef ref,
      required String spId,
      required String pid,
      required BuildContext context,
      required String returnedTotal}) {
    PurchaseReturnModel purchaseReturnModel = PurchaseReturnModel(
        purchaseId: pid,
        purchaseReturnId: '',
        purchaseReturnDate: DateTime.now(),
        products: addReturns(),
        total: returnedTotal,
        setSearch: setSearchParam(spId));
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
      itemMap.add(i.toMap());
    }
    PurchaseModel purchases =
        purchaseModel!.copyWith(products: itemMap, totalPrice: total.trim());
    ref.watch(purchaseControlProvider.notifier).addPurchaseReturn(
        spId: spId,
        pid: pid,
        context: context,
        purchaseReturnModel: purchaseReturnModel,
        purchaseModel: purchases);
  }

  @override
  void dispose() {
    suplierNameController.dispose();
    suplierNumberController.dispose();
    billNo.dispose();

    super.dispose();
  }

  void delete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Pallete.primaryColor,
            fontSize: deviceWidth * 0.045),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Pallete.secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.08)),
        actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
        content: SizedBox(
          height: deviceHeight * 0.09,
          width: deviceWidth * 0.3,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Are you sure you want to delete?'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Routemaster.of(context).pop(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
              backgroundColor: Pallete.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.primaryColor)),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
              backgroundColor: Pallete.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                  side: const BorderSide(color: Pallete.secondaryColor)),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Pallete.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decode =
        jsonDecode(Uri.decodeComponent(widget.encode));
    String sid = decode['sid'];
    String uid = decode['uid'];
    bool isLoading = ref.watch(purchaseControlProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Pallete.secondaryColor,
        ),
        title: Text(
          'Purchase Return',
          style: TextStyle(
            color: Pallete.secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: deviceHeight * 0.02,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              left: deviceWidth * 0.05, right: deviceWidth * 0.05),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        width: deviceWidth * 0.37,
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
                              '',
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
                              DateFormat.yMMMd().format(DateTime.now()),
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
              width: deviceWidth,
              height: deviceHeight * 0.07,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  resetState();
                  getCurrentPurchase(
                      ref: ref, pid: billNo.text.trim(), spId: sid);
                },
                controller: billNo,
                autofocus: true,
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
                  hintText: 'Bill Number',
                  hintStyle: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceHeight * 0.02),
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billed items',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: deviceHeight * 0.018),
                ),
                Text(
                  'Total : \u{20b9} ${calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceHeight * 0.018),
                )
              ],
            ),
            SizedBox(
              child: DataTable(
                columnSpacing: deviceWidth * 0.04,
                columns: const [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Remove')),
                  DataColumn(label: Text('price')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('returned')),
                ],
                rows: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: Text(item.itemName))),
                      DataCell(SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: Text(item.itemQuantity.toString()))),
                      DataCell(
                        SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: IconButton(
                              onPressed: () {
                                if (item.itemQuantity > 0) {
                                  item.itemQuantity--;
                                  item.itemReturned++;

                                  // int v=item.quantity--;
                                  itemsReturned.add({
                                    'itemName': item.itemName,
                                    'purchasePrice': item.purchasePrice
                                  });
                                }
                                setState(() {});
                              },
                              icon: const Icon(Icons.remove)),
                        ),
                      ),
                      DataCell(SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: Text(
                              '₹ ${item.purchasePrice.toStringAsFixed(2)}'))),
                      DataCell(
                        SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: Text(
                              ('₹ ${(item.itemQuantity * item.purchasePrice).toStringAsFixed(2)}')),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.1,
                          child: Text((item.itemReturned.toString())),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: deviceHeight * 0.03),
            ClipPath(
              clipper: PointsClipper(),
              child: Container(
                color: Pallete.containerColor,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.035,
                      right: deviceWidth * 0.035,
                      top: deviceWidth * 0.035,
                      bottom: deviceWidth * 0.07),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total  Amount',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceHeight * 0.019,
                                  color: Pallete.secondaryColor)),
                          SizedBox(
                            width: deviceWidth * 0.2,
                          ),
                          SizedBox(
                            width: deviceWidth * 0.3,
                            child: Text(calculateTotal().toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: deviceHeight * 0.018,
                                    decorationStyle: TextDecorationStyle.dashed,
                                    shadows: const [
                                      Shadow(
                                          offset: Offset(0, -5),
                                          color: Pallete.secondaryColor)
                                    ],
                                    color: Colors.transparent,
                                    decorationColor: Pallete.secondaryColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.1,
            )
          ]),
        ),
      ),
      floatingActionButton: SizedBox(
          width: deviceWidth * 0.9,
          height: deviceHeight * 0.07,
          child: Consumer(builder: (context1, ref, child) {
            return FloatingActionButton(
              shape: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(deviceWidth * 0.05)),
              onPressed: () {
                if (itemsReturned.isNotEmpty) {
                  if (purchaseModel != null) {
                    // print(itemsReturned.remove(items[1]));

                    addPurchaseReturn(
                        total: calculateTotal().toString().trim(),
                        ref: ref,
                        spId: sid,
                        pid: billNo.text.trim(),
                        context: context,
                        returnedTotal: calculateTotalReturned().toString());
                  }
                } else {
                  showSnackBar(context,
                      "you didn't updated the returned quantity pls update and try again");
                }
              },
              child: const Text('Save'),
            );
          })),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
