import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/stocks/controller/stock_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/expense_model.dart';
import '../../../../models/purchase_model.dart';
import '../../../../models/sales_model.dart';
import '../../../../models/shope_model.dart';
import '../../../../models/stock_model.dart';
import '../../../expense/controller/expense_controller.dart';
import '../../../expense/screens/mobile/add_expense_mobile.dart';
import '../../controller/report_controller.dart';

class ReportScreenMobile extends ConsumerStatefulWidget {
  final ShopModel shop;

  const ReportScreenMobile({
    super.key,
    required this.shop,
  });

  @override
  ConsumerState<ReportScreenMobile> createState() => _ReportScreenMobileState();
}

class _ReportScreenMobileState extends ConsumerState<ReportScreenMobile> {
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

  encodeAndNavigate({required ShopModel shop, required BuildContext context}) {
    ShopModel shop = widget.shop;
    Map<String, dynamic> map = {
      'uid': shop.uid,
      'shopProfile': shop.shopProfile,
      'category': shop.category,
      'name': shop.name,
      'shopId': shop.shopId,
      'subscriptionId': shop.subscriptionId,
      'createdTime': shop.createdTime.toIso8601String(),
      'deleted': shop.deleted,
      'setSearch': shop.setSearch,
      'accepted': shop.accepted,
      'blocked': shop.blocked,
      'reason': shop.reason,
      'expirationDate': shop.expirationDate.toIso8601String(),
    };
    String encode = jsonEncode(map);
    Routemaster.of(context).push(Uri.encodeComponent(encode));
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
    ShopModel shop = widget.shop;

    return Scaffold(
      backgroundColor: Pallete.thirdColorMob,
      appBar: AppBar(
        backgroundColor: Pallete.thirdColorMob,
        toolbarHeight: deviceHeight * 0.09,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "REPORTS",
          style: TextStyle(
              color: Pallete.secondaryColor,
              fontSize: deviceWidth * 0.045,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.05,
                    ),
                    Consumer(builder: (context, ref, child) {
                      Map<String, dynamic> map = {
                        'sid': shop.shopId,
                        'uid': shop.uid,
                      };
                      return ref
                          .watch(getExpenseProvider(jsonEncode(map)))
                          .when(
                            data: (data) {
                              return Container(
                                height: deviceHeight * 0.18,
                                width: deviceWidth * 0.35,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 0.5,
                                        offset: Offset(0, 2)),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Pallete.primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: deviceWidth * 0.04,
                                        backgroundColor: Colors.black12,
                                        child: const Icon(
                                          Icons.monetization_on_sharp,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.01,
                                      ),
                                      SizedBox(
                                        width: deviceWidth * 0.25,
                                        child: Text(
                                          '₹ ${thisMonthExpense(data).toString()}',
                                          style: TextStyle(
                                              fontSize: deviceHeight * 0.024,
                                              fontWeight: FontWeight.bold,
                                              color: Pallete.secondaryColor),
                                        ),
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
                      width: deviceWidth * 0.05,
                    ),
                    // Consumer(builder: (context, ref, child) {
                    //   Map<String, dynamic> map = {
                    //     'sid': shop.shopId,
                    //     'uid': shop.uid,
                    //   };
                    //   return ref
                    //       .watch(totalStockProvider(jsonEncode(map)))
                    //       .when(
                    //         data: (data) {
                    //           return Container(
                    //             height: deviceHeight * 0.18,
                    //             width: deviceWidth * 0.35,
                    //             decoration: BoxDecoration(
                    //               boxShadow: const [
                    //                 BoxShadow(
                    //                     color: Colors.grey,
                    //                     blurRadius: 1,
                    //                     spreadRadius: 0.5,
                    //                     offset: Offset(0, 2)),
                    //               ],
                    //               borderRadius: BorderRadius.circular(20),
                    //               color: Pallete.primaryColor,
                    //             ),
                    //             child: Padding(
                    //               padding: const EdgeInsets.all(10),
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   CircleAvatar(
                    //                     radius: deviceWidth * 0.05,
                    //                     backgroundColor: Colors.black12,
                    //                     child: const Icon(
                    //                       Icons.stacked_bar_chart_outlined,
                    //                       color: Colors.orange,
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     height: deviceHeight * 0.02,
                    //                   ),
                    //                   Text(
                    //                     '₹ ${calculateTotalPurchase(stock: data)}/-',
                    //                     style: TextStyle(
                    //                         fontSize: deviceHeight * 0.024,
                    //                         fontWeight: FontWeight.bold,
                    //                         color: Pallete.secondaryColor),
                    //                   ),
                    //                   Text(
                    //                     'Total Stock',
                    //                     style: TextStyle(
                    //                         fontSize: deviceHeight * 0.016,
                    //                         color: Pallete.secondaryColor),
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //         error: (error, stackTrace) =>
                    //             ErrorText(error: error.toString()),
                    //         loading: () => Loader(),
                    //       );
                    // }),
                    // SizedBox(
                    //   width: deviceWidth * 0.05,
                    // ),
                    Consumer(builder: (context, ref, child) {
                      Map<String, dynamic> map = {
                        'sid': shop.shopId,
                        'uid': shop.uid
                      };
                      return ref
                          .watch(getExpenseProvider(jsonEncode(map)))
                          .when(
                            data: (data) {
                              return Container(
                                height: deviceHeight * 0.18,
                                width: deviceWidth * 0.35,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 0.5,
                                        offset: Offset(0, 2)),
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  color: Pallete.primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: deviceWidth * 0.04,
                                        backgroundColor: Colors.black12,
                                        child: const Icon(
                                          Icons.monetization_on_outlined,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.01,
                                      ),
                                      SizedBox(
                                        width: deviceWidth * 0.3,
                                        child: Text(
                                          '₹ ${lastMonthExpense(data: data).toString()}',
                                          style: TextStyle(
                                              fontSize: deviceHeight * 0.024,
                                              fontWeight: FontWeight.bold,
                                              color: Pallete.secondaryColor),
                                        ),
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
                    SizedBox(
                      width: deviceWidth * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            Container(
              height: deviceHeight * 0.4,
              width: deviceWidth * 0.9,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 0.5,
                      spreadRadius: 0,
                      offset: Offset(0, 0)),
                ],
                borderRadius: BorderRadius.circular(deviceWidth * 0.07),
                color: Pallete.primaryColor,
              ),
              child: Barchart(
                uid: shop.uid,
                shopId: shop.shopId,
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.03,
            ),
            GestureDetector(
              onTap: () {
                encodeAndNavigate(shop: shop, context: context);
              },
              child: Container(
                height: deviceHeight * 0.06,
                width: deviceWidth * 0.9,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.5,
                        spreadRadius: 0,
                        offset: Offset(0, 0)),
                  ],
                  borderRadius: BorderRadius.circular(deviceWidth * 0.05),
                  color: Pallete.primaryColor,
                ),
                child: Center(
                  child: Text(
                    'Add Expense',
                    style: TextStyle(
                        fontSize: deviceHeight * 0.02,
                        color: Pallete.secondaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.06, right: deviceWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EXPENSES',
                    style: TextStyle(
                        fontSize: deviceHeight * 0.023,
                        fontWeight: FontWeight.bold,
                        color: Pallete.secondaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: deviceHeight * 0.01,
            ),
            SizedBox(
              height: deviceHeight * 0.55,
              width: deviceWidth,
              child: Consumer(builder: (context, ref, child) {
                Map<String, dynamic> map = {
                  'uid': widget.shop.uid,
                  'sid': widget.shop.shopId
                };
                return ref.watch(getExpenseProvider(jsonEncode(map))).when(
                    data: (data) => data.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('no expense at this moment'),
                            ],
                          )
                        : DataTable(
                            columnSpacing: deviceWidth * 0.07,
                            border: TableBorder.all(width: 0.04),
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  child: Text(
                                    ' Name',
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.013),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  ' Cost',
                                  style:
                                      TextStyle(fontSize: deviceHeight * 0.013),
                                ),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Text(
                                  ' Date',
                                  style:
                                      TextStyle(fontSize: deviceHeight * 0.013),
                                ),
                                numeric: true,
                              ),
                              DataColumn(
                                label: Center(
                                  child: Text(
                                    'Bill',
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.013),
                                  ),
                                ),
                                numeric: true,
                              ),
                            ],
                            rows: List<DataRow>.generate(data.length, (index) {
                              ExpenseModel expense = data[index];
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: deviceWidth * 0.11,
                                    child: Text(
                                      expense.expense,
                                      style: TextStyle(
                                          fontSize: deviceHeight * 0.013),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    expense.amount.toString(),
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.013),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat('MMM dd, yyyy')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                        fontSize: deviceHeight * 0.013),
                                  ),
                                ),
                                expense.billImage.isNotEmpty
                                    ? DataCell(InkWell(
                                        onTap: () {
                                          singleBillView(
                                              context, expense.billImage);
                                        },
                                        child: SizedBox(
                                          width: deviceWidth * 0.13,
                                          child: Center(
                                            child: Image(
                                              image: NetworkImage(
                                                  expense.billImage),
                                            ),
                                          ),
                                        ),
                                      ))
                                    : DataCell(Text(
                                        'no bill\n picture found',
                                        style: TextStyle(
                                            fontSize: deviceWidth * 0.03),
                                      ))
                              ]);
                            })),
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader());
              }),
            ),
            SizedBox(
              height: deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}

class Barchart extends ConsumerWidget {
  String shopId;
  String uid;

  Barchart({
    super.key,
    required this.shopId,
    required this.uid,
  });

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
              height: deviceHeight * 0.01,
              child: BarChart(
                BarChartData(
                  barTouchData: barTouchData,
                  titlesData: titlesData,
                  borderData: borderData,
                  barGroups: barGroup,
                  // minY: double.maxFinite,
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
          tooltipMargin: deviceHeight * 0.0001,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Pallete.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  // Convert salesData to BarChartData

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Pallete.secondaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
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
        colors: [
          Pallete.secondaryColor,
          Colors.purple,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

// List<BarChartGroupData> get barGroups => [
//       BarChartGroupData(
//         x: 0,
//         barRods: [
//           BarChartRodData(
//             toY: 8,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 1,
//         barRods: [
//           BarChartRodData(
//             toY: 10,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 2,
//         barRods: [
//           BarChartRodData(
//             toY: 14,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 3,
//         barRods: [
//           BarChartRodData(
//             toY: 15,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 4,
//         barRods: [
//           BarChartRodData(
//             toY: 13,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 5,
//         barRods: [
//           BarChartRodData(
//             toY: 10,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//       BarChartGroupData(
//         x: 6,
//         barRods: [
//           BarChartRodData(
//             toY: 16,
//             gradient: _barsGradient,
//           )
//         ],
//         showingTooltipIndicators: [0],
//       ),
//     ];
}
