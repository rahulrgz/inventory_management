import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/stock_model.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../stocks/controller/stock_controller.dart';

class AddPurchaseScreenTab extends ConsumerStatefulWidget {
  final String encode;
  const AddPurchaseScreenTab({super.key, required this.encode});
  @override
  ConsumerState<AddPurchaseScreenTab> createState() =>
      _AddPurchaseScreenTabState();
}

class _AddPurchaseScreenTabState extends ConsumerState<AddPurchaseScreenTab> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  List<BillItems> items = [];
  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  String dropdownValueTab = 'Num';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int selectedRowIndex = -1;
  String phNo = '';
  String name1 = '';
  int count = 0;

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

  void addPurchase(
      {required WidgetRef ref,
      required String phone,
      required String total,
      required String name,
      required BuildContext context,
      required String pid,
      required String shopId,
      required List<BillItems> items}) {
    List<Map<String, dynamic>> itemMap = [];
    for (var i in items) {
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
      PurchaseId: [],
    );

    ref.read(purchaseControlProvider.notifier).addPurchase(
        purchaseModel: purchaseModel,
        shopId: shopId,
        supplierModel: supplierModel,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(purchaseControlProvider);
    final Map<String, dynamic> map =
        jsonDecode(Uri.decodeComponent(widget.encode));
    String shopId = map['shopId'];
    String uid = map['uid'];
    return isLoading
        ? const Scaffold(body: Center(child: Loader()))
        : Scaffold(
            key: _key,
            endDrawer: Form(
              key: _formKey1,
              child: SafeArea(
                child: Drawer(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.03,
                        ),
                        Padding(
                          padding: EdgeInsets.all(deviceHeight * 0.025),
                          child: Consumer(
                            builder: (context1, ref, child) {
                              var search = ref.watch(searchProvider);
                              Map<String, dynamic> map = {
                                'uid': uid,
                                'shopId': shopId,
                                'search': search
                              };
                              return ref
                                  .watch(stockStreamProvider(jsonEncode(map)))
                                  .when(
                                      data: (data) =>
                                          RawAutocomplete<StockModel>(
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              itemNameController.text =
                                                  textEditingValue.text;
                                              name1 = textEditingValue.text;
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
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            deviceHeight *
                                                                0.03),
                                                    borderSide: const BorderSide(
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceHeight *
                                                                  0.03),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Pallete
                                                                  .primaryColor)),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceHeight *
                                                                  0.03),
                                                      borderSide: const BorderSide(
                                                          color: Pallete
                                                              .secondaryColor)),
                                                  labelText: 'Product Name',
                                                  labelStyle: const TextStyle(
                                                      color: Pallete
                                                          .secondaryColor),
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
                                                  child: SizedBox(
                                                    height: deviceHeight * 0.3,
                                                    child: ListView.builder(
                                                      physics: const ScrollPhysics(
                                                          parent: BouncingScrollPhysics(
                                                              decelerationRate:
                                                                  ScrollDecelerationRate
                                                                      .normal)),
                                                      padding: EdgeInsets.all(
                                                          deviceWidth * 0.005),
                                                      itemCount: options.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        final StockModel
                                                            option =
                                                            options.elementAt(
                                                                index);
                                                        return Container(
                                                          color: Pallete
                                                              .primaryColor,
                                                          child: ListTile(
                                                            onTap: () {
                                                              count = option
                                                                  .quantity;
                                                              name1 = option
                                                                  .itemName;
                                                              salePriceController
                                                                      .text =
                                                                  option
                                                                      .salePrice
                                                                      .toString();
                                                              purchasePriceController
                                                                      .text =
                                                                  option
                                                                      .purchasePrice
                                                                      .toString();
                                                              setState(() {});
                                                            },
                                                            title: Text(
                                                              option.itemName,
                                                              style: const TextStyle(
                                                                  color: Pallete
                                                                      .blackColor),
                                                            ),
                                                            subtitle: Text(
                                                              'Purchase price : ${option.purchasePrice.toString()}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      deviceWidth *
                                                                          0.015,
                                                                  color: Pallete
                                                                      .blackColor),
                                                            ),
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
                                      loading: () => const Loader());
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: deviceHeight * 0.025,
                                bottom: deviceHeight * 0.025,
                                top: deviceHeight * 0.025,
                              ),
                              child: SizedBox(
                                width: deviceWidth * 0.15,
                                // height: deviceHeight * 0.15,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "please enter product quantity";
                                    } else if (value == '0') {
                                      return 'please enter a valid quantity';
                                    }
                                    return null;
                                  },
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6)
                                  ],
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.all(deviceHeight * 0.03),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Pallete.secondaryColor),
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.03),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.03),
                                          borderSide: const BorderSide(
                                              color: Pallete.primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Pallete.secondaryColor),
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.03),
                                      ),
                                      label: const Text(
                                        'Quantity',
                                        style: TextStyle(
                                            color: Pallete.secondaryColor),
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(deviceHeight * 0.02),
                              child: Consumer(
                                builder: (context, ref, child) {
                                  return SizedBox(
                                    width: deviceWidth * 0.15,
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(
                                              deviceHeight * 0.03),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Pallete.secondaryColor),
                                            borderRadius: BorderRadius.circular(
                                                deviceHeight * 0.03),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Pallete.secondaryColor),
                                            borderRadius: BorderRadius.circular(
                                                deviceHeight * 0.03),
                                          ),
                                          label: const Text(
                                            ' Unit',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor),
                                          )),
                                      dropdownColor: Pallete.primaryColor,
                                      value: dropdownValueTab,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownValueTab = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Num',
                                        'KG',
                                        'G',
                                        'Ltr',
                                        'Mtr'
                                      ].map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(deviceHeight * 0.025),
                          child: TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                            controller: salePriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.03),
                                  borderSide: const BorderSide(
                                      color: Pallete.primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.03),
                                  borderSide: const BorderSide(
                                      color: Pallete.secondaryColor)),
                              labelText: 'Sale Price',
                              labelStyle: const TextStyle(
                                  color: Pallete.secondaryColor),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(deviceHeight * 0.025),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter product purchase price";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            controller: purchasePriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              // alignLabelWithHint: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.03),
                                  borderSide: const BorderSide(
                                      color: Pallete.primaryColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.03),
                                  borderSide: const BorderSide(
                                      color: Pallete.secondaryColor)),
                              labelText: 'Purchase Price',
                              labelStyle: const TextStyle(
                                  color: Pallete.secondaryColor),
                            ),
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.03),
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
                'ADD PURCHASE BILL',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: deviceHeight * 0.1,
                                width: deviceWidth * 0.3,
                                child: ref
                                    .watch(rawAutoFieldSupplierProvider)
                                    .when(
                                        data: (data) =>
                                            RawAutocomplete<SupplierModel>(
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                supplierNumberController.text =
                                                    textEditingValue.text;
                                                phNo = textEditingValue.text;
                                                if (textEditingValue.text ==
                                                        '' ||
                                                    textEditingValue
                                                            .text.length <
                                                        3) {
                                                  return const Iterable<
                                                      SupplierModel>.empty();
                                                } else {
                                                  List<SupplierModel>
                                                      suppliers = [];
                                                  for (var i in data) {
                                                    if (i.phoneNumber.contains(
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
                                                textEditingController.text =
                                                    phNo;
                                                return TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Supplier Phone Number can't be empty !!";
                                                    } else if (value.length <
                                                        10) {
                                                      return "Enter a valid Phone Number";
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      textEditingController,
                                                  focusNode: focusNode,
                                                  autofocus: true,
                                                  maxLength: 10,
                                                  decoration: InputDecoration(
                                                    // alignLabelWithHint: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceHeight *
                                                                  0.015),
                                                      borderSide: const BorderSide(
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
                                                );
                                              },
                                              optionsViewBuilder: (
                                                BuildContext context,
                                                AutocompleteOnSelected<
                                                        SupplierModel>
                                                    onSelected,
                                                Iterable<SupplierModel> options,
                                              ) {
                                                return Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Material(
                                                    elevation: 4.0,
                                                    child: SizedBox(
                                                      height:
                                                          deviceHeight * 0.4,
                                                      width: deviceWidth * 0.2,
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
                                                              option =
                                                              options.elementAt(
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
                                                              phNo = option
                                                                  .phoneNumber;
                                                              setState(() {});
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
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: deviceHeight * 0.1,
                                width: deviceWidth * 0.3,
                                // color: Colors.brown,
                                child: TextFormField(
                                  maxLength: 20,
                                  controller: supplierNameController,
                                  decoration: InputDecoration(
                                      // alignLabelWithHint: true,
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
                                      labelStyle: const TextStyle(
                                          color: Pallete.secondaryColor),
                                      labelText: '  Party Name'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.04,
                        ),
                        SizedBox(
                          width: deviceWidth * 0.64,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invoice No: 21',
                                style: TextStyle(
                                    fontSize: deviceHeight * 0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '18/09/2023 ^',
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
                          height: deviceHeight * 0.55,
                          width: deviceWidth * 0.6,
                          // color: Colors.red,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Item')),
                                DataColumn(label: Text('Qty')),
                                DataColumn(label: Text('Price')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('Delete')),
                              ],
                              rows: items.asMap().entries.map((entry) {
                                final item = entry.value;
                                final index = entry.key;
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item.itemName)),
                                    DataCell(
                                        Text(item.itemQuantity.toString())),
                                    DataCell(Text(
                                        '₹ ${item.purchasePrice.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '₹ ${(item.itemQuantity * item.purchasePrice).toStringAsFixed(2)}')),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            items.removeAt(index);
                                            selectedRowIndex =
                                                -1; // Reset selectedRowIndex after deletion
                                          });
                                        },
                                      ),
                                    ),
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
                        // SlidingSwitch(
                        //   value: false,
                        //   width: deviceWidth * 0.17,
                        //   onChanged: (bool value) {},
                        //   height: deviceHeight * 0.07,
                        //   animationDuration: const Duration(milliseconds: 400),
                        //   onTap: () {},
                        //   onDoubleTap: () {},
                        //   onSwipe: () {},
                        //   textOff: "Non-GST",
                        //   contentSize: deviceHeight * 0.026,
                        //   textOn: "GST",
                        //   colorOn: const Color(0xffdc6c73),
                        //   colorOff: const Color(0xff6682c0),
                        //   background: const Color(0xffe4e5eb),
                        //   buttonColor: const Color(0xfff7f5f7),
                        //   inactiveColor: const Color(0xff636f7b),
                        // ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            _key.currentState!.openEndDrawer();
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: deviceHeight * 0.03),
                            child: Container(
                              height: deviceWidth * 0.05,
                              width: deviceWidth * 0.17,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
                                  border: Border.all(
                                      color: Pallete.secondaryColor)),
                              child: const Center(
                                child: Text(
                                  "Add Item",
                                  style:
                                      TextStyle(color: Pallete.secondaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Consumer(
                          builder: (context1, ref, child) {
                            return InkWell(
                              onTap: () {
                                if (supplierNameController.text
                                    .trim()
                                    .isNotEmpty) {
                                  if (_formKey.currentState!.validate()) {
                                    if (items.isNotEmpty) {
                                      addPurchase(
                                          ref: ref,
                                          phone: supplierNumberController.text
                                              .trim(),
                                          total: calculateTotal().toString(),
                                          name: supplierNameController.text
                                              .trim(),
                                          context: context,
                                          pid: '',
                                          shopId: shopId,
                                          items: items);
                                    } else {
                                      showSnackBar(context,
                                          "pls add item and try again");
                                    }
                                  }
                                } else {
                                  showSnackBar(context, 'please add name');
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: deviceHeight * 0.07),
                                child: Container(
                                  height: deviceWidth * 0.05,
                                  width: deviceWidth * 0.17,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceHeight * 0.02),
                                      border: Border.all(
                                          color: Pallete.secondaryColor),
                                      color: Pallete.secondaryColor),
                                  child: const Center(
                                    child: Text(
                                      "Add",
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
