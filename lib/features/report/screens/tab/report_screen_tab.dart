import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/sales_model.dart';
import '../../../stocks/controller/stock_controller.dart';
import '../../controller/report_controller.dart';

bool choice = true;

class ReportScreenTab extends ConsumerStatefulWidget {
  final ShopModel shop;
  const ReportScreenTab({super.key, required this.shop});
  @override
  ConsumerState<ReportScreenTab> createState() => _ReportScreenTabState();
}

class _ReportScreenTabState extends ConsumerState<ReportScreenTab> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  encodeAndNavigate(
      {required ShopModel shop,
      required String pageCategory,
      required BuildContext context}) {
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
      'reason': shop.reason
    };
    final String encode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/${shop.shopId}/$pageCategory/${Uri.encodeComponent(encode)}');
    return encode;
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

  calculateTotalPurchase({required List<PurchaseModel> purchase}) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;
    double total = 0;
    for (var i in purchase) {
      DateTime purchaseDate = DateTime.parse(i.purchaseDate.toString());
      if (purchaseDate.month == currentMonth &&
          purchaseDate.year == currentYear) {
        total = total + double.parse(i.totalPrice);
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        title: Text(
          'Reports',
          style: TextStyle(
              color: Pallete.secondaryColor,
              fontWeight: FontWeight.w600,
              fontSize: deviceHeight * 0.04),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Consumer(builder: (context, ref, child) {
                    Map<String, dynamic> map = {
                      'sid': widget.shop.shopId,
                      'uid': widget.shop.uid,
                    };
                    return ref.watch(totalSale(jsonEncode(map))).when(
                          data: (data) {
                            return Padding(
                              padding: EdgeInsets.all(deviceHeight * 0.01),
                              child: Container(
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
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth * 0.02),
                                  color: Pallete.primaryColor,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: deviceWidth * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.shopping_cart_rounded,
                                            color: Pallete.secondaryColor,
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.007,
                                          ),
                                          Text(
                                            '₹ ${calculateTotalSale(sale: data)}',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: deviceHeight * 0.03),
                                          ),
                                          Text(
                                            'Total Sales This Month',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontSize: deviceHeight * 0.02),
                                          )
                                        ],
                                      )
                                    ],
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
                    String temp = ref.watch(searchProvider);
                    Map<String, dynamic> map = {
                      'sid': widget.shop.shopId,
                      'uid': widget.shop.uid,
                      'search': temp.toUpperCase().trim()
                    };
                    return ref
                        .watch(purchasesStreamProvider(jsonEncode(map)))
                        .when(
                          data: (data) {
                            return Padding(
                              padding: EdgeInsets.all(deviceHeight * 0.01),
                              child: Container(
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
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth * 0.02),
                                  color: Pallete.primaryColor,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: deviceWidth * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.shopping_basket_rounded,
                                            color: Pallete.secondaryColor,
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.007,
                                          ),
                                          Text(
                                            '₹ ${calculateTotalPurchase(purchase: data)}',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: deviceHeight * 0.03),
                                          ),
                                          Text(
                                            'Total Purchase This Month',
                                            style: TextStyle(
                                                color: Pallete.secondaryColor,
                                                fontSize: deviceHeight * 0.02),
                                          )
                                        ],
                                      )
                                    ],
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
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.1,
                  ),
                  choice == true
                      ? AspectRatio(
                          aspectRatio: 0.95,
                          child: SalesBarchart(
                              shopId: widget.shop.shopId, uid: widget.shop.uid),
                        )
                      : AspectRatio(
                          aspectRatio: 0.95,
                          child: PurchaseBarchart(
                              shopId: widget.shop.shopId, uid: widget.shop.uid),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(deviceHeight * 0.01),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(deviceWidth * 0.02),
                  color: Pallete.primaryColor,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      choice == true
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.05),
                                color: Pallete.secondaryColor,
                              ),
                              child: ListTile(
                                onTap: () {
                                  choice = true;
                                  setState(() {});
                                },
                                leading: Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Pallete.primaryColor,
                                  size: deviceHeight * 0.045,
                                ),
                                title: Text(
                                  'Sales Weak Report',
                                  style: TextStyle(
                                      fontSize: deviceHeight * 0.03,
                                      color: Pallete.primaryColor),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.05),
                                color: Colors.grey,
                              ),
                              child: ListTile(
                                onTap: () {
                                  choice = true;
                                  setState(() {});
                                },
                                leading: Icon(
                                  Icons.shopping_cart_rounded,
                                  color: Pallete.secondaryColor,
                                  size: deviceHeight * 0.045,
                                ),
                                title: Text(
                                  'Sales Weak Report',
                                  style:
                                      TextStyle(fontSize: deviceHeight * 0.03),
                                ),
                              ),
                            ),
                      SizedBox(height: deviceHeight * 0.1),
                      choice == false
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.05),
                                color: Pallete.secondaryColor,
                              ),
                              child: ListTile(
                                onTap: () {
                                  choice = false;
                                  setState(() {});
                                },
                                leading: Icon(
                                  Icons.shopping_basket_rounded,
                                  color: Pallete.primaryColor,
                                  size: deviceHeight * 0.045,
                                ),
                                title: Text(
                                  'Purchase Weak Report',
                                  style: TextStyle(
                                      fontSize: deviceHeight * 0.03,
                                      color: Pallete.primaryColor),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.05),
                                color: Colors.grey,
                              ),
                              child: ListTile(
                                onTap: () {
                                  choice = false;
                                  setState(() {});
                                },
                                leading: Icon(
                                  Icons.shopping_basket_rounded,
                                  color: Pallete.secondaryColor,
                                  size: deviceHeight * 0.045,
                                ),
                                title: Text(
                                  'Purchase Weak Report',
                                  style:
                                      TextStyle(fontSize: deviceHeight * 0.03),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalesBarchart extends ConsumerWidget {
  final String shopId;
  final String uid;

  const SalesBarchart({
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
          loading: () => const Loader(),
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
                color: Pallete.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

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
}

class PurchaseBarchart extends ConsumerWidget {
  final String shopId;
  final String uid;

  const PurchaseBarchart({
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
    return ref.watch(reportPurchaseStreamProvider(jsonEncode(map))).when(
          data: (data) {
            List<double> dailySales = calculateDailyPurchase(data);

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
          loading: () => const Loader(),
        );
  }

  List<double> calculateDailyPurchase(List<PurchaseModel> purchaseData) {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday));
    List<double> dailyPurchase = List.generate(7, (index) => 0.0);
    for (var purchase in purchaseData) {
      DateTime saleDate = DateTime.parse(purchase.purchaseDate.toString());
      if (saleDate.isAfter(firstDayOfWeek)) {
        int dayOfWeek = saleDate.weekday - 1;
        dailyPurchase[dayOfWeek] += double.parse(purchase.totalPrice);
      }
    }
    for (int i = 0; i < dailyPurchase.length; i++) {
      if (dailyPurchase[i] > 9000000) {
        dailyPurchase[i] = 90000;
      }
    }
    return dailyPurchase;
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
                color: Pallete.secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

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
}
