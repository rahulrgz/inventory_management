import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/features/purchase/screens/tab/purchasereturn_singleview_tab.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/commons/export/export_as_exel.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';

class Add_Purchase_Return_Web extends StatefulWidget {
  final String shopid;
  const Add_Purchase_Return_Web({super.key, required this.shopid});

  @override
  State<Add_Purchase_Return_Web> createState() =>
      _Add_Purchase_Return_WebState();
}

class _Add_Purchase_Return_WebState extends State<Add_Purchase_Return_Web> {
  PurchaseModel? purchaseModel;

  List<Map<String, dynamic>> itemsReturned = [];
  List<BillItems> items = [];
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierNumberController = TextEditingController();
  TextEditingController billNo = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;

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
    supplierNameController.clear();
    supplierNumberController.clear();
    setState(() {});
  }

  // addToTable() {
  //   String itemName = itemNameController.text;
  //   int itemQuantity = int.tryParse(itemQtyController.text) ?? 0;
  //   double purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;
  //   double total = double.tryParse(purchasePriceController.text) ?? 0.0;
  //
  //   if (itemName.isNotEmpty && itemQuantity > 0 && purchasePrice > 0) {}
  //   setState(() {
  //     items.add(BillItems(
  //         itemName: itemName,
  //         itemQuantity: itemQuantity,
  //         salePrice: purchasePrice,
  //         total: total,
  //         unit: '',
  //         purchasePrice: 0.0,
  //         itemReturned: 0));
  //     itemNameController.clear();
  //     itemQtyController.clear();
  //     purchasePriceController.clear();
  //     totalController.clear();
  //   });
  //   Routemaster.of(context).pop();
  // }

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
    supplierNameController.dispose();
    supplierNumberController.dispose();

    totalController.dispose();
    billNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String,dynamic> decode=jsonDecode(Uri.decodeComponent(widget.encode));
    // ShopModel shop=ShopModel(
    //   uid: decode['uid'],
    //   category: decode['category'],
    //   name: decode['name'],
    //   shopId: decode['shopId'],
    //   subscriptionId: decode['subscriptionId'],
    //   createdTime: DateTime.parse(decode['createdTime']),
    //   shopProfile: decode['shopProfile'],
    //   deleted: decode['deleted'],
    //   setSearch: List<String>.from(decode['setSearch']), accepted: decode['accepted'], blocked: decode['blocked'], reason: decode['reason'],
    // );
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: deviceHeight,
          width: deviceWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(children: [
                ElevatedButton(
                  onPressed: () => Routemaster.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.secondaryColor,
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
                SizedBox(
                  width: deviceWidth * 0.4,
                ),
                Text(
                  " Add Purchase Return",
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth * .02,
                      fontWeight: FontWeight.bold),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(builder: (context, ref, child) {
                              return SizedBox(
                                height: deviceHeight * 0.05,
                                width: deviceWidth * 0.075,
                                child: TextFormField(
                                  controller: billNo,
                                  onFieldSubmitted: (value) {
                                    getCurrentPurchase(
                                        ref: ref,
                                        spId: widget.shopid,
                                        pid: billNo.text.trim());
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(16.0),
                                      labelText: 'Bill no',
                                      labelStyle: const TextStyle(
                                          color: Pallete.secondaryColor),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.015),
                                        borderSide: const BorderSide(
                                            color: Pallete.secondaryColor),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                              color: Pallete.primaryColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                              color: Pallete.secondaryColor))),
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: deviceWidth * 0.21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                          style: TextStyle(
                              fontSize: deviceWidth * 0.0125,
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.05,
                          width: deviceWidth * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Billed Items',
                                  style: TextStyle(
                                      color: Pallete.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceWidth * 0.0125)),
                              // SizedBox(width: deviceWidth * 0.4),
                              Text(
                                "Total : \u{20B9} ${calculateTotal().toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.0125,
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.015,
                        ),
                        Container(
                          height: deviceHeight * 0.4,
                          width: deviceWidth * 0.6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(deviceWidth * 0.015),
                                  bottomRight:
                                      Radius.circular(deviceWidth * 0.015)),
                              border:
                                  Border.all(color: Pallete.secondaryColor)),
                          // color: Colors.red,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: const MaterialStatePropertyAll(
                                  Pallete.secondaryColor),
                              columns: const [
                                DataColumn(
                                    label: Text(
                                  'Item',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Qty',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Remove',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Price',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                              ],
                              rows: items.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item.itemName)),
                                    DataCell(
                                        Text(item.itemQuantity.toString())),
                                    DataCell(
                                      IconButton(
                                          onPressed: () {
                                            if (item.itemQuantity > 0) {
                                              item.itemQuantity--;
                                              item.itemReturned++;
                                              itemsReturned.add({
                                                'itemName': item.itemName,
                                                'purchasePrice':
                                                    item.purchasePrice
                                              });
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.remove)),
                                    ),
                                    DataCell(Text(
                                        '\₹ ${item.purchasePrice.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '\₹ ${(item.itemQuantity * item.purchasePrice).toStringAsFixed(2)}')),
                                    DataCell(Text('${item.itemReturned}'))
                                    // DataCell(
                                    //   IconButton(
                                    //     icon: const Icon(Icons.delete),
                                    //     onPressed: () {
                                    //       deleteConfirmBox(
                                    //         context: context,
                                    //         onDelete: () {
                                    //           setState(() {
                                    //             items.removeAt(index);
                                    //             selectedRowIndex = -1;
                                    //             Routemaster.of(context).pop();
                                    //           });
                                    //         },
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: deviceWidth * 0.01),
                  Consumer(builder: (context, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        if (itemsReturned.isNotEmpty) {
                          if (purchaseModel != null) {
                            addPurchaseReturn(
                                total: calculateTotal().toString().trim(),
                                ref: ref,
                                spId: widget.shopid,
                                pid: billNo.text,
                                context: context,
                                returnedTotal:
                                    calculateTotalReturned().toString());
                          }
                        } else {
                          showSnackBar(context, "Please add return any items");
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: deviceWidth * 0.2),
                        child: Container(
                            height: deviceHeight * 0.07,
                            width: deviceWidth * 0.15,
                            decoration: BoxDecoration(
                              color: Pallete.secondaryColor,
                              border: Border.all(
                                color: Pallete.primaryColor, // Border color
                                width: deviceWidth * 0.001,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Save',
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.011,
                                      color: Pallete.primaryColor),
                                )
                              ],
                            )),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
