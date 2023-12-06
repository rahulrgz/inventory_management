import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/sale_return_model.dart';
import '../../../../models/sales_model.dart';
import '../../controller/sales_controller.dart';

class AddSaleReturnMobile extends ConsumerStatefulWidget {
  final String encode;
  const AddSaleReturnMobile({
    super.key,
    required this.encode,
  });

  @override
  ConsumerState<AddSaleReturnMobile> createState() =>
      _AddSaleReturnMobileState();
}

class _AddSaleReturnMobileState extends ConsumerState<AddSaleReturnMobile> {
  SalesModel? salesModel;

  List<Map<String, dynamic>> itemsReturned = [];
  List<BillItems> items = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController billNo = TextEditingController();

  List<Map<String, dynamic>> addReturns() {
    List<Map<String, dynamic>> itemsReturned1 = [];
    for (var i in itemsReturned) {
      int count = itemsReturned
          .where((item) => item['itemName'] == i['itemName'])
          .length;

      bool existsInItemsReturned1 =
          itemsReturned1.any((item) => item['itemName'] == i['itemName']);

      if (!existsInItemsReturned1) {
        Map<String, dynamic> r = {
          'itemName': i['itemName'],
          'salePrice': i['salePrice'],
          'itemQuantity': count,
          'total': i['salePrice'] * count,
        };
        itemsReturned1.add(r);
      }
    }
    return itemsReturned1;
  }

  getCurrentSale(
      {required WidgetRef ref,
      required String uid,
      required String spId,
      required String sid}) async {
    salesModel = await ref
        .watch(salesControllerProvider.notifier)
        .getSale(spId: spId, sid: sid);
    items = [];
    itemsReturned = [];
    for (var i in salesModel!.products) {
      items.add(BillItems.fromMap(i));
    }
    setState(() {});
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.salePrice;
    }
    return total;
  }

  double calculateTotalReturned() {
    double returnTotal = 0;
    for (var item in addReturns()) {
      returnTotal += item['itemQuantity'] * item['salePrice'];
    }
    return returnTotal;
  }

  addSalesReturn(
      {required String total,
      required WidgetRef ref,
      required String uid,
      required String spId,
      required String sid,
      required BuildContext context,
      required String returnedTotal}) {
    SaleReturnModel saleReturnModel = SaleReturnModel(
        saleId: sid,
        saleReturnId: '',
        saleReturnDate: DateTime.now(),
        products: addReturns(),
        total: returnedTotal,
        setSearch: setSearchParam(sid.toString()));
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
      itemMap.add(i.toMap());
    }
    SalesModel sales =
        salesModel!.copyWith(products: itemMap, totalPrice: total.trim());
    ref.watch(salesControllerProvider.notifier).addSalesReturn(
        spId: spId,
        sid: sid,
        context: context,
        saleReturnModel: saleReturnModel,
        salesModel: sales);
  }

  void resetState() {
    itemsReturned.clear();
    items.clear();
    customerNumberController.clear();
    customerNameController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerNumberController.dispose();
    billNo.dispose();

    super.dispose();
  }

  void _handleDelete(int index) {
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
              Text('Are you sure you want to delete!'),
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
    bool isLoading = ref.watch(salesControllerProvider);
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
        title: Row(
          children: [
            SizedBox(width: deviceWidth * 0.15),
            Text(
              'Add Sales Return',
              style: TextStyle(
                color: Pallete.secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: deviceHeight * 0.022,
              ),
            ),
            // Add some spacing between Expense and GST
          ],
        ),
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.05, right: deviceWidth * 0.05),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        DateFormat.yMMMd()
                                            .format(DateTime.now()),
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
                            getCurrentSale(
                                ref: ref,
                                uid: uid,
                                spId: sid,
                                sid: billNo.text.trim());
                          },
                          enabled: itemsReturned.isEmpty,
                          controller: billNo,
                          autofocus: true,
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
                            labelText: 'Bill Number',
                            labelStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.035,
                      ),
                      Row(
                        children: [
                          Text(
                            'Billed items',
                            style: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.018,
                                fontWeight: FontWeight.bold),
                          ),
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
                            DataColumn(label: Text('Return')),
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
                                            itemsReturned.add({
                                              'itemName': item.itemName,
                                              'salePrice': item.salePrice
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
                                      '₹ ${item.salePrice.toStringAsFixed(2)}'),
                                )),
                                DataCell(
                                  SizedBox(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.1,
                                    child: Text(
                                        ('₹ ${(item.itemQuantity * item.salePrice).toStringAsFixed(2)}')),
                                  ),
                                ),
                                DataCell(SizedBox(
                                  height: deviceHeight * 0.1,
                                  width: deviceWidth * 0.1,
                                  child: Text(item.itemReturned.toString()),
                                )),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                      SizedBox(height: deviceHeight * 0.02),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total Amount',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: deviceHeight * 0.02,
                                            color: Pallete.secondaryColor)),
                                    SizedBox(
                                      width: deviceWidth * 0.2,
                                    ),
                                    SizedBox(
                                      width: deviceWidth * 0.3,
                                      child: Center(
                                        child: Text(
                                            calculateTotal().toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: deviceHeight * 0.02,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.dashed,
                                                shadows: const [
                                                  Shadow(
                                                      offset: Offset(0, -5),
                                                      color: Pallete
                                                          .secondaryColor)
                                                ],
                                                color: Colors.transparent,
                                                decorationColor:
                                                    Pallete.secondaryColor)),
                                      ),
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
                if (billNo.text.isEmpty) {
                  showSnackBar(context, 'please enter bill number ');
                } else if (itemsReturned.isNotEmpty) {
                  if (salesModel != null) {
                    addSalesReturn(
                        total: calculateTotal().toString().trim(),
                        sid: billNo.text.trim(),
                        uid: uid,
                        spId: sid,
                        ref: ref,
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
