import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/stock_model.dart';
import '../../../stocks/controller/stock_controller.dart';

class EnterPurchaseScreenMobile extends ConsumerStatefulWidget {
  final String encode;
  const EnterPurchaseScreenMobile({super.key, required this.encode});

  @override
  ConsumerState<EnterPurchaseScreenMobile> createState() =>
      _EnterPurchaseScreenMobileState();
}

class _EnterPurchaseScreenMobileState
    extends ConsumerState<EnterPurchaseScreenMobile> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  List<BillItems> items = [];
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int selectedRowIndex = -1;
  String phNo = '';
  String name1 = '';
  int count = 0;
  String dropdownValueTab = 'N';

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.purchasePrice;
    }
    return total;
  }

  addItemToList() {
    String itemName = itemNameController.text.trim();
    int quantity = int.tryParse(quantityController.text) ?? 0;
    double salePrice = double.tryParse(salePriceController.text) ?? 0.0;
    double purchasePrice = double.tryParse(purchasePriceController.text) ?? 0.0;
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
    quantityController.clear();
    salePriceController.clear();
    purchasePriceController.clear();
  }

  void addPurchase({
    required WidgetRef ref,
    required String phn,
    required String name,
    required String sid,
    required String totalPrice,
    required BuildContext context,
    required List<BillItems> items,
    required String pid,
  }) {
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
      itemMap.add(i.toMap());
    }
    PurchaseModel purchase = PurchaseModel(
        supplierId: phn.trim(),
        id: '',
        name: name.trim(),
        products: itemMap,
        purchaseDate: DateTime.now(),
        totalPrice: totalPrice,
        setSearch: []);
    SupplierModel supplier = SupplierModel(
        name: name.trim(),
        phoneNumber: phn.trim(),
        shopId: [sid],
        setSearch: [],
        createdTime: DateTime.now(),
        deleted: false,
        // supplierProfile: '',
        PurchaseId: []);
    ref.read(purchaseControlProvider.notifier).addPurchase(
          purchaseModel: purchase,
          shopId: sid,
          supplierModel: supplier,
          context: context,
          // uid: ''
        );
    supplierNameController.clear();
    supplierNumberController.clear();
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
            onPressed: () {
              setState(() {
                items.removeAt(index);
                selectedRowIndex = -1; // Reset selectedRowIndex after deletion
              });
              Routemaster.of(context).pop();
            },
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
    bool isLoading = ref.watch(purchaseControlProvider);
    final Map<String, dynamic> map =
        jsonDecode(Uri.decodeComponent(widget.encode));
    String uid = map['uid'];
    String sid = map['sid'];
    return isLoading
        ? Scaffold(
            body: Loader(),
          )
        : Scaffold(
            key: _key,
            resizeToAvoidBottomInset: false,
            endDrawer: Form(
              key: _formKey1,
              child: SafeArea(
                child: Drawer(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                    child: Column(
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.2,
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            var search = ref.watch(searchProvider);
                            Map<String, dynamic> map = {
                              'uid': uid,
                              'shopId': sid,
                              'search': search
                            };
                            return ref
                                .watch(stockStreamProvider(jsonEncode(map)))
                                .when(
                                    data: (data) => RawAutocomplete<StockModel>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            itemNameController.text =
                                                textEditingValue.text;
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  StockModel>.empty();
                                            } else {
                                              List<StockModel> stock = [];
                                              for (var i in data) {
                                                if (i.itemName.contains(
                                                    textEditingValue.text)) {
                                                  stock.add(i);
                                                }
                                              }
                                              return stock;
                                            }
                                          },
                                          fieldViewBuilder: (
                                            BuildContext context,
                                            TextEditingController
                                                itemNameController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted,
                                          ) {
                                            itemNameController.text = name1;
                                            return TextFormField(
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    20)
                                              ],
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "product name cannot be empty";
                                                }
                                                return null;
                                              },
                                              controller: itemNameController,
                                              focusNode: focusNode,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      width:
                                                          deviceWidth * 0.001),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                ),
                                                hintText: 'Product',
                                                hintStyle: TextStyle(
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontSize:
                                                        deviceHeight * 0.02),
                                              ),
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            AutocompleteOnSelected<StockModel>
                                                onSelected,
                                            Iterable<StockModel> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                elevation: 4.0,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.all(
                                                      deviceWidth * 0.005),
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final StockModel option =
                                                        options
                                                            .elementAt(index);
                                                    return ListTile(
                                                      onTap: () {
                                                        count = option.quantity;
                                                        name1 = option.itemName;
                                                        salePriceController
                                                                .text =
                                                            option.salePrice
                                                                .toString();
                                                        purchasePriceController
                                                                .text =
                                                            option.purchasePrice
                                                                .toString();
                                                        setState(() {});
                                                      },
                                                      leading: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(option.itemName),
                                                          Text(
                                                            option.salePrice
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.03),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    error: (error, stackTrace) =>
                                        ErrorText(error: error.toString()),
                                    loading: () => const Loader());
                          },
                        ),
                        SizedBox(height: deviceHeight * 0.015),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter product quantity";
                            } else if (value == '0') {
                              return 'please enter a valid quantity';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          controller: quantityController,
                          keyboardType: TextInputType.number,
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
                            hintText: 'Quantity',
                            hintStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.015),
                        DropdownButtonFormField(
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
                            hintText: 'Unit',
                            hintStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                          dropdownColor: Pallete.primaryColor,
                          value: dropdownValueTab,
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValueTab = newValue!;
                            });
                          },
                          items: <String>['N', 'G', 'KG', 'Ltr', 'Mtr']
                              .map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.015,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter product purchase price";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: purchasePriceController,
                          keyboardType: TextInputType.number,
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
                            hintText: 'Purchase Price',
                            hintStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.015),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'this field cant be empty';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10)
                          ],
                          controller: salePriceController,
                          keyboardType: TextInputType.number,
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
                            hintText: 'Sale Price',
                            hintStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.015),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey1.currentState!.validate()) {
                              // String itemName = itemNameController.text.trim();
                              // int quantity =
                              //     int.tryParse(quantityController.text) ?? 0;
                              // double salePrice =
                              //     double.tryParse(salePriceController.text) ??
                              //         0.0;
                              // double purchasePrice = double.tryParse(
                              //         purchasePriceController.text) ??
                              //     0.0;
                              // if (items.isNotEmpty) {
                              //   bool found = false;
                              //   for (var i in items) {
                              //     if (i.itemName == itemName) {
                              //       setState(() {
                              //         i.itemQuantity = quantity;
                              //         i.purchasePrice = purchasePrice;
                              //         i.salePrice = salePrice;
                              //         i.unit = dropdownValueTab;
                              //         i.total = calculateTotal();
                              //       });
                              //       found = true;
                              //       break;
                              //     }
                              //   }
                              //   if (!found && itemName.isNotEmpty) {
                              //     setState(() {
                              //       items.add(BillItems(
                              //           itemName: itemName,
                              //           itemQuantity: quantity,
                              //           purchasePrice: purchasePrice,
                              //           salePrice: salePrice,
                              //           unit: dropdownValueTab,
                              //           total: calculateTotal(),
                              //           itemReturned: 0));
                              //     });
                              //   }
                              // } else {
                              //   if (itemName.isNotEmpty) {
                              //     setState(() {
                              //       items.add(BillItems(
                              //           itemName: itemName,
                              //           itemQuantity: quantity,
                              //           purchasePrice: purchasePrice,
                              //           salePrice: salePrice,
                              //           unit: dropdownValueTab,
                              //           total: calculateTotal(),
                              //           itemReturned: 0));
                              //     });
                              //   }
                              // }
                              // itemNameController.clear();
                              // name1 = '';
                              // quantityController.clear();
                              // salePriceController.clear();
                              // purchasePriceController.clear();
                              addItemToList();
                              Routemaster.of(context).pop();
                            }
                          },
                          child: const Text('Add Item'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              backgroundColor: Pallete.primaryColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Pallete.secondaryColor,
                ),
              ),
              title: Text(
                'Enter Purchase',
                style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: deviceHeight * 0.023),
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.05, right: deviceWidth * 0.05),
                child: Form(
                  key: _formKey,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          height: deviceHeight * 0.09,
                          child: ref.watch(rawAutoFieldSupplierProvider).when(
                              data: (data) => RawAutocomplete<SupplierModel>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      supplierNumberController.text =
                                          textEditingValue.text;
                                      phNo = textEditingValue.text;
                                      if (textEditingValue.text == '' ||
                                          textEditingValue.text.length < 3) {
                                        return const Iterable<
                                            SupplierModel>.empty();
                                      } else {
                                        List<SupplierModel> suppliers = [];
                                        for (var i in data) {
                                          if (i.phoneNumber.contains(
                                              textEditingValue.text)) {
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
                                      textEditingController.text = phNo;
                                      return TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Supplier Phone Number can't be empty !!";
                                          } else if (value.length < 10) {
                                            return "Enter a valid Phone Number";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        autofocus: false,
                                        maxLength: 10,
                                        decoration: InputDecoration(
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Pallete.secondaryColor,
                                                width: deviceWidth * 0.001),
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.04),
                                          ),
                                          hintText: 'Phone Number',
                                          hintStyle: const TextStyle(
                                              color: Pallete.secondaryColor),
                                        ),
                                      );
                                    },
                                    optionsViewBuilder: (
                                      BuildContext context,
                                      AutocompleteOnSelected<SupplierModel>
                                          onSelected,
                                      Iterable<SupplierModel> options,
                                    ) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: SizedBox(
                                            height: deviceHeight * 0.4,
                                            width: deviceWidth * 0.6,
                                            child: ListView.builder(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final SupplierModel option =
                                                    options.elementAt(index);
                                                return ListTile(
                                                  onTap: () {
                                                    supplierNameController
                                                        .text = option.name;
                                                    supplierNumberController
                                                            .text =
                                                        option.phoneNumber;
                                                    phNo = option.phoneNumber;
                                                    setState(() {});
                                                  },
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(option.name),
                                                      Text(
                                                        option.phoneNumber,
                                                        style: const TextStyle(
                                                            fontSize: 9.1),
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
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader()),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.012,
                        ),
                        SizedBox(
                          width: deviceWidth,
                          height: deviceHeight * 0.09,
                          child: TextFormField(
                            autofocus: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'this field cant be empty';
                              }
                              return null;
                            },
                            controller: supplierNameController,
                            maxLength: 20,
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
                              hintText: 'Suplier Name',
                              hintStyle: const TextStyle(
                                  color: Pallete.secondaryColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        Text(
                          'Billed items',
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: deviceHeight * 0.017),
                        ),
                        SizedBox(
                          child: DataTable(
                            columnSpacing: deviceWidth * 0.08,
                            showBottomBorder: true,
                            columns: const [
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Qty')),
                              DataColumn(label: Text('Price')),
                              DataColumn(label: Text('Total')),
                              DataColumn(label: Text('Delete')),
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
                                      child:
                                          Text(item.itemQuantity.toString()))),
                                  DataCell(SizedBox(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.1,
                                    child: SizedBox(
                                      height: deviceHeight * 0.1,
                                      width: deviceWidth * 0.1,
                                      child: Text(item.purchasePrice
                                          .toStringAsFixed(2)),
                                    ),
                                  )),
                                  DataCell(SizedBox(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.1,
                                    child: Text(
                                        (item.itemQuantity * item.purchasePrice)
                                            .toStringAsFixed(2)),
                                  )),
                                  DataCell(InkWell(
                                      onTap: () {
                                        _handleDelete(index);
                                      },
                                      child: Icon(Icons.delete,
                                          size: deviceWidth * 0.05))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        InkWell(
                          onTap: () {
                            _key.currentState!.openEndDrawer();
                          },
                          child: Container(
                              height: deviceHeight * 0.06,
                              // width: deviceWidth * 0.11,
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 1.0,
                                    spreadRadius: 0.3,
                                  ),
                                ],
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.03),
                                color: Pallete.containerColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: Pallete.secondaryColor,
                                    size: deviceWidth * 0.04,
                                  )),
                                  SizedBox(width: deviceWidth * 0.001),
                                  Text(
                                    'Add Items ',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.04,
                                        color: Pallete.secondaryColor),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        ClipPath(
                          clipper: PointsClipper(),
                          child: Container(
                            color: Pallete.containerColor,
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: deviceWidth * 0.03,
                                  right: deviceWidth * 0.03,
                                  top: deviceWidth * 0.05,
                                  bottom: deviceWidth * 0.07),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Pallete.secondaryColor)),
                                      SizedBox(
                                        width: deviceWidth * 0.2,
                                      ),
                                      SizedBox(
                                        width: deviceWidth * 0.4,
                                        child: Center(
                                          child: Text(
                                              calculateTotal()
                                                  .toStringAsFixed(2),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationStyle:
                                                      TextDecorationStyle
                                                          .dashed,
                                                  shadows: [
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
            ),
            floatingActionButton: Consumer(
              builder: (context1, ref, child) => SizedBox(
                  width: deviceWidth * 0.9,
                  height: deviceHeight * 0.07,
                  child: FloatingActionButton(
                    shape: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius:
                            BorderRadius.circular(deviceWidth * 0.05)),
                    onPressed: () {
                      if (supplierNameController.text.trim().isNotEmpty) {
                        if (_formKey.currentState!.validate()) {
                          if (items.isNotEmpty) {
                            addPurchase(
                                ref: ref,
                                phn: supplierNumberController.text.trim(),
                                name: supplierNameController.text.trim(),
                                sid: sid,
                                totalPrice: calculateTotal().toString(),
                                context: context,
                                pid: '',
                                items: items);
                          } else {
                            showSnackBar(context, "pls add item and try again");
                          }
                        }
                      } else {
                        showSnackBar(context, 'please add name');
                      }
                    },
                    child: const Text('Save'),
                  )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
