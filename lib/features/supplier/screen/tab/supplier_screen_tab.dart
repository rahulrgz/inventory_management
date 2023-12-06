import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/supplier/controller/supplier_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import 'package:routemaster/routemaster.dart';

class SuppliersScreenTab extends StatefulWidget {
  final String encode;
  const SuppliersScreenTab({super.key, required this.encode});
  @override
  State<SuppliersScreenTab> createState() => _SuppliersScreenTabState();
}

class _SuppliersScreenTabState extends State<SuppliersScreenTab> {
  TextEditingController suppliername = TextEditingController();
  TextEditingController supplierphone = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ShopModel decode(String encode) {
    Map<String, dynamic> decode = jsonDecode(Uri.decodeComponent(encode));
    return ShopModel(
        uid: decode['uid'],
        category: decode['category'],
        name: decode['name'],
        shopId: decode['shopId'],
        subscriptionId: decode['subscriptionId'],
        createdTime: DateTime.parse(decode['createdTime']),
        shopProfile: decode['shopProfile'],
        deleted: decode['deleted'],
        setSearch: List<String>.from(decode['setSearch']),
        accepted: decode['accepted'],
        blocked: decode['blocked'],
        reason: decode['reason'],
        expirationDate: DateTime.now());
  }

  addSupplier(WidgetRef ref) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    String shopId = map['shopId'];
    if (_formKey.currentState!.validate()) {
      SupplierModel supplierModel = SupplierModel(
        name: suppliername.text.trim(),
        phoneNumber: supplierphone.text.trim(),
        shopId: [shopId],
        setSearch: [],
        createdTime: DateTime.now(),
        deleted: false,
        PurchaseId: [],
      );
      ref
          .watch(supplierControllerProvider.notifier)
          .addSuppliers(context: context, supplierModel: supplierModel);
    }
  }

  deleteSupplier(WidgetRef ref, SupplierModel supplierModel) {
    supplierModel = supplierModel.copyWith(deleted: true);
    ref
        .read(supplierControllerProvider.notifier)
        .deleteSupplier(supplierModel, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop('/store/homescreen/:shop');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
            )),
        title: const Text(
          'SUPPLIERS',
          style: TextStyle(color: Pallete.secondaryColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            SizedBox(
              height: deviceHeight,
              width: deviceWidth * 0.5,
              child: Padding(
                padding: EdgeInsets.only(
                    left: deviceHeight * 0.05, right: deviceHeight * 0.05),
                child: Consumer(
                  builder: (context, ref, child) {
                    Map<String, dynamic> map =
                        jsonDecode(Uri.decodeComponent(widget.encode));
                    String shopId = map['shopId'];
                    var supplier = ref.watch(getSupplierProvider(shopId));
                    return supplier.when(
                      data: (data) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            SupplierModel supplierList = data[index];
                            return Padding(
                              padding: EdgeInsets.all(deviceHeight * 0.02),
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          deviceHeight * 0.03)),
                                  title: Text(
                                    supplierList.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceHeight * 0.028,
                                        color: Pallete.secondaryColor),
                                  ),
                                  subtitle: Text(supplierList.phoneNumber,
                                      style: TextStyle(
                                          color: Pallete.secondaryColor,
                                          fontSize: deviceHeight * 0.024)),
                                  onTap: () {},
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
                      },
                      loading: () {
                        return const Loader();
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight,
              width: deviceWidth * 0.5,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.07,
                      child: Center(
                          child: Text(
                        'ADD SUPPLIER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Pallete.secondaryColor,
                            fontSize: deviceHeight * 0.038),
                      )),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Supplier name can't be empty !!";
                          } else {
                            return null;
                          }
                        },
                        controller: suppliername,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            label: const Text(
                              '  Enter Name',
                              style: TextStyle(color: Pallete.secondaryColor),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.035,
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
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
                        controller: supplierphone,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            label: const Text(
                              '  Enter Phone Number',
                              style: TextStyle(color: Pallete.secondaryColor),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    Consumer(
                      builder:
                          (BuildContext context, WidgetRef ref, Widget? child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (suppliername.text.trim().isNotEmpty) {
                              if (_formKey.currentState!.validate()) {
                                addSupplier(ref);
                              }
                            } else {
                              showSnackBar(context, 'please add the details');
                            }
                            suppliername.clear();
                            supplierphone.clear();
                            // supplierAddress.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(deviceWidth * 0.3, deviceHeight * 0.09),
                            backgroundColor: Pallete.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.02),
                                side: const BorderSide(
                                    color: Pallete.secondaryColor)),
                          ),
                          child: Text(
                            'Add Supplier',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.0125,
                                color: Pallete.primaryColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
