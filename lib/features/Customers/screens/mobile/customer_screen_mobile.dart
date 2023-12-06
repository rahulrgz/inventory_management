import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/Customers/controller/customer_controller.dart';
import 'package:inventory_management_shop/models/customer_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/theme/pallete.dart';

class CustomerScreenMobile extends ConsumerStatefulWidget {
  final String encode;

  const CustomerScreenMobile({super.key, required this.encode});

  @override
  ConsumerState<CustomerScreenMobile> createState() =>
      _CustomerScreenMobileState();
}

class _CustomerScreenMobileState extends ConsumerState<CustomerScreenMobile> {
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addCustomer(
      {required WidgetRef ref, required String shopId}) async {
    // Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    // String shopId = map['shopId'];

    CustomerModel customerModel = CustomerModel(
      customerName: customerName.text.trim(),
      phoneNumber: customerPhone.text.trim(),
      saleId: [],
      shopId: [shopId],
      setSearch: [],
      deleted: false,
      createdTime: DateTime.now(),
    );
    await ref.watch(customerControllerProvider.notifier).addCustomers(
          context: context,
          customerModel: customerModel,
        );
    customerPhone.clear();
    customerName.clear();
  }

  deleteCustomer(WidgetRef ref, CustomerModel customerModel) {
    customerModel = customerModel.copyWith(deleted: true);
    ref
        .read(customerControllerProvider.notifier)
        .deleteCustomer(customerModel, context);
  }

  bottomSheet(BuildContext context, String shopid) {
    showModalBottomSheet(
      backgroundColor: Pallete.primaryColor,
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(deviceWidth * 0.15))),
      context: context,
      builder: (context1) {
        return Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: deviceWidth * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Add Customer',
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * 0.05,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: deviceHeight * 0.03),
                    SizedBox(
                      width: deviceWidth,
                      height: deviceHeight * 0.09,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this field  cant be empty';
                          }
                          return null;
                        },
                        controller: customerName,
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
                          hintText: 'Enter Name',
                          hintStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.01),
                    SizedBox(
                      width: deviceWidth,
                      height: deviceHeight * 0.09,
                      child: TextFormField(
                        controller: customerPhone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this field cant be empty';
                          } else if (value.length < 10) {
                            return 'enter a valid phone number';
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 10,
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
                          hintText: 'Enter Number',
                          hintStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.015),
                    Consumer(builder: (context, ref, child) {
                      return InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (customerName.text.trim().isEmpty) {
                              showSnackBar(context, 'please enter name');
                              Routemaster.of(context).pop();
                            } else {
                              await addCustomer(ref: ref, shopId: shopid);
                              // Close the bottom sheet after adding customer
                            }
                          }
                        },
                        child: Container(
                            height: deviceHeight * 0.07,
                            width: deviceWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.04),
                              color: Pallete.secondaryColor,
                            ),
                            child: Center(
                              child: Text(
                                'Save ',
                                style: TextStyle(
                                    fontSize: deviceWidth * 0.04,
                                    color: Pallete.primaryColor),
                              ),
                            )),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Pallete.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.primaryColor,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
            color: Pallete.secondaryColor,
          ),
        ),
        title: const Text(
          'CUSTOMERS',
          style: TextStyle(
              color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.81,
            width: deviceWidth,
            child: Consumer(builder: (context, ref, child) {
              Map<String, dynamic> map =
                  jsonDecode(Uri.decodeComponent(widget.encode));
              String shopId = map['shopId'];
              var customer = ref.watch(getCustomerProvider(shopId));
              return customer.when(
                data: (data) => data.isEmpty
                    ? const Center(
                        child: Text('No customers.......'),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          CustomerModel cust = data[index];
                          return Padding(
                            padding: EdgeInsets.all(deviceWidth * 0.05),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(4, 4))
                                  ],
                                  color: Pallete.thirdColor,
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02)),
                              child: ListTile(
                                title: Text(
                                  cust.customerName,
                                  style: TextStyle(
                                      color: Pallete.secondaryColor,
                                      fontSize: deviceWidth * 0.045),
                                ),
                                subtitle: Text(
                                  cust.phoneNumber,
                                  style: TextStyle(
                                      color: Pallete.secondaryColor,
                                      fontSize: deviceWidth * 0.035),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    deleteConfirmBoxMobile(context, ref, cust);
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: deviceHeight * 0.01,
                                      ),
                                      Icon(Icons.delete_outline,
                                          color: Pallete.secondaryColor,
                                          size: deviceWidth * 0.065),
                                      Text('Delete',
                                          style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontSize: deviceWidth * 0.03))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                error: (eror, stack) => ErrorText(error: eror.toString()),
                loading: () => const Loader(),
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceWidth * 0.03, right: deviceWidth * 0.03),
            child: InkWell(
              onTap: () {
                bottomSheet(context, shop.shopId);
              },
              child: Container(
                  height: deviceHeight * 0.07,
                  width: deviceWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(deviceWidth * 0.04),
                    color: Pallete.secondaryColor,
                  ),
                  child: Center(
                    child: Text(
                      'Add Customer ',
                      style: TextStyle(
                          fontSize: deviceWidth * 0.04,
                          color: Pallete.primaryColor),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void deleteConfirmBoxMobile(
      BuildContext context, WidgetRef ref, CustomerModel customerModel) {
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
              deleteCustomer(ref, customerModel);
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
}
