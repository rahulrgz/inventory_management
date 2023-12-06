import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/utils.dart';
import '../../../../models/expense_model.dart';
import '../../controller/expense_controller.dart';

class AddExpenseMobile extends StatefulWidget {
  final String shop;
  const AddExpenseMobile({super.key, required this.shop});

  @override
  State<AddExpenseMobile> createState() => _AddExpenseMobileState();
}

class _AddExpenseMobileState extends State<AddExpenseMobile> {
  TextEditingController expenseName = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? expenseImage;
  late ShopModel shopModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopModel = pushdecode();
  }

  void uploadExpense() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        expenseImage = File(res.files.first.path!);
      });
    }
  }

  ShopModel pushdecode() {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.shop));
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
        expirationDate: DateTime.parse(map['expirationDate']));
    return shop;
  }

  addExpense(WidgetRef ref, BuildContext context) {
    if (expenseName.text.trim().isEmpty || expenseAmount.text.trim().isEmpty) {
      showSnackBar(context, 'add expense details');
    } else {
      ExpenseModel expenseModel = ExpenseModel(
          eid: '',
          shopId: shopModel.shopId,
          expense: expenseName.text.trim(),
          amount: double.parse(expenseAmount.text),
          billImage: '',
          expenseDate: DateTime.now(),
          setSearch: [expenseName.text],
          deleted: false);
      ref.watch(expenseControllerProvider.notifier).addExpense(
          context: context,
          expensePickAndroid: expenseImage,
          expensePickWeb: null,
          expenseModel: expenseModel);
      Routemaster.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(shopModel.shopId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.secondaryColor,
        elevation: 0,
        title: Text(
          'EXPENSE',
          style: TextStyle(fontSize: deviceHeight * 0.02),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                left: deviceWidth * 0.1, right: deviceWidth * 0.1),
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.1,
                ),
                GestureDetector(
                  onTap: uploadExpense,
                  child: Container(
                    height: deviceHeight * 0.33,
                    width: deviceWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.03),
                      border: Border.all(
                        color: Pallete.secondaryColor,
                      ),
                    ),
                    child: expenseImage != null
                        ? Image.file(expenseImage!)
                        : Lottie.asset(
                            AssetConstants.noImage,
                            width: deviceWidth * 0.4,
                          ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                SizedBox(
                  width: deviceWidth * 0.8,
                  child: TextFormField(
                    maxLength: 20,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter bill name....';
                      }
                      return null;
                    },
                    controller: expenseName,
                    decoration: InputDecoration(
                      // alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02),
                        borderSide:
                            const BorderSide(color: Pallete.secondaryColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          borderSide:
                              const BorderSide(color: Pallete.primaryColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor)),
                      labelText: 'Expense',
                      labelStyle:
                          const TextStyle(color: Pallete.secondaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                SizedBox(
                  width: deviceWidth * 0.8,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter bill amount...';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: expenseAmount,
                    decoration: InputDecoration(
                      // alignLabelWithHint: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02),
                        borderSide:
                            const BorderSide(color: Pallete.secondaryColor),
                      ),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          borderSide:
                              const BorderSide(color: Pallete.primaryColor)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          borderSide:
                              const BorderSide(color: Pallete.secondaryColor)),
                      labelText: 'Amount',
                      labelStyle:
                          const TextStyle(color: Pallete.secondaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Consumer(builder: (context, ref, child) {
                  return GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        addExpense(ref, context);
                      } else {
                        showSnackBar(context, 'please enter details properly');
                      }
                    },
                    child: Container(
                      width: deviceWidth * 0.8,
                      height: deviceHeight * 0.06,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          color: Pallete.secondaryColor),
                      child: Center(
                        child: Text(
                          'Add Expense',
                          style: TextStyle(
                              fontSize: deviceHeight * 0.02,
                              color: Pallete.primaryColor),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
