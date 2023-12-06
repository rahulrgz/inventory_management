import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/report/controller/report_controller.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/utils.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/shope_model.dart';
import '../../../../models/stock_model.dart';
import '../../../expense/controller/expense_controller.dart';

class ShopReportScreenweb extends ConsumerStatefulWidget {
  final String shopId;
  const ShopReportScreenweb({Key? key, required this.shopId}) : super(key: key);

  @override
  ConsumerState<ShopReportScreenweb> createState() =>
      _ShopReportScreenwebState();
}

class _ShopReportScreenwebState extends ConsumerState<ShopReportScreenweb> {
  Uint8List? expenseImage;
  TextEditingController expenseName = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ShopModel shopModel;

  addExpense(WidgetRef ref, BuildContext context) {
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
        expensePickAndroid: null,
        expensePickWeb: expenseImage,
        expenseModel: expenseModel);
    expenseAmount.clear();
    expenseName.clear();
  }

  calculateTotalSale({required List<SalesModel> sale}) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    double tot = 0;
    for (var i in sale) {
      DateTime saleDate = DateTime.parse(i.saleDate.toString());
      if (saleDate.month == currentMonth && saleDate.year == currentYear) {
        tot = tot + double.parse(i.totalPrice);
      }
    }
    return tot;
  }

  double calculateTotalPurchase({required List<StockModel> stock}) {
    double tot = 0;
    for (var i in stock) {
      tot += i.purchasePrice;
    }
    return tot;
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

  void uploadExpense() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        expenseImage = res.files.first.bytes;
      });
    }
  }

  singleBillView(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context2) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceWidth * 0.015)),
        content: SizedBox(
          height: deviceHeight * 0.5,
          width: deviceWidth * 0.4,
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
                    fit: BoxFit.cover,
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
    var uid = ref.watch(userProvider)!.uid;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(deviceWidth * 0.015),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Consumer(builder: (context, ref, child) {
                          Map<String, dynamic> map = {
                            'sid': widget.shopId,
                            'uid': uid,
                          };
                          return ref
                              .watch(getExpenseProvider(jsonEncode(map)))
                              .when(
                                data: (data) {
                                  return Container(
                                    height: deviceHeight * 0.16,
                                    width: deviceWidth * 0.16,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.shopping_cart,
                                            color: Pallete.secondaryColor,
                                          ),
                                          Text(
                                            '₹ ${thisMonthExpense(data).toString()}',
                                            style: TextStyle(
                                                fontSize: deviceHeight * 0.024,
                                                fontWeight: FontWeight.bold,
                                                color: Pallete.secondaryColor),
                                          ),
                                          Text(
                                            'Total Expence this month',
                                            style: TextStyle(
                                                fontSize: deviceHeight * 0.016,
                                                color: Pallete.secondaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => Loader(),
                              );
                        }),
                        SizedBox(
                          width: deviceWidth * 0.01,
                        ),
                        Consumer(builder: (context, ref, child) {
                          Map<String, dynamic> map = {
                            'sid': widget.shopId,
                            'uid': uid,
                          };
                          return ref
                              .watch(getExpenseProvider(jsonEncode(map)))
                              .when(
                                data: (data) {
                                  return Container(
                                    height: deviceHeight * 0.16,
                                    width: deviceWidth * 0.16,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.shopping_cart,
                                            color: Pallete.secondaryColor,
                                          ),
                                          Text(
                                            '₹ ${lastMonthExpense(data: data).toString()}',
                                            style: TextStyle(
                                                fontSize: deviceHeight * 0.024,
                                                fontWeight: FontWeight.bold,
                                                color: Pallete.secondaryColor),
                                          ),
                                          Text(
                                            'Total Expence last month',
                                            style: TextStyle(
                                                fontSize: deviceHeight * 0.016,
                                                color: Pallete.secondaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => Loader(),
                              );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  Container(
                    height: deviceHeight * 0.4,
                    width: deviceWidth * 0.65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                        border: Border.all(color: Pallete.blackColor)),
                    child: AspectRatio(
                      aspectRatio: 0.95,
                      child: _BarChart(shopId: widget.shopId, uid: uid),
                    ),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                  Container(
                    // height: deviceHeight * 0.4,
                    width: deviceWidth * 0.65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                        border: Border.all(color: Pallete.blackColor)),
                    child: Padding(
                      padding: EdgeInsets.all(deviceWidth * 0.015),
                      child: Column(
                        children: [
                          Text(
                            'Expence',
                            style: TextStyle(
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.025,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.4,
                            width: deviceWidth,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                child: Consumer(builder: (context, ref, child) {
                                  Map<String, dynamic> map = {
                                    'uid': uid,
                                    'sid': widget.shopId
                                  };
                                  return ref
                                      .watch(
                                          getExpenseProvider(jsonEncode(map)))
                                      .when(
                                          data: (data) => data.isEmpty
                                              ? const Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        'no expense at this moment'),
                                                  ],
                                                )
                                              : DataTable(
                                                  columnSpacing:
                                                      deviceWidth * 0.06,
                                                  border: TableBorder.all(
                                                      width: 0.04),
                                                  columns: [
                                                    DataColumn(
                                                      label: SizedBox(
                                                        child: Text(
                                                          'Expense Name',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.018),
                                                        ),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Expense Cost',
                                                        style: TextStyle(
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.018),
                                                      ),
                                                      numeric: true,
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'Expense Date',
                                                        style: TextStyle(
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.018),
                                                      ),
                                                      numeric: true,
                                                    ),
                                                    DataColumn(
                                                      label: Center(
                                                        child: Text(
                                                          'Bill',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.018),
                                                        ),
                                                      ),
                                                      numeric: true,
                                                    ),
                                                  ],
                                                  rows: List<DataRow>.generate(
                                                      data.length, (index) {
                                                    ExpenseModel expense =
                                                        data[index];
                                                    return DataRow(cells: [
                                                      DataCell(
                                                        SizedBox(
                                                          width: deviceWidth *
                                                              0.13,
                                                          child: Text(
                                                            expense.expense,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.018),
                                                          ),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          expense.amount
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.018),
                                                        ),
                                                      ),
                                                      DataCell(
                                                        Text(
                                                          DateFormat(
                                                                  'MMM dd, yyyy')
                                                              .format(DateTime
                                                                  .now()),
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.018),
                                                        ),
                                                      ),
                                                      expense.billImage
                                                              .isNotEmpty
                                                          ? DataCell(InkWell(
                                                              onTap: () {
                                                                singleBillView(
                                                                    context,
                                                                    expense
                                                                        .billImage);
                                                              },
                                                              child: SizedBox(
                                                                width:
                                                                    deviceWidth *
                                                                        0.15,
                                                                child: Center(
                                                                  child: Image(
                                                                    image: NetworkImage(
                                                                        expense
                                                                            .billImage),
                                                                  ),
                                                                ),
                                                              ),
                                                            ))
                                                          : const DataCell(
                                                              Center(
                                                              child: Text(
                                                                'no bill picture found',
                                                              ),
                                                            ))
                                                    ]);
                                                  })),
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString()),
                                          loading: () => const Loader());
                                })),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: deviceWidth * 0.019,
              ),
              Column(
                children: [
                  Container(
                    height: deviceHeight * 0.74,
                    width: deviceWidth * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.01),
                        border: Border.all(color: Pallete.blackColor)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: deviceHeight * 0.01),
                          Center(
                            child: Text(
                              'Add Expence',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.secondaryColor),
                            ),
                          ),
                          GestureDetector(
                            onTap: uploadExpense,
                            child: Container(
                              height: deviceHeight * 0.3,
                              width: deviceWidth * 0.7,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.03),
                                border: Border.all(
                                  color: Pallete.secondaryColor,
                                ),
                              ),
                              child: expenseImage != null
                                  ? Image.memory(
                                      expenseImage!,
                                      fit: BoxFit.fill,
                                    )
                                  : Lottie.asset(
                                      AssetConstants.noImage,
                                      width: deviceWidth * 0.4,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.7,
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
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
                                  borderSide: const BorderSide(
                                      color: Pallete.secondaryColor),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    borderSide: const BorderSide(
                                        color: Pallete.primaryColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    borderSide: const BorderSide(
                                        color: Pallete.secondaryColor)),
                                labelText: 'Expense',
                                labelStyle: const TextStyle(
                                    color: Pallete.secondaryColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.02,
                          ),
                          SizedBox(
                            width: deviceWidth * 0.7,
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
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
                                  borderSide: const BorderSide(
                                      color: Pallete.secondaryColor),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    borderSide: const BorderSide(
                                        color: Pallete.primaryColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    borderSide: const BorderSide(
                                        color: Pallete.secondaryColor)),
                                labelText: 'Amount',
                                labelStyle: const TextStyle(
                                    color: Pallete.secondaryColor),
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
                                  showSnackBar(
                                      context, 'please enter details properly');
                                }
                              },
                              child: Container(
                                width: deviceWidth * 0.8,
                                height: deviceHeight * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
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
                  SizedBox(
                    height: deviceHeight * 0.025,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChart extends ConsumerWidget {
  String shopId;
  String uid;
  _BarChart({super.key, required this.uid, required this.shopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> map = {
      'sid': shopId,
      'uid': uid,
    };
    return ref.watch(reportSalesStreamProvider(jsonEncode(map))).when(
          data: (data) {
            List<double> dailySales = calculateDailySales(data);
            List<BarChartGroupData> barGroup = List.generate(7, (index) {
              return BarChartGroupData(x: index, barRods: [
                BarChartRodData(toY: dailySales[index], gradient: _barsGradient)
              ], showingTooltipIndicators: [
                0
              ]);
            });
            return SizedBox(
              height: deviceHeight * 0.2,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: barGroup,
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: dailySales.reduce((value, element) =>
                          value > element ? value : element) +
                      2,
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => Loader(),
        );
  }

  List<double> calculateDailySales(List<SalesModel> salesData) {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday));
    List<double> dailySales = List.generate(7, (index) => 0.0);
    for (var sale in salesData) {
      DateTime saleDate = DateTime.parse(sale.saleDate.toString());
      if (saleDate.isAfter(firstDayOfWeek)) {
        int dayOfWeek = saleDate.weekday - 1;
        dailySales[dayOfWeek] += double.parse(sale.totalPrice);
      }
    }
    for (int i = 0; i < dailySales.length; i++) {
      if (dailySales[i] > 90000000) {
        dailySales[i] = 90000;
      }
    }
    return dailySales;
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Pallete.secondaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 3,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [Colors.purple, Pallete.secondaryColor],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
