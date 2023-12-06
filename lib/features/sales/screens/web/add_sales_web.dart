import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/sales/screens/web/saleStockWeb.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/customer_model.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/stock_model.dart';
import '../../../stocks/controller/stock_controller.dart';
import '../../controller/sales_controller.dart';

class Add_sales_web extends ConsumerStatefulWidget {
  final String encode;
  const Add_sales_web({super.key, required this.encode});

  @override
  ConsumerState<Add_sales_web> createState() => _Add_sales_webState();
}

class _Add_sales_webState extends ConsumerState<Add_sales_web> {
  List<BillItems> items = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String name1 = '';
  String name2 = '';
  int count = 0;

  addToTable() {
    String itemName = itemNameController.text;
    int itemQuantity = int.tryParse(itemQtyController.text) ?? 0;
    double salePrice = double.tryParse(salePriceController.text) ?? 0.0;
    double total = double.tryParse(totalController.text) ?? 0.0;

    if (itemName.isNotEmpty && itemQuantity > 0 && salePrice > 0) {}
    setState(() {
      items.add(BillItems(
          itemName: itemName.trim(),
          itemQuantity: itemQuantity,
          salePrice: salePrice,
          total: total,
          unit: '',
          purchasePrice: 0.0,
          itemReturned: 0));
      itemNameController.clear();
      itemQtyController.clear();
      salePriceController.clear();
      totalController.clear();
    });
    Routemaster.of(context).pop();
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.salePrice;
    }
    return total;
  }

  void addSale(
      {required WidgetRef ref,
      required String ph,
      required String total,
      required String name,
      required BuildContext context,
      required String sid,
      required List<BillItems> items}) {
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
      itemMap.add(i.toMap());
    }
    SalesModel salesModel = SalesModel(
        saleDate: DateTime.now(),
        id: '',
        products: itemMap,
        customerId: ph.trim(),
        totalPrice: total.trim(),
        name: name.trim(),
        setSearch: []);
    CustomerModel customerModel = CustomerModel(
        createdTime: DateTime.now(),
        deleted: false,
        setSearch: [],
        customerName: name.trim(),
        phoneNumber: ph.trim(),
        saleId: [],
        shopId: [sid]);
    ref.read(salesControllerProvider.notifier).addSales(
        salesModel: salesModel,
        sId: sid,
        customerModel: customerModel,
        context: context);
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerNumberController.dispose();
    itemNameController.dispose();
    itemQtyController.dispose();
    salePriceController.dispose();
    totalController.dispose();
    super.dispose();
  }

  bool selected = false;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    String uid = map['uid'];
    String sid = map['sid'];

    // final uid = ref.watch(userProvider)!.uid;
    bool isLoading = ref.watch(salesControllerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            key: _key,
            endDrawer: Form(
              key: _formKey1,
              child: Drawer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: deviceHeight * 0.19, bottom: deviceWidth * 0.03),
                      child: Container(
                        height: deviceHeight * 0.3,
                        width: deviceWidth * 0.25,
                        child: Lottie.asset(AssetConstants.addItemLottie),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        onTap: () async {
                          var push = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SaleStockWeb(sid: sid, uid: uid)));
                          itemNameController.text =
                              push['itemName'] ?? 'nullitem';
                          count = push['quantity'] ?? 0;
                          salePriceController.text =
                              push['purchasePrice'].toString() ?? '';
                          selected = true;
                          setState(() {});
                        },
                        maxLength: 25,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "product name cannot be empty";
                          }
                          return null;
                        },
                        controller: itemNameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          // alignLabelWithHint: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceHeight * 0.015),
                            borderSide:
                                const BorderSide(color: Pallete.secondaryColor),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          labelText: 'Product Name',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please add the stock first";
                          } else if (double.parse(value) > count) {
                            return 'check the item availability and try again';
                          }
                          return null;
                        },
                        maxLength: 25,
                        controller: itemQtyController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: selected
                              ? 'available$count items'
                              : 'please add the stock first',
                          // alignLabelWithHint: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceHeight * 0.015),
                            borderSide:
                                const BorderSide(color: Pallete.secondaryColor),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),

                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 6,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please add the stock first";
                          }
                          return null;
                        },
                        controller: salePriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // alignLabelWithHint: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceHeight * 0.015),
                            borderSide:
                                const BorderSide(color: Pallete.secondaryColor),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.primaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          labelText: 'Price',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.03),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey1.currentState!.validate()) {
                          if (items.isNotEmpty) {
                            for (var i in items) {
                              if (i.itemName == itemNameController.text) {
                                setState(() {
                                  i.itemQuantity =
                                      int.parse(itemQtyController.text);
                                  i.salePrice =
                                      double.parse(salePriceController.text);
                                  Routemaster.of(context).pop();
                                });
                              } else {
                                String itemName = itemNameController.text;
                                int quantity =
                                    int.tryParse(itemQtyController.text) ?? 0;
                                double price =
                                    double.tryParse(salePriceController.text) ??
                                        0.0;
                                if (itemName.isNotEmpty &&
                                    quantity > 0 &&
                                    price > 0) {
                                  setState(() {
                                    items.add(BillItems(
                                        itemName: itemName.trim(),
                                        itemQuantity: quantity,
                                        salePrice: price,
                                        total: calculateTotal(),
                                        unit: '',
                                        purchasePrice: 0.0,
                                        itemReturned: 0));
                                    itemNameController.clear();
                                    name1 = '';
                                    itemQtyController.clear();
                                    salePriceController.clear();
                                  });
                                  Routemaster.of(context).pop();
                                }
                              }
                            }
                          } else {
                            String itemName = itemNameController.text;
                            int quantity =
                                int.tryParse(itemQtyController.text) ?? 0;
                            double price =
                                double.tryParse(salePriceController.text) ??
                                    0.0;
                            if (itemName.isNotEmpty &&
                                quantity > 0 &&
                                price > 0) {
                              setState(() {
                                items.add(BillItems(
                                    itemName: itemName.trim(),
                                    itemQuantity: quantity,
                                    salePrice: price,
                                    total: calculateTotal(),
                                    unit: '',
                                    purchasePrice: 0.0,
                                    itemReturned: 0));
                                itemNameController.clear();
                                name1 = '';
                                itemQtyController.clear();
                                salePriceController.clear();
                              });
                              Routemaster.of(context).pop();
                            }
                          }
                        }
                      }
                      // {
                      //   if (_formKey1.currentState!.validate()) {
                      //     String itemName = itemNameController.text;
                      //     int quantity =
                      //         int.tryParse(itemQtyController.text) ?? 0;
                      //     double price =
                      //         double.tryParse(salePriceController.text) ?? 0.0;
                      //
                      //     if (itemName.isNotEmpty &&
                      //         quantity > 0 &&
                      //         price > 0) {
                      //       bool itemExists =
                      //           items.any((item) => item.itemName == itemName);
                      //       if (!itemExists) {
                      //         setState(() {
                      //           items.add(BillItems(
                      //               itemName: itemName,
                      //               itemQuantity: quantity,
                      //               salePrice: price,
                      //               total: calculateTotal(),
                      //               unit: '',
                      //               purchasePrice: 0.0,
                      //               itemReturned: 0));
                      //           itemNameController.clear();
                      //           itemQtyController.clear();
                      //           salePriceController.clear();
                      //         });
                      //       } else {
                      //         showSnackBar(context, 'Item alredy added');
                      //       }
                      //     } else {
                      //       showSnackBar(context, 'add Qty ');
                      //     }
                      //     Routemaster.of(context).pop();
                      //   }
                      // },
                      ,
                      child: const Text('Add Item'),
                    ),
                  ],
                ),
              ),
            ),
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
                        " Add Sales",
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
                                  height: deviceHeight * 0.10,
                                  width: deviceWidth * 0.2,
                                  child: TextFormField(
                                    maxLength: 20,
                                    controller: customerNameController,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(16.0),
                                        labelText: 'Customer Name',
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
                                                color:
                                                    Pallete.secondaryColor))),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.02,
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.075,
                                  width: deviceWidth * 0.2,
                                  child: ref
                                      .watch(rawAutoFieldCustomerProvider)
                                      .when(
                                          data: (data) =>
                                              RawAutocomplete<CustomerModel>(
                                                optionsBuilder:
                                                    (TextEditingValue
                                                        textEditingValue) {
                                                  customerNumberController
                                                          .text =
                                                      textEditingValue.text;
                                                  if (textEditingValue.text ==
                                                          '' ||
                                                      textEditingValue
                                                              .text.length <
                                                          10) {
                                                    return const Iterable<
                                                        CustomerModel>.empty();
                                                  } else {
                                                    List<CustomerModel>
                                                        customers = [];
                                                    for (var i in data) {
                                                      if (i.phoneNumber
                                                          .contains(
                                                              textEditingValue
                                                                  .text)) {
                                                        customers.add(i);
                                                      }
                                                    }
                                                    return customers;
                                                  }
                                                },
                                                fieldViewBuilder: (
                                                  BuildContext context,
                                                  TextEditingController
                                                      textEditingController,
                                                  FocusNode focusNode,
                                                  VoidCallback onFieldSubmitted,
                                                ) {
                                                  return TextFormField(
                                                    maxLength: 10,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller:
                                                        textEditingController,
                                                    focusNode: focusNode,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                      // alignLabelWithHint: true,
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                deviceHeight *
                                                                    0.015),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Pallete
                                                                    .secondaryColor),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  deviceHeight *
                                                                      0.015),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Pallete
                                                                      .primaryColor)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  deviceHeight *
                                                                      0.015),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Pallete
                                                                      .secondaryColor)),
                                                      labelText: 'Phone Number',
                                                      labelStyle: const TextStyle(
                                                          color: Pallete
                                                              .secondaryColor),
                                                      // errorText: validatePhoneNumber(textEditingController.text),
                                                    ),
                                                  );
                                                },
                                                optionsViewBuilder: (
                                                  BuildContext context,
                                                  AutocompleteOnSelected<
                                                          CustomerModel>
                                                      onSelected,
                                                  Iterable<CustomerModel>
                                                      options,
                                                ) {
                                                  return Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Material(
                                                      elevation: 4.0,
                                                      child: SizedBox(
                                                        height: deviceHeight *
                                                            0.075,
                                                        width:
                                                            deviceWidth * 0.2,
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          itemCount:
                                                              options.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            final CustomerModel
                                                                option = options
                                                                    .elementAt(
                                                                        index);
                                                            return ListTile(
                                                              onTap: () {
                                                                customerNameController
                                                                        .text =
                                                                    option
                                                                        .customerName;
                                                                customerNumberController
                                                                        .text =
                                                                    option
                                                                        .phoneNumber;
                                                              },
                                                              title: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(option
                                                                      .customerName),
                                                                  Text(
                                                                    option
                                                                        .phoneNumber,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            9),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString()),
                                          loading: () => const Loader()),
                                ),
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
                              ref.watch(salesInvoiceStreamProvider(sid)).when(
                                    data: (data) => Text(
                                      "Invoice No : ${data['saleInvoice']}",
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.0125,
                                          color: Pallete.secondaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    error: (error, stackTrace) =>
                                        ErrorText(error: error.toString()),
                                    loading: () => Loader(),
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
                                        bottomLeft: Radius.circular(
                                            deviceWidth * 0.015),
                                        bottomRight: Radius.circular(
                                            deviceWidth * 0.015)),
                                    border: Border.all(
                                        color: Pallete.secondaryColor)),
                                // color: Colors.red,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    headingRowColor:
                                        const MaterialStatePropertyAll(
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
                                    ],
                                    rows: items.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(item.itemName)),
                                          DataCell(Text(
                                              item.itemQuantity.toString())),
                                          DataCell(Text(
                                              '₹ ${item.salePrice.toStringAsFixed(2)}')),
                                          DataCell(Text(
                                              '₹ ${(item.itemQuantity * item.salePrice).toStringAsFixed(2)}')),
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
                                          //             Routemaster.of(context)
                                          //                 .pop();
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
                        InkWell(
                          onTap: () {
                            _key.currentState!.openEndDrawer();
                            // addItemBox(
                            //     context: context,
                            //     itemName: itemNameController,
                            //     itemPrice: itemPriceController,
                            //     itemQty: itemQtyController,
                            //     addProduct: addToTable
                            // );
                          },
                          child: Container(
                              height: deviceHeight * 0.07,
                              width: deviceWidth * 0.15,
                              decoration: BoxDecoration(
                                color: Pallete.containerColor,
                                border: Border.all(
                                  color: Pallete.secondaryColor, // Border color
                                  width: deviceWidth * 0.001,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: Pallete.secondaryColor,
                                    size: deviceWidth * 0.011,
                                  )),
                                  SizedBox(width: deviceWidth * 0.001),
                                  Text(
                                    'Add Item',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.011,
                                        color: Pallete.secondaryColor),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(width: deviceWidth * 0.01),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (items.isNotEmpty) {
                                addSale(
                                    ref: ref,
                                    ph: customerNumberController.text.trim(),
                                    total: calculateTotal().toString().trim(),
                                    name: customerNameController.text.trim(),
                                    context: context,
                                    sid: sid,
                                    items: items);
                              } else {
                                showSnackBar(context, 'Please add Any items');
                              }
                            } else {
                              showSnackBar(
                                  context, 'please enter phone number');
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
