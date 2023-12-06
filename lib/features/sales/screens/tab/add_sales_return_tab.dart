import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/sale_return_model.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/shope_model.dart';
import '../../controller/sales_controller.dart';

class AddSalesReturnScreenTab extends ConsumerStatefulWidget {
  final String encode;
  const AddSalesReturnScreenTab({super.key, required this.encode});
  @override
  ConsumerState<AddSalesReturnScreenTab> createState() =>
      _AddSalesReturnScreenTabState();
}

class _AddSalesReturnScreenTabState
    extends ConsumerState<AddSalesReturnScreenTab> {
  SalesModel? salesModel;
  List<BillItems> items = [];
  List<Map<String, dynamic>> itemsReturned = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController billNo = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController salesPriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;

  decode() {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    ShopModel shop = ShopModel(
        uid: map['uid'],
        category: map['category'],
        name: map['name'],
        shopId: map['shopId'],
        subscriptionId: map['subscriptionId'],
        createdTime: DateTime.parse(map['createdTime']),
        shopProfile: map['shopProfile'],
        deleted: map['deleted'],
        setSearch: List<String>.from(map['setSearch']),
        accepted: map['accepted'],
        blocked: map['blocked'],
        reason: map['reason'],
        expirationDate: DateTime.now());
    return shop;
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.salePrice;
    }
    return total;
  }

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
        salesModel!.copyWith(products: itemMap, totalPrice: total);
    ref.watch(salesControllerProvider.notifier).addSalesReturn(
        spId: spId,
        sid: sid,
        context: context,
        saleReturnModel: saleReturnModel,
        salesModel: sales);
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerNumberController.dispose();
    billNo.dispose();
    itemNameController.dispose();
    itemQtyController.dispose();
    salesPriceController.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(salesControllerProvider);
    ShopModel shop = decode();
    return isLoading
        ? const Scaffold(body: Loader())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Pallete.primaryColor,
              elevation: 0,
              toolbarHeight: deviceHeight * 0.13,
              leading: IconButton(
                  onPressed: () {
                    Routemaster.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Pallete.secondaryColor,
                  )),
              title: const Text(
                'ADD SALES RETURN',
                style: TextStyle(color: Pallete.secondaryColor),
              ),
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: deviceWidth * 0.05,
                ),
                SizedBox(
                  width: deviceWidth * 0.66,
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.04,
                      ),
                      SizedBox(
                        width: deviceWidth * 0.64,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Date : ${DateFormat('dd-MM-y').format(DateTime.now())}',
                              style: TextStyle(
                                  fontSize: deviceHeight * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Total: ₹ ${calculateTotal().toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: deviceHeight * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      SizedBox(
                        height: deviceHeight * 0.6,
                        width: deviceWidth * 0.6,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Remove')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Total')),
                              // DataColumn(label: Text('Delete')),
                            ],
                            rows: items.asMap().entries.map((entry) {
                              final item = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text(item.itemName)),
                                  DataCell(Text(item.itemQuantity.toString())),
                                  DataCell(
                                    IconButton(
                                        onPressed: () {
                                          if (item.itemQuantity > 0) {
                                            item.itemReturned++;
                                            item.itemQuantity--;
                                            itemsReturned.add({
                                              'itemName': item.itemName,
                                              'salePrice': item.salePrice
                                            });
                                          }
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.remove)),
                                  ),
                                  DataCell(Text(
                                      '₹ ${item.salePrice.toStringAsFixed(2)}')),
                                  DataCell(Text(
                                      '₹ ${(item.itemQuantity * item.salePrice).toStringAsFixed(2)}')),
                                  // DataCell(
                                  //   IconButton(
                                  //     icon: const Icon(Icons.delete),
                                  //     onPressed: () {
                                  //       _handleDelete(index);
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: deviceWidth * 0.06,
                  // color: Colors.blue,
                ),
                SizedBox(
                  width: deviceWidth * 0.2,
                  // color: Colors.yellow,
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceWidth * 0.04,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return Container(
                            height: deviceWidth * 0.05,
                            width: deviceWidth * 0.17,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.02),
                                color: Pallete.primaryColor),
                            child: TextFormField(
                              controller: billNo,
                              onFieldSubmitted: (value) {
                                getCurrentSale(
                                    ref: ref,
                                    spId: shop.shopId,
                                    sid: billNo.text);
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  labelText: 'Bill no...',
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
                        },
                      ),
                      const Spacer(),
                      Consumer(
                        builder: (context1, ref, child) {
                          return InkWell(
                            onTap: () {
                              if (itemsReturned.isNotEmpty) {
                                if (salesModel != null) {
                                  addSalesReturn(
                                      total: calculateTotal().toString(),
                                      sid: billNo.text.trim(),
                                      spId: shop.shopId,
                                      ref: ref,
                                      context: context,
                                      returnedTotal:
                                          calculateTotalReturned().toString());
                                }
                              } else {
                                showSnackBar(context,
                                    "you didn't updated the returned quantity pls update and try again");
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: deviceHeight * 0.08),
                              child: Container(
                                height: deviceWidth * 0.05,
                                width: deviceWidth * 0.17,
                                decoration: BoxDecoration(
                                    color: Pallete.secondaryColor,
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    border: Border.all(
                                        color: Pallete.secondaryColor)),
                                child: const Center(
                                  child: Text(
                                    "Save",
                                    style:
                                        TextStyle(color: Pallete.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
