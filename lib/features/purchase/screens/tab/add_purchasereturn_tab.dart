import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/purchase_model.dart';
import '../../../../models/purchase_return_model.dart';
import '../../../../models/shope_model.dart';
import '../../controller/purchase_controller.dart';

class AddPurchaseReturnScreenTab extends ConsumerStatefulWidget {
  final String encode;
  const AddPurchaseReturnScreenTab({super.key, required this.encode});
  @override
  ConsumerState<AddPurchaseReturnScreenTab> createState() =>
      _AddPurchaseReturnScreenTabState();
}

class _AddPurchaseReturnScreenTabState
    extends ConsumerState<AddPurchaseReturnScreenTab> {
  PurchaseModel? purchaseModel;

  List<Map<String, dynamic>> itemsReturned = [];
  List<BillItems> items = [];
  TextEditingController billNo = TextEditingController();
  int selectedRowIndex = -1;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    billNo.dispose();
    super.dispose();
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

  addPurchaseReturn({
    required String total,
    required WidgetRef ref,
    required String spId,
    required String pid,
    required BuildContext context,
    required String returnedTotal,
  }) {
    PurchaseReturnModel purchaseReturnModel = PurchaseReturnModel(
        purchaseId: pid,
        purchaseReturnId: '',
        purchaseReturnDate: DateTime.now(),
        products: addReturns(),
        total: returnedTotal,
        setSearch: setSearchParam(pid.toString()));
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
      itemMap.add(i.toMap());
    }
    PurchaseModel purchases =
        purchaseModel!.copyWith(products: itemMap, totalPrice: total);
    ref.watch(purchaseControlProvider.notifier).addPurchaseReturn(
        spId: spId,
        pid: pid,
        context: context,
        purchaseReturnModel: purchaseReturnModel,
        purchaseModel: purchases);
  }

  getCurrentPurchase(
      {required WidgetRef ref,
      required String spId,
      required String pid}) async {
    purchaseModel = await ref
        .watch(purchaseControlProvider.notifier)
        .getPurchase(spId: spId, pid: pid);
    items = [];
    itemsReturned = [];
    for (var i in purchaseModel!.products) {
      items.add(BillItems.fromMap(i));
    }
    setState(() {});
  }

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
          'purchasePrice': i['purchasePrice'],
          'itemQuantity': count,
          'total': i['purchasePrice'] * count,
        };
        itemsReturned1.add(r);
      }
    }
    return itemsReturned1;
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(purchaseControlProvider);
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
                'ADD PURCHASE RETURN',
                style: TextStyle(color: Pallete.secondaryColor),
              ),
            ),
            body: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: deviceWidth * 0.05,
                    // color: Colors.red,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.66,
                    // color: Colors.green,
                    child: Column(
                      children: [
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
                                'Total : ₹ ${calculateTotal().toStringAsFixed(2)}',
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
                              columnSpacing: deviceWidth * 0.04,
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Qty')),
                                DataColumn(label: Text('Remove')),
                                DataColumn(label: Text('Price')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('Returned')),
                              ],
                              rows: items.asMap().entries.map((entry) {
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
                                                    item.purchasePrice,
                                              });
                                            }
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.remove)),
                                    ),
                                    DataCell(Text(
                                        '₹ ${item.purchasePrice.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '₹ ${(item.itemQuantity * item.purchasePrice).toStringAsFixed(2)}')),
                                    DataCell(Text('${item.itemReturned}')),
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
                          height: deviceHeight * 0.02,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return Container(
                              height: deviceWidth * 0.05,
                              width: deviceWidth * 0.17,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
                                  color: Pallete.primaryColor),
                              child: TextFormField(
                                controller: billNo,
                                onFieldSubmitted: (value) {
                                  getCurrentPurchase(
                                      ref: ref,
                                      spId: shop.shopId,
                                      pid: billNo.text);
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.all(deviceHeight * 0.025),
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
                                  if (purchaseModel != null) {
                                    addPurchaseReturn(
                                        total: calculateTotal().toString(),
                                        ref: ref,
                                        spId: shop.shopId,
                                        pid: billNo.text.trim(),
                                        context: context,
                                        returnedTotal: calculateTotalReturned()
                                            .toString());
                                  }
                                } else {
                                  showSnackBar(context,
                                      "you didn't updated the returned quantity pls update and try again");
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: deviceHeight * 0.08),
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
                                      style: TextStyle(
                                          color: Pallete.primaryColor),
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
            ),
          );
  }
}
