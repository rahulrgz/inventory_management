import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/expense_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/utils.dart';
import '../../controller/expense_controller.dart';

class AddExpenseTab extends ConsumerStatefulWidget {
  final String shopId;
  const AddExpenseTab({super.key, required this.shopId});

  @override
  ConsumerState<AddExpenseTab> createState() => _AddExpenseTabState();
}

class _AddExpenseTabState extends ConsumerState<AddExpenseTab> {
  TextEditingController expenseName = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  addExpense(WidgetRef ref, BuildContext context) {
    if (expenseName.text.trim().isEmpty || expenseAmount.text.trim().isEmpty) {
      showSnackBar(context, 'add expence details');
    } else {
      ExpenseModel expenseModel = ExpenseModel(
          eid: '',
          shopId: widget.shopId,
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

  File? expenseImage;

  void uploadExpense() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        expenseImage = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(expenseControllerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Pallete.secondaryColor,
              title: Text(
                "Add Expense",
                style: TextStyle(fontSize: deviceHeight * 0.04),
              ),
              elevation: 0,
            ),
            body: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      decelerationRate: ScrollDecelerationRate.fast),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: deviceWidth * 0.4,
                        height: deviceHeight * 0.6,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.03),
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
                      SizedBox(
                        width: deviceWidth * 0.4,
                        height: deviceHeight * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.4,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    maxLength: 20,
                                    controller: expenseName,
                                    decoration: InputDecoration(
                                      // alignLabelWithHint: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.03),
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
                                      labelText: 'Expense',
                                      labelStyle: const TextStyle(
                                          color: Pallete.secondaryColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                SizedBox(
                                  width: deviceWidth * 0.4,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return '';
                                      }
                                      return null;
                                    },
                                    controller: expenseAmount,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      // alignLabelWithHint: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.03),
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
                                      labelText: 'Amount',
                                      labelStyle: const TextStyle(
                                          color: Pallete.secondaryColor),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.03,
                                ),
                                GestureDetector(
                                  onTap: uploadExpense,
                                  child: Container(
                                    width: deviceWidth * 0.4,
                                    height: deviceHeight * 0.095,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceHeight * 0.03),
                                      border: Border.all(
                                          color: Pallete.secondaryColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Upload Image of Expense',
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03,
                                            color: Pallete.secondaryColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Consumer(
                              builder: (context1, ref, child) {
                                return GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      addExpense(ref, context);
                                    } else {
                                      showSnackBar(context,
                                          'please enter details properly');
                                    }
                                  },
                                  child: Container(
                                    width: deviceWidth * 0.4,
                                    height: deviceHeight * 0.095,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.03),
                                        color: Pallete.secondaryColor),
                                    child: Center(
                                      child: Text(
                                        'Add Expense',
                                        style: TextStyle(
                                            fontSize: deviceHeight * 0.03,
                                            color: Pallete.primaryColor),
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
              ),
            ),
          );
  }
}
