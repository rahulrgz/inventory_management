import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/sales/screens/tab/saleStockTab.dart';
import 'package:inventory_management_shop/features/stocks/controller/stock_controller.dart';
import 'package:inventory_management_shop/models/stock_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/customer_model.dart';
import '../../../../models/sales_model.dart';
import '../../controller/sales_controller.dart';

class AddSalesScreenTab extends ConsumerStatefulWidget {
  final String encode;
  const AddSalesScreenTab({super.key, required this.encode});

  @override
  ConsumerState<AddSalesScreenTab> createState() => _AddSalesScreenTabState();
}

class _AddSalesScreenTabState extends ConsumerState<AddSalesScreenTab> {
  List<BillItems> items = [];
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController salesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String name1 = '';
  String phNo = '';
  int count = 0;
  int selectedRowIndex = -1;

  double calculateTotal() {
    double total = 0;
    for (var item in items) {
      total += item.itemQuantity * item.salePrice;
    }
    return total;
  }

  void addItemToItemsList() {
    String itemName = itemNameController.text.trim();
    int quantity = int.tryParse(quantityController.text) ?? 0;
    double price = double.tryParse(salesController.text) ?? 0.0;
    bool itemExists = false;

    for (var i in items) {
      if (i.itemName == itemName) {
        setState(() {
          i.itemQuantity = quantity;
          i.salePrice = price;
          itemExists = true;
        });
        break;
      }
    }

    if (!itemExists && itemName.isNotEmpty && quantity > 0 && price > 0) {
      setState(() {
        items.add(BillItems(
            itemName: itemName,
            itemQuantity: quantity,
            salePrice: price,
            total: calculateTotal(),
            unit: '',
            purchasePrice: 0.0,
            itemReturned: 0));
        itemNameController.clear();
        name1 = '';
        quantityController.clear();
        salesController.clear();
      });
    }
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
        products: itemMap,
        customerId: ph.trim(),
        totalPrice: total.trim(),
        name: name,
        id: '',
        setSearch: []);
    CustomerModel customerModel = CustomerModel(
      setSearch: [],
      deleted: false,
      createdTime: DateTime.now(),
      customerName: name.trim(),
      phoneNumber: ph.trim(),
      saleId: [],
      shopId: [sid],
    );
    ref.read(salesControllerProvider.notifier).addSales(
        salesModel: salesModel,
        sId: sid,
        customerModel: customerModel,
        context: context);
  }

  bool selected = false;

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(salesControllerProvider);
    final Map<String, dynamic> map =
        jsonDecode(Uri.decodeComponent(widget.encode));
    String uid = map['uid'];
    String sid = map['shopId'];
    return isLoading
        ? const Scaffold(body: Loader())
        : Scaffold(
            key: _key,
            endDrawer: Form(
              key: _formKey1,
              child: SafeArea(
                child: Drawer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(deviceHeight * 0.03),
                        child: TextFormField(
                          onTap: () async {
                            var push = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaleStockScreenTab(
                                        uid: uid, sid: sid)));
                            itemNameController.text =
                                push['itemName'] ?? 'nulitem';
                            count = push['quantity'] ?? 0;
                            salesController.text =
                                push['purchasePrice'].toString() ?? '';
                            selected = true;
                            setState(() {});
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "product name cannot be empty";
                            }
                            return null;
                          },
                          controller: itemNameController,
                          autofocus: false,
                          decoration: InputDecoration(
                            // alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.03),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.primaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            labelText: 'Product Name',
                            labelStyle:
                                const TextStyle(color: Pallete.secondaryColor),
                          ),
                        ),
                      ),
                      // Consumer(
                      //   builder: (context, ref, child) {
                      //     Map<String, dynamic> map = {
                      //       'uid': uid,
                      //       'shopId': sid
                      //     };
                      //     return ref
                      //         .watch(stockStreamProvider(jsonEncode(map)))
                      //         .when(
                      //             data: (data) => RawAutocomplete<StockModel>(
                      //                   optionsBuilder: (TextEditingValue
                      //                       textEditingValue) {
                      //                     itemNameController.text =
                      //                         textEditingValue.text;
                      //                     name1 = textEditingValue.text;
                      //                     if (textEditingValue.text == '') {
                      //                       return const Iterable<
                      //                           StockModel>.empty();
                      //                     } else {
                      //                       List<StockModel> stock = [];
                      //                       for (var i in data) {
                      //                         if (i.itemName.contains(
                      //                             textEditingValue.text)) {
                      //                           stock.add(i);
                      //                         }
                      //                       }
                      //                       return stock;
                      //                     }
                      //                   },
                      //                   fieldViewBuilder: (
                      //                     BuildContext context,
                      //                     TextEditingController
                      //                         itemNameController,
                      //                     FocusNode focusNode,
                      //                     VoidCallback onFieldSubmitted,
                      //                   ) {
                      //                     itemNameController.text = name1;
                      //                     return
                      //                   },
                      //                   optionsViewBuilder: (
                      //                     BuildContext context,
                      //                     AutocompleteOnSelected<StockModel>
                      //                         onSelected,
                      //                     Iterable<StockModel> options,
                      //                   ) {
                      //                     return Align(
                      //                       alignment: Alignment.topLeft,
                      //                       child: Material(
                      //                         elevation: 5.0,
                      //                         child: SizedBox(
                      //                           height: deviceHeight * 0.3,
                      //                           child: ListView.builder(
                      //                             padding: EdgeInsets.all(
                      //                                 deviceWidth * 0.005),
                      //                             itemCount: options.length,
                      //                             itemBuilder:
                      //                                 (BuildContext context,
                      //                                     int index) {
                      //                               final StockModel option =
                      //                                   options
                      //                                       .elementAt(index);
                      //                               return Container(
                      //                                 color:
                      //                                     Pallete.primaryColor,
                      //                                 child: ListTile(
                      //                                   onTap: () {
                      //                                     count =
                      //                                         option.quantity;
                      //                                     name1 =
                      //                                         option.itemName;
                      //                                     salesController.text =
                      //                                         option.salePrice
                      //                                             .toString();
                      //                                     setState(() {});
                      //                                   },
                      //                                   title: Text(
                      //                                     option.itemName,
                      //                                     style: const TextStyle(
                      //                                         color: Pallete
                      //                                             .blackColor),
                      //                                   ),
                      //                                   subtitle: Text(
                      //                                     'Sale price : ${option.salePrice.toString()}',
                      //                                     style: TextStyle(
                      //                                         fontSize:
                      //                                             deviceWidth *
                      //                                                 0.015,
                      //                                         color: Pallete
                      //                                             .blackColor),
                      //                                   ),
                      //                                 ),
                      //                               );
                      //                             },
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),
                      //             error: (error, stackTrace) =>
                      //                 ErrorText(error: error.toString()),
                      //             loading: () => const Loader());
                      //   },
                      // ),
                      Padding(
                        padding: EdgeInsets.all(deviceHeight * 0.03),
                        child: SizedBox(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please add the stock first";
                              } else if (double.parse(value) > count) {
                                return 'check the item availability and try again';
                              }
                              return null;
                            },
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: selected
                                  ? 'available $count items'
                                  : 'please add the stock first',
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

                              labelStyle: const TextStyle(
                                  color: Pallete.secondaryColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(deviceHeight * 0.03),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please add the stock first";
                            }
                            return null;
                          },
                          controller: salesController,
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
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.primaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            labelText: 'Sale Price',
                            labelStyle:
                                const TextStyle(color: Pallete.secondaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey1.currentState!.validate()) {
                            // String itemName = itemNameController.text.trim();
                            // int quantity =
                            //     int.tryParse(quantityController.text) ?? 0;
                            // double price =
                            //     double.tryParse(salesController.text) ?? 0.0;
                            // bool itemExists = false;
                            // for (var i in items) {
                            //   if (i.itemName == itemName) {
                            //     setState(() {
                            //       i.itemQuantity = quantity;
                            //       i.salePrice = price;
                            //       itemExists = true;
                            //     });
                            //     break;
                            //   }
                            // }
                            //
                            // if (!itemExists &&
                            //     itemName.isNotEmpty &&
                            //     quantity > 0 &&
                            //     price > 0) {
                            //   setState(() {
                            //     items.add(BillItems(
                            //         itemName: itemName,
                            //         itemQuantity: quantity,
                            //         salePrice: price,
                            //         total: calculateTotal(),
                            //         unit: '',
                            //         purchasePrice: 0.0,
                            //         itemReturned: 0));
                            //     itemNameController.clear();
                            //     name1 = '';
                            //     quantityController.clear();
                            //     salesController.clear();
                            //   });
                            // }
                            addItemToItemsList();
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
                'ADD SALES BILL',
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
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: deviceHeight * 0.11,
                                width: deviceWidth * 0.3,
                                child: ref
                                    .watch(rawAutoFieldCustomerProvider)
                                    .when(
                                        data: (data) =>
                                            RawAutocomplete<CustomerModel>(
                                              optionsBuilder: (TextEditingValue
                                                  textEditingValue) {
                                                customerNumberController.text =
                                                    textEditingValue.text;
                                                phNo = textEditingValue.text;
                                                if (textEditingValue.text ==
                                                        '' ||
                                                    textEditingValue
                                                            .text.length <
                                                        3) {
                                                  return const Iterable<
                                                      CustomerModel>.empty();
                                                } else {
                                                  List<CustomerModel>
                                                      customers = [];
                                                  for (var i in data) {
                                                    if (i.phoneNumber.contains(
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
                                                textEditingController.text =
                                                    phNo;
                                                return TextFormField(
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Customer Phone Number can't be empty !!!";
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
                                                  autofocus: false,
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
                                                        CustomerModel>
                                                    onSelected,
                                                Iterable<CustomerModel> options,
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
                                                          final CustomerModel
                                                              option =
                                                              options.elementAt(
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
                                            ErrorText(error: error.toString()),
                                        loading: () => const Loader()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SizedBox(
                                height: deviceHeight * 0.11,
                                width: deviceWidth * 0.3,
                                // color: Colors.brown,
                                child: TextFormField(
                                  autofocus: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Customer name cannot be empty";
                                    }
                                    return null;
                                  },
                                  controller: customerNameController,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                              color: Pallete.secondaryColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                              color: Pallete.secondaryColor)),
                                      border: OutlineInputBorder(
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
                                'Invoice No: S..',
                                style: TextStyle(
                                    fontSize: deviceHeight * 0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                DateFormat('E,d MMM').format(DateTime.now()),
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
                          height: deviceHeight * 0.5,
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
                                        '₹ ${item.salePrice.toStringAsFixed(2)}')),
                                    DataCell(Text(
                                        '₹ ${(item.itemQuantity * item.salePrice).toStringAsFixed(2)}')),
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
                  SizedBox(
                    width: deviceWidth * 0.06,
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
                        //   textOn: "GST BILL",
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
                                if (_formKey.currentState!.validate()) {
                                  if (items.isNotEmpty) {
                                    addSale(
                                        ref: ref,
                                        ph: customerNumberController.text
                                            .trim(),
                                        total:
                                            calculateTotal().toString().trim(),
                                        name:
                                            customerNameController.text.trim(),
                                        context: context,
                                        sid: sid,
                                        items: items);
                                  } else {
                                    showSnackBar(
                                        context, "pls add item and try again");
                                  }
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
