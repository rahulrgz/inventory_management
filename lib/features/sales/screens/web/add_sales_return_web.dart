import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/features/sales/controller/sales_controller.dart';
import 'package:inventory_management_shop/models/sale_return_model.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';

class Add_sales_return_web extends StatefulWidget {
  final String shopId;
  const Add_sales_return_web({super.key, required this.shopId});

  @override
  State<Add_sales_return_web> createState() => _Add_sales_return_webState();
}

class _Add_sales_return_webState extends State<Add_sales_return_web> {
  SalesModel? salesModel;

  List<Map<String, dynamic>> itemsReturned = [];
  List<BillItems> items = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController billNo = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;
  final _formKey = GlobalKey<FormState>();

  // List<Map<String,dynamic>> addReturns() {
  //   List<Map<String,dynamic>> itemsReturned1 = [];
  //   for(var i in itemsReturned){
  //     int count=0;
  //     for(var j in itemsReturned){
  //       if(i['name']==j['name']){
  //         count++;
  //       }
  //     }
  //     int c=0;
  //     Map<String,dynamic> r={'name':i['name'],'price':i['price'],'quantity':count,'total':i['price']*count};
  //     for(int k=0;k<itemsReturned1.length;k++){
  //       if(itemsReturned1[k]['name']==r['name']){
  //         c++;
  //       }
  //     }
  //     if(c==0){
  //       itemsReturned1.add(r);
  //     }
  //   }
  //   return itemsReturned1;
  // }

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
        setSearch: setSearchParam(sid));
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

    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  width: deviceWidth * 0.4,
                ),
                Text(
                  " Add Sales Return",
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: deviceWidth * 0.05,
                          ),
                          Consumer(builder: (context, ref, child) {
                            return SizedBox(
                              height: deviceHeight * 0.06,
                              width: deviceWidth * 0.075,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                controller: billNo,
                                onFieldSubmitted: (value) {
                                  getCurrentSale(
                                      ref: ref,
                                      spId: widget.shopId,
                                      sid: billNo.text);
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16.0),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter bill no';
                                  }
                                  return null;
                                },
                              ),
                            );
                          }),
                        ],
                      ),
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
                          "Return No. ",
                          style: TextStyle(
                              fontSize: deviceWidth * 0.0125,
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.025,
                        ),
                        Text(
                          "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                          style: TextStyle(
                              fontSize: deviceWidth * 0.0125,
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Billed Items',
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceWidth * 0.0125)),
                            SizedBox(width: deviceWidth * 0.45),
                            Text(
                              "Total : \u{20B9} ${calculateTotal().toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.0125,
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                                  'Returned',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Pallete.primaryColor),
                                )),
                              ],
                              rows: items.asMap().entries.map((entry) {
                                final index = entry.key;
                                BillItems item = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item.itemName)),
                                    DataCell(
                                        Text(item.itemQuantity.toString())),
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
                                        '\₹ ${item.salePrice.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '\₹ ${(item.itemQuantity * item.salePrice).toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '\₹ ${item.itemReturned.toStringAsFixed(2)}')),
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
                  Consumer(builder: (context1, ref, child) {
                    return GestureDetector(
                      onTap: () {
                        if (itemsReturned.isNotEmpty) {
                          if (salesModel != null) {
                            addSalesReturn(
                                total: calculateTotal().toString(),
                                sid: billNo.text,
                                spId: widget.shopId,
                                ref: ref,
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
