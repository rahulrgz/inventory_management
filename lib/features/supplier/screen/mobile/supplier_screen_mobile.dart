import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/supplier/controller/supplier_controller.dart';
import 'package:inventory_management_shop/models/supplier_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class SupplireScreenMobile extends StatefulWidget {
  final String encode;
  const SupplireScreenMobile({super.key, required this.encode});

  @override
  State<SupplireScreenMobile> createState() => _SupplireScreenMobileState();
}

class _SupplireScreenMobileState extends State<SupplireScreenMobile> {
  TextEditingController suppliername = TextEditingController();
  TextEditingController supplierphone = TextEditingController();
  // TextEditingController supplierAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> addSupplier(
      {required WidgetRef ref, required String shopid}) async {
    SupplierModel supplierModel = SupplierModel(
      name: suppliername.text.trim(),
      phoneNumber: supplierphone.text.trim(),
      shopId: [shopid],
      setSearch: [],
      createdTime: DateTime.now(),
      deleted: false,
      PurchaseId: [],
    );
    await ref.watch(supplierControllerProvider.notifier).addSuppliers(
          context: context,
          supplierModel: supplierModel,
        );
  }

  // File? profileFile;
  // void selectProfileImage() async {
  //   final res = await pickImage();
  //   if (res != null) {
  //     setState(() {
  //       profileFile = File(res.files.first.path!);
  //     });
  //   }
  // }

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

  deleteSupplier(WidgetRef ref, SupplierModel supplierModel) {
    supplierModel = supplierModel.copyWith(deleted: true);
    ref
        .read(supplierControllerProvider.notifier)
        .deleteSupplier(supplierModel, context);
  }

  bottumSheet(BuildContext context, String shopid) {
    showModalBottomSheet(
      backgroundColor: Pallete.thirdColor,
      showDragHandle: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(deviceWidth * 0.15))),
      context: context,
      builder: (context) {
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
                    Text('Add Supplier',
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
                            return 'this field cant be empty';
                          }
                          return null;
                        },
                        controller: suppliername,
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this field cant be empty';
                          } else if (value.length < 10) {
                            return 'enter a valid phone number';
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        controller: supplierphone,
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
                          if (suppliername.text.trim().isNotEmpty) {
                            if (_formKey.currentState!.validate()) {
                              await addSupplier(ref: ref, shopid: shopid);
                              suppliername.clear();
                              supplierphone.clear();
                              Routemaster.of(context).pop();
                            }
                          } else {
                            showSnackBar(context, 'please add name');
                            Routemaster.of(context).pop();
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
                    }),
                    SizedBox(height: deviceHeight * 0.03),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode();
    return Scaffold(
      backgroundColor: Pallete.primaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Pallete.primaryColor,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined,
                color: Pallete.secondaryColor)),
        title: Text(
          'SUPPLIERS',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceHeight * 0.022),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: deviceWidth * 0.05,
          right: deviceWidth * 0.05,
        ),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: deviceWidth,
                child: Consumer(builder: (context, ref, child) {
                  var supplier = ref.watch(getSupplierProvider(shop.shopId));
                  return supplier.when(
                    data: (data) {
                      return data.isEmpty
                          ? const Center(
                              child: Text('No suppliers yet'),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                SupplierModel supplierList = data[index];
                                return Padding(
                                  padding: EdgeInsets.all(deviceWidth * 0.02),
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
                                        supplierList.name,
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.045),
                                      ),
                                      subtitle: Text(
                                        supplierList.phoneNumber,
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.035),
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          deleteConfirmBoxMobile(
                                              context, ref, supplierList);
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
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontSize:
                                                        deviceWidth * 0.03))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                    error: (error, stack) => ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: deviceHeight * 0.015),
              child: InkWell(
                onTap: () {
                  bottumSheet(context, shop.shopId);
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
                      'Add Suppliers ',
                      style: TextStyle(
                          fontSize: deviceWidth * 0.04,
                          color: Pallete.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteConfirmBoxMobile(
      BuildContext context, WidgetRef ref, SupplierModel supplierModel) {
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
              deleteSupplier(ref, supplierModel);
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
