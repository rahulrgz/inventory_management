import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/sales/controller/sales_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/purchase_model.dart';
import '../../../../models/supplier_model.dart';
import '../../controller/purchase_controller.dart';

class Add_Purchase_web extends ConsumerStatefulWidget {
  final String shopId;
  const Add_Purchase_web({super.key, required this.shopId});

  @override
  ConsumerState<Add_Purchase_web> createState() => _Add_Purchase_webState();
}

class _Add_Purchase_webState extends ConsumerState<Add_Purchase_web> {
  List<BillItems> items = [];
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemQtyController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  String dropdownValueTab = 'Num';
  String phNo = '';
  String name1 = '';
  int count = 0;

  addToTable() {
    String itemName = itemNameController.text;
    int itemQuantity = int.parse(itemQtyController.text) ?? 0;
    double purchasePrice = double.parse(purchasePriceController.text) ?? 0.0;
    double total = double.parse(purchasePriceController.text) ?? 0.0;

    if (itemName.isNotEmpty && itemQuantity > 0 && purchasePrice > 0) {}
    setState(() {
      items.add(BillItems(
          itemName: itemName.trim(),
          itemQuantity: itemQuantity,
          salePrice: purchasePrice,
          total: total,
          unit: dropdownValueTab,
          purchasePrice: purchasePrice,
          itemReturned: 0));
      itemNameController.clear();
      itemQtyController.clear();
      purchasePriceController.clear();
      totalController.clear();
    });
    if (_formKey1.currentState!.validate()) {
      String itemName = itemNameController.text.trim();
      int quantity = int.tryParse(itemQtyController.text) ?? 0;
      double salePrice = double.tryParse(salePriceController.text) ?? 0.0;
      double purchasePrice =
          double.tryParse(purchasePriceController.text) ?? 0.0;
      if (items.isNotEmpty) {
        bool found = false;
        for (var i in items) {
          if (i.itemName == itemName) {
            setState(() {
              i.itemQuantity = quantity;
              i.purchasePrice = purchasePrice;
              i.salePrice = salePrice;
              i.unit = dropdownValueTab;
              i.total = calculateTotal();
            });
            found = true;
            break;
          }
        }
        if (!found && itemName.isNotEmpty) {
          setState(() {
            items.add(BillItems(
                itemName: itemName,
                itemQuantity: quantity,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                unit: dropdownValueTab,
                total: calculateTotal(),
                itemReturned: 0));
          });
        }
      } else {
        if (itemName.isNotEmpty) {
          setState(() {
            items.add(BillItems(
                itemName: itemName,
                itemQuantity: quantity,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                unit: dropdownValueTab,
                total: calculateTotal(),
                itemReturned: 0));
          });
        }
      }
      itemNameController.clear();
      name1 = '';
      itemQtyController.clear();
      salePriceController.clear();
      purchasePriceController.clear();
      Routemaster.of(context).pop();
    }
    Routemaster.of(context).pop();
  }

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.purchasePrice;
    }
    return total;
  }

  void addPurchase(
      {required WidgetRef ref,
      required String phone,
      required String total,
      required String name,
      required BuildContext context,
      required String pid,
      required String shopId,
      required List<BillItems> itemss}) {
    List<Map<String, dynamic>> itemMap = [];
    for (var i in itemss) {
      itemMap.add(i.toMap());
    }
    PurchaseModel purchaseModel = PurchaseModel(
        supplierId: phone.trim(),
        id: '',
        name: name.trim(),
        products: itemMap,
        purchaseDate: DateTime.now(),
        totalPrice: total,
        setSearch: []);
    SupplierModel supplierModel = SupplierModel(
      name: name.trim(),
      phoneNumber: phone.trim(),
      shopId: [shopId],
      setSearch: [],
      createdTime: DateTime.now(),
      deleted: false,
      // supplierProfile: '',
      PurchaseId: [],
      // supplierAddress: ''
    );
    ref.read(purchaseControlProvider.notifier).addPurchase(
        purchaseModel: purchaseModel,
        shopId: shopId,
        supplierModel: supplierModel,
        context: context);
  }

  @override
  void dispose() {
    supplierNameController.dispose();
    supplierNumberController.dispose();
    itemNameController.dispose();
    itemQtyController.dispose();
    purchasePriceController.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> map =
    // jsonDecode(Uri.decodeComponent(widget.encode));
    // String shopId = map['shopId'];
    // String uid = map['uid'];
    final isLoading = ref.watch(purchaseControlProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            key: _formKey1,
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
                        " Add Purchase ",
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
                                  height: deviceHeight * 0.075,
                                  width: deviceWidth * 0.2,
                                  child: TextFormField(
                                    maxLength: 25,
                                    controller: supplierNameController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(16.0),
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
                                              color: Pallete.secondaryColor)),
                                      labelText: 'Supplier Name',
                                      labelStyle: const TextStyle(
                                          color: Pallete.secondaryColor),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a supplier name';
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
                                      .watch(rawAutoFieldSupplierProvider)
                                      .when(
                                          data: (data) =>
                                              RawAutocomplete<SupplierModel>(
                                                optionsBuilder:
                                                    (TextEditingValue
                                                        textEditingValue) {
                                                  supplierNumberController
                                                          .text =
                                                      textEditingValue.text;
                                                  if (textEditingValue.text ==
                                                          '' ||
                                                      textEditingValue
                                                              .text.length <
                                                          5) {
                                                    return const Iterable<
                                                        SupplierModel>.empty();
                                                  } else {
                                                    List<SupplierModel>
                                                        suppliers = [];
                                                    for (var i in data) {
                                                      if (i.phoneNumber
                                                          .contains(
                                                              textEditingValue
                                                                  .text)) {
                                                        suppliers.add(i);
                                                      }
                                                    }
                                                    return suppliers;
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
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    maxLength: 10,
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
                                                    ),
                                                    validator: (value) {
                                                      /// Remove all non-digit characters from the input.
                                                      final cleanedValue =
                                                          value!.replaceAll(
                                                              RegExp(r'[^0-9]'),
                                                              '');
                                                      if (cleanedValue
                                                          .isEmpty) {
                                                        return 'Please enter a phone number';
                                                      } else if (cleanedValue
                                                              .length !=
                                                          10) {
                                                        return 'Phone number must be exactly 10 digits';
                                                      }

                                                      return null;
                                                    },
                                                  );
                                                },
                                                optionsViewBuilder: (
                                                  BuildContext context,
                                                  AutocompleteOnSelected<
                                                          SupplierModel>
                                                      onSelected,
                                                  Iterable<SupplierModel>
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
                                                            final SupplierModel
                                                                option = options
                                                                    .elementAt(
                                                                        index);
                                                            return ListTile(
                                                              onTap: () {
                                                                supplierNameController
                                                                        .text =
                                                                    option.name;
                                                                supplierNumberController
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
                                                                      .name),
                                                                  Text(
                                                                    option
                                                                        .phoneNumber,
                                                                    style: TextStyle(
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
                              ref
                                  .watch(
                                      salesInvoiceStreamProvider(widget.shopId))
                                  .when(
                                    data: (data) => Text(
                                      "Invoice No:${data['purchaseInvoice']} ",
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
                                    columns: [
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
                                          DataCell(Text(
                                              item.itemQuantity.toString())),
                                          DataCell(Text(
                                              '\₹ ${item.purchasePrice.toStringAsFixed(2)}')),
                                          DataCell(Text(
                                              '\₹ ${(item.itemQuantity * item.purchasePrice).toStringAsFixed(2)}')),
                                          DataCell(
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                deleteConfirmBox(
                                                  context: context,
                                                  onDelete: () {
                                                    setState(() {
                                                      items.removeAt(index);
                                                      selectedRowIndex = -1;
                                                      Routemaster.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
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
                            // if (_formKey1.currentState!.validate()) {
                            //   if (items.isNotEmpty) {
                            //     for (var i in items) {
                            //       if (i.itemName == itemNameController.text) {
                            //         items.remove(i);
                            //         // setState(() {
                            //         // i.itemQuantity =
                            //         //     int.parse(quantityController.text);
                            //         // i.salePrice =
                            //         //     double.parse(salePriceController.text);
                            //         // i.purchasePrice = double.parse(
                            //         //     purchasePriceController.text);
                            //         // i.unit = dropdownValueTab;
                            //         // Routemaster.of(context).pop();
                            //         // });
                            //       } else {
                            //         String itemName = itemNameController.text;
                            //         int quantity =
                            //             int.tryParse(itemQtyController.text) ??
                            //                 0;
                            //         double salePrice = double.tryParse(
                            //                 salePriceController.text) ??
                            //             0.0;
                            //         double purchasePrice = double.tryParse(
                            //                 purchasePriceController.text) ??
                            //             0.0;
                            //         if (itemName.isNotEmpty) {
                            //           setState(() {
                            //             items.add(BillItems(
                            //                 itemName: itemName.trim(),
                            //                 itemQuantity: quantity,
                            //                 purchasePrice: purchasePrice,
                            //                 total: calculateTotal(),
                            //                 salePrice: salePrice,
                            //                 unit: dropdownValueTab,
                            //                 itemReturned: 0));
                            //             itemNameController.clear();
                            //             name1 = '';
                            //             itemQtyController.clear();
                            //             salePriceController.clear();
                            //             purchasePriceController.clear();
                            //           });
                            //           Routemaster.of(context).pop();
                            //         }
                            //       }
                            //     }
                            //   } else {
                            //     String itemName = itemNameController.text;
                            //     int quantity =
                            //         int.tryParse(itemQtyController.text) ?? 0;
                            //     double salePrice =
                            //         double.tryParse(salePriceController.text) ??
                            //             0.0;
                            //     double purchasePrice = double.tryParse(
                            //             purchasePriceController.text) ??
                            //         0.0;
                            //     if (itemName.isNotEmpty) {
                            //       setState(() {
                            //         items.add(BillItems(
                            //             itemName: itemName.trim(),
                            //             itemQuantity: quantity,
                            //             purchasePrice: purchasePrice,
                            //             total: calculateTotal(),
                            //             salePrice: salePrice,
                            //             unit: dropdownValueTab,
                            //             itemReturned: 0));
                            //         itemNameController.clear();
                            //         name1 = '';
                            //         itemQtyController.clear();
                            //         salePriceController.clear();
                            //         purchasePriceController.clear();
                            //       });
                            //       Routemaster.of(context).pop();
                            //     }
                            //   }
                            // }

                            addItemBox(
                                context: context,
                                itemName: itemNameController,
                                purchasePrice: purchasePriceController,
                                itemQty: itemQtyController,
                                salePrice: salePriceController,
                                addProduct: addToTable);
                            Routemaster.of(context).pop();
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
                        Consumer(builder: (context1, ref, child) {
                          return GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                if (items.isNotEmpty) {
                                  addPurchase(
                                      ref: ref,
                                      phone:
                                          supplierNumberController.text.trim(),
                                      total: calculateTotal().toString(),
                                      name: supplierNameController.text.trim(),
                                      context: context,
                                      pid: '',
                                      shopId: widget.shopId,
                                      itemss: items);
                                } else {
                                  showSnackBar(
                                      context, "please add item and try again");
                                }
                              } else {
                                showSnackBar(
                                    context, 'please add the product details');
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: deviceWidth * 0.2),
                              child: Container(
                                  height: deviceHeight * 0.07,
                                  width: deviceWidth * 0.15,
                                  decoration: BoxDecoration(
                                    color: Pallete.secondaryColor,
                                    border: Border.all(
                                      color:
                                          Pallete.primaryColor, // Border color
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
