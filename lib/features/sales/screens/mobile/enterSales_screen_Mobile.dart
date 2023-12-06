import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/sales/screens/mobile/saleStockSreen.dart';
import 'package:inventory_management_shop/models/sales_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/billitem_model.dart';
import '../../../../models/customer_model.dart';
import '../../../../models/stock_model.dart';
import '../../../stocks/controller/stock_controller.dart';
import '../../controller/sales_controller.dart';

class EnterSalesMobile extends ConsumerStatefulWidget {
  final String encode;

  const EnterSalesMobile({super.key, required this.encode});

  @override
  ConsumerState<EnterSalesMobile> createState() => _EnterSalesMobileState();
}

class _EnterSalesMobileState extends ConsumerState<EnterSalesMobile> {
//

  //

  List<BillItems> items = [];
  TextEditingController partyNameController = TextEditingController();
  TextEditingController partyNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController salepriceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  int selectedRowIndex = -1;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String name1 = '';
  String name2 = '';
  int count = 0;

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
        products: itemMap,
        customerId: ph.trim(),
        totalPrice: total.trim(),
        name: name.trim(),
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
    partyNumberController.clear();
    partyNameController.clear();
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

  CustomerModel? customer;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    String uid = map['uid'];
    String sid = map['sid'];
    bool isLoading = ref.watch(salesControllerProvider);
    return isLoading
        ? const Scaffold(
            body: Center(
              child: Loader(),
            ),
          )
        : Scaffold(
            key: _key,
            resizeToAvoidBottomInset: false,
            endDrawer: Form(
              key: _formKey1,
              child: SafeArea(
                child: Drawer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.2,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          maxLength: 25,
                          controller: itemNameController,
                          onTap: () async {
                            // Show the list of stock items as ListTile widgets
                            var push = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SaleStockScreen(
                                    sid: sid,
                                    uid: uid,
                                  ),
                                ));

                            itemNameController.text =
                                push['itemName'] ?? 'nuulItem';
                            count = push['quantity'] ?? 0;
                            salepriceController.text =
                                push['purchasePrice'].toString() ?? '';
                            selected = true;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            // alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide:
                                  const BorderSide(color: Pallete.primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                            ),
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
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: selected
                                ? 'available $count items'
                                : 'please add the stock first"',
                            // alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
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
                            labelText: 'Quantity',
                            labelStyle:
                                const TextStyle(color: Pallete.secondaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please add the stock first";
                            }
                            return null;
                          },
                          controller: salepriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            // alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.015),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey1.currentState!.validate()) {
                                if (items.isNotEmpty) {
                                  for (var i in items) {
                                    if (i.itemName == itemNameController.text) {
                                      setState(() {
                                        i.itemQuantity =
                                            int.parse(quantityController.text);
                                        i.salePrice = double.parse(
                                            salepriceController.text);
                                        Routemaster.of(context).pop();
                                      });
                                      showSnackBar(context, 'items added');
                                    } else {
                                      String itemName = itemNameController.text;
                                      int quantity = int.tryParse(
                                              quantityController.text) ??
                                          0;
                                      double price = double.tryParse(
                                              salepriceController.text) ??
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
                                          quantityController.clear();
                                          salepriceController.clear();
                                        });
                                        Routemaster.of(context).pop();
                                      } else {
                                        itemName.isEmpty
                                            ? showSnackBar(
                                                context, 'please add item name')
                                            : quantity <= 0
                                                ? showSnackBar(context,
                                                    'please addd quantity')
                                                : showSnackBar(context,
                                                    'please add price');
                                      }
                                    }
                                  }
                                } else {
                                  String itemName = itemNameController.text;
                                  int quantity =
                                      int.tryParse(quantityController.text) ??
                                          0;
                                  double price = double.tryParse(
                                          salepriceController.text) ??
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
                                      quantityController.clear();
                                      salepriceController.clear();
                                    });
                                    Routemaster.of(context).pop();
                                  }
                                }
                              }
                            },
                            child: const Text('Add Item'),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.01,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Routemaster.of(context).pop();
                            },
                            child: const Text('cancel'),
                          ),
                        ],
                      ),
                    ],
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
                icon: const Icon(Icons.arrow_back),
                color: Pallete.secondaryColor,
              ),
              title: Text(
                'Sales',
                style: TextStyle(
                  color: Pallete.secondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: deviceWidth * 0.05,
                ),
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
                        height: deviceHeight * 0.09,
                        child: ref.watch(rawAutoFieldCustomerProvider).when(
                            data: (data) => RawAutocomplete<CustomerModel>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    partyNumberController.text =
                                        textEditingValue.text;
                                    if (textEditingValue.text == '' ||
                                        textEditingValue.text.length < 10) {
                                      return const Iterable<
                                          CustomerModel>.empty();
                                    } else {
                                      List<CustomerModel> customers = [];
                                      for (var i in data) {
                                        if (i.phoneNumber
                                            .contains(textEditingValue.text)) {
                                          customers.add(i);
                                        }
                                      }
                                      return customers;
                                    }
                                  },
                                  fieldViewBuilder: (
                                    BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted,
                                  ) {
                                    return TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'This field cant be empty';
                                        } else if (value.length < 10) {
                                          return 'Enter a valid phone number';
                                        } else {
                                          return null;
                                        }
                                      },
                                      maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      controller: textEditingController,
                                      focusNode: focusNode,
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
                                        focusedErrorBorder: OutlineInputBorder(
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
                                        hintStyle: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceHeight * 0.02),
                                      ),
                                    );
                                  },
                                  optionsViewBuilder: (
                                    BuildContext context,
                                    AutocompleteOnSelected<CustomerModel>
                                        onSelected,
                                    Iterable<CustomerModel> options,
                                  ) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: SizedBox(
                                          height: deviceHeight * 0.2,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(8.0),
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final CustomerModel option =
                                                  options.elementAt(index);
                                              return GestureDetector(
                                                onTap: () {
                                                  // onSelected(option);
                                                  partyNameController.text =
                                                      option.customerName;
                                                  partyNumberController.text =
                                                      option.phoneNumber;
                                                  customer = option;
                                                },
                                                child: ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(option.customerName),
                                                      Text(
                                                        option.phoneNumber,
                                                        style: TextStyle(
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.015),
                                                      ),
                                                    ],
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
                            loading: () => const Loader()),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.01,
                      ),
                      SizedBox(
                        width: deviceWidth,
                        height: deviceHeight * 0.09,
                        child: TextFormField(
                          maxLength: 20,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'this field cant be empty';
                            }
                            return null;
                          },
                          controller: partyNameController,
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
                            hintText: 'Customer Name',
                            hintStyle: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceHeight * 0.02),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.02,
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
                          columnSpacing: deviceWidth * 0.1,
                          columns: [
                            const DataColumn(label: Text('Item')),
                            const DataColumn(label: Text('Qty')),
                            const DataColumn(label: Text('Price')),
                            const DataColumn(label: Text('Total')),
                            DataColumn(
                                label: Icon(
                              Icons.delete,
                              size: deviceWidth * 0.05,
                            )),
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
                                DataCell(SizedBox(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.1,
                                    child: Text(
                                        item.salePrice.toStringAsFixed(2)))),
                                DataCell(SizedBox(
                                  height: deviceHeight * 0.1,
                                  width: deviceWidth * 0.1,
                                  child: Text(
                                      (item.itemQuantity * item.salePrice)
                                          .toStringAsFixed(2)),
                                )),
                                DataCell(SizedBox(
                                  height: deviceHeight * 0.1,
                                  width: deviceWidth * 0.1,
                                  child: InkWell(
                                      onTap: () {
                                        _handleDelete(index);
                                      },
                                      child: Icon(Icons.delete,
                                          size: deviceWidth * 0.05)),
                                )),
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
                              border: Border.all(color: Pallete.secondaryColor),
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
                                      width: deviceWidth * 0.3,
                                      child: Center(
                                        child: Text(
                                            calculateTotal().toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationStyle:
                                                    TextDecorationStyle.dashed,
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
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: SizedBox(
                width: deviceWidth * 0.9,
                height: deviceHeight * 0.07,
                child: FloatingActionButton(
                  shape: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(deviceWidth * 0.05)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (items.isNotEmpty) {
                        addSale(
                            ref: ref,
                            ph: partyNumberController.text.trim(),
                            total: calculateTotal().toString().trim(),
                            name: partyNameController.text.trim(),
                            context: context,
                            sid: sid,
                            items: items);
                      } else {
                        showSnackBar(context, "pls add item and try again");
                      }
                    }
                  },
                  child: const Text('Save'),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}

class UpiTransactionDetails {
  final String receiverUpiAddress;
  final String receiverName;
  final String transactionRefId;
  final String transactionNote;
  final double amount;

  UpiTransactionDetails({
    required this.receiverUpiAddress,
    required this.receiverName,
    required this.transactionRefId,
    required this.transactionNote,
    required this.amount,
  });
}
