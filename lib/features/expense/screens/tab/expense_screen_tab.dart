import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/models/expense_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../stocks/controller/stock_controller.dart';
import '../../controller/expense_controller.dart';

class ExpenseScreenTab extends ConsumerStatefulWidget {
  final ShopModel shop;
  const ExpenseScreenTab({super.key, required this.shop});

  @override
  ConsumerState<ExpenseScreenTab> createState() => _ExpenseScreenTabState();
}

class _ExpenseScreenTabState extends ConsumerState<ExpenseScreenTab> {
  lastMonthExpense({required List<ExpenseModel> data}) {
    DateTime now = DateTime.now();
    int currentMonth = 0;
    int currentYear = 0;
    now.month == 1
        ? {currentMonth = 12, currentYear = now.year - 1}
        : {currentMonth = now.month - 1, currentYear = now.year};
    double total = 0;
    for (var i in data) {
      DateTime expenseDate = DateTime.parse(i.expenseDate.toString());
      if (expenseDate.month == currentMonth &&
          expenseDate.year == currentYear) {
        total = total + double.parse(i.amount.toString());
      }
    }
    return total;
  }

  thisMonthExpense(List<ExpenseModel> data) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    double total = 0;
    for (var i in data) {
      DateTime expenseDate = DateTime.parse(i.expenseDate.toString());
      if (expenseDate.month == currentMonth &&
          expenseDate.year == currentYear) {
        total = total + double.parse(i.amount.toString());
      }
    }
    return total;
  }

  singleBillView(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.015)),
        content: SizedBox(
          height: deviceHeight * 0.68,
          width: deviceWidth * 0.45,
          child: Padding(
            padding: EdgeInsets.only(
                top: deviceWidth * 0.03,
                left: deviceWidth * 0.025,
                right: deviceWidth * 0.025,
                bottom: deviceWidth * 0.025),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Image(
                    image: NetworkImage(imageUrl),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(expenseControllerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Pallete.primaryColor,
              centerTitle: true,
              elevation: 0,
              title: Text(
                'Expense Report',
                style: TextStyle(
                    color: Pallete.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: deviceHeight * 0.04),
              ),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Consumer(builder: (context, ref, child) {
                      Map<String, dynamic> map = {
                        'sid': widget.shop.shopId,
                        'uid': widget.shop.uid,
                      };
                      return ref
                          .watch(getExpenseProvider(jsonEncode(map)))
                          .when(
                            data: (data) {
                              return Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(deviceHeight * 0.05),
                                  child: Container(
                                    height: deviceHeight * 0.2,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: Offset(4, 4)),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: Pallete.primaryColor,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: deviceHeight * 0.12,
                                        width: deviceWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Total Expense This Month',
                                              style: TextStyle(
                                                  color: Pallete.secondaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      deviceHeight * 0.03),
                                            ),
                                            Text(
                                              thisMonthExpense(data).toString(),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      deviceHeight * 0.05),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    }),
                    Consumer(builder: (context, ref, child) {
                      Map<String, dynamic> map = {
                        'sid': widget.shop.shopId,
                        'uid': widget.shop.uid,
                      };
                      return ref
                          .watch(getExpenseProvider(jsonEncode(map)))
                          .when(
                            data: (data) {
                              return Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(deviceHeight * 0.05),
                                  child: Container(
                                    height: deviceHeight * 0.2,
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: Offset(4, 4)),
                                      ],
                                      borderRadius: BorderRadius.circular(
                                          deviceWidth * 0.02),
                                      color: Pallete.primaryColor,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: deviceHeight * 0.12,
                                        width: deviceWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Total Expense Last Month',
                                              style: TextStyle(
                                                  color: Pallete.secondaryColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                      deviceHeight * 0.03),
                                            ),
                                            Text(
                                              lastMonthExpense(data: data)
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                      deviceHeight * 0.05),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    }),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: deviceHeight * 0.05, right: deviceHeight * 0.05),
                  child: Container(
                    height: deviceHeight * 0.5,
                    width: deviceWidth * 0.8,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(4, 4)),
                      ],
                      borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                      color: Pallete.primaryColor,
                    ),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Consumer(builder: (context, ref, child) {
                          Map<String, dynamic> map = {
                            'uid': widget.shop.uid,
                            'sid': widget.shop.shopId
                          };
                          return ref
                              .watch(getExpenseProvider(jsonEncode(map)))
                              .when(
                                  data: (data) => data.isEmpty
                                      ? const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text('no expense at this moment'),
                                          ],
                                        )
                                      : DataTable(
                                          border: TableBorder.all(width: 0.03),
                                          columns: [
                                            DataColumn(
                                              label: SizedBox(
                                                width: deviceWidth * 0.1,
                                                child: Text(
                                                  'Expense Name',
                                                  style: TextStyle(
                                                      fontSize:
                                                          deviceHeight * 0.03),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: deviceWidth * 0.1,
                                                child: Text(
                                                  'Expense Cost',
                                                  style: TextStyle(
                                                      fontSize:
                                                          deviceHeight * 0.03),
                                                ),
                                              ),
                                              numeric: true,
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: deviceWidth * 0.1,
                                                child: Text(
                                                  'Expense Date',
                                                  style: TextStyle(
                                                      fontSize:
                                                          deviceHeight * 0.03),
                                                ),
                                              ),
                                              numeric: true,
                                            ),
                                            DataColumn(
                                              label: SizedBox(
                                                width: deviceWidth * 0.22,
                                                child: Center(
                                                  child: Text(
                                                    'Bill',
                                                    style: TextStyle(
                                                        fontSize: deviceHeight *
                                                            0.030),
                                                  ),
                                                ),
                                              ),
                                              numeric: true,
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                              data.length, (index) {
                                            ExpenseModel expense = data[index];
                                            return DataRow(cells: [
                                              DataCell(
                                                SizedBox(
                                                  width: deviceWidth * 0.1,
                                                  child: Text(
                                                    expense.expense,
                                                    style: TextStyle(
                                                        fontSize: deviceHeight *
                                                            0.03),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: deviceWidth * 0.1,
                                                  child: Text(
                                                    expense.amount.toString(),
                                                    style: TextStyle(
                                                        fontSize: deviceHeight *
                                                            0.03),
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                SizedBox(
                                                  width: deviceWidth * 0.1,
                                                  child: Text(
                                                    DateFormat('MMM dd, yyyy')
                                                        .format(expense
                                                            .expenseDate),
                                                    style: TextStyle(
                                                        fontSize: deviceHeight *
                                                            0.03),
                                                  ),
                                                ),
                                              ),
                                              expense.billImage.isNotEmpty
                                                  ? DataCell(InkWell(
                                                      onTap: () {
                                                        singleBillView(context,
                                                            expense.billImage);
                                                      },
                                                      child: SizedBox(
                                                        child: Center(
                                                          child: Image(
                                                            image: NetworkImage(
                                                                expense
                                                                    .billImage),
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                  : const DataCell(Center(
                                                      child: Text(
                                                        'no bill picture found',
                                                      ),
                                                    ))
                                            ]);
                                          })),
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader());
                        })),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Routemaster.of(context).push(
                    '/store/${widget.shop.shopId}/AddExpense/${widget.shop.shopId}');
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("Add Expense"),
            ),
          );
  }
}
