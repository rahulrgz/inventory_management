import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../models/sales_model.dart';
import '../../controller/sales_controller.dart';
import 'package:intl/intl.dart';

class SalesScreenMobile extends StatefulWidget {
  final String encode;
  const SalesScreenMobile({super.key, required this.encode});

  @override
  State<SalesScreenMobile> createState() => _SalesScreenMobileState();
}

class _SalesScreenMobileState extends State<SalesScreenMobile> {
  final searchProvider = StateProvider<String>((ref) => '');
  DateTime? _selectedfromDate;
  DateTime? _selectedtoDate;
  TextEditingController searchController = TextEditingController();

  ///Date picker from
  void _pickDateDialogfrom() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedfromDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
      });
    });
  }

  ///date picker to
  void _pickDateDialogto() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedtoDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
      });
    });
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

  pushEncodeAddSale(
      {required String uid,
      required String sid,
      required BuildContext context}) {
    Map<String, dynamic> map = {'sid': sid, 'uid': uid};
    String idEncode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/$sid/Sales/${widget.encode}/${Uri.encodeComponent(idEncode)}');
  }

  pushEncodeParty({required SalesModel sales, required String sid}) {
    Map<String, dynamic> map = {
      'id': sales.id,
      'name': sales.name,
      'saleDate': sales.saleDate.toIso8601String(),
      'products': sales.products,
      'customerId': sales.customerId,
      'totalPrice': sales.totalPrice,
    };
    String encode1 = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/$sid/Sales/${widget.encode}/details/${Uri.encodeComponent(encode1)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: Icon(
            CupertinoIcons.left_chevron,
            size: deviceHeight * 0.03,
          ),
          color: Pallete.secondaryColor,
        ),
        title: Text(
          'SALES',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceHeight * 0.022),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          SizedBox(
            width: deviceWidth,
            // height: deviceHeight * 0.1,
            child: Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.025),
                    child: GestureDetector(
                      onTap: () {
                        _pickDateDialogfrom();
                      },
                      child: Container(
                        width: deviceWidth * 0.35,
                        // height: deviceHeight * 0.06,
                        color: Pallete.primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date From :",
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.032)),
                            SizedBox(
                              height: deviceHeight * 0.007,
                            ),
                            Text(
                              _selectedfromDate == null
                                  ? 'Choose Date'
                                  : DateFormat.yMMMd()
                                      .format(_selectedfromDate!),
                              style: TextStyle(fontSize: deviceWidth * 0.036),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.025),
                    child: GestureDetector(
                      onTap: () {
                        _pickDateDialogto();
                      },
                      child: Container(
                        width: deviceWidth * 0.35,
                        // height: deviceHeight * 0.06,
                        color: Pallete.primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Date to :",
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.032)),
                            SizedBox(
                              height: deviceHeight * 0.007,
                            ),
                            Text(
                                _selectedtoDate == null
                                    ? 'Choose Date'
                                    : DateFormat.yMMMd()
                                        .format(_selectedtoDate!),
                                style:
                                    TextStyle(fontSize: deviceWidth * 0.036)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer(builder: (context, ref, child) {
            return SizedBox(
                height: deviceHeight * 0.06,
                width: deviceWidth * 0.8,
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(deviceWidth * 0.1),
                        borderSide: BorderSide(
                            color: Pallete.secondaryColor,
                            width: deviceWidth * 0.001),
                      ),
                      labelText: 'Search your SL ID',
                      labelStyle: TextStyle(
                        fontSize: deviceHeight * 0.02,
                        color: Pallete.secondaryColor,
                      ),
                      suffixIcon: Consumer(builder: (context, ref, child) {
                        return IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Pallete.secondaryColor,
                          ),
                          onPressed: () {
                            ref
                                .watch(searchProvider.notifier)
                                .update((state) => '');
                            searchController.clear();
                          },
                        );
                      })),
                  controller: searchController,
                  onChanged: (value) => ref
                      .read(searchProvider.notifier)
                      .update((state) => value),
                ));
          }),
          Expanded(
            child: SizedBox(
                child: (_selectedfromDate == null || _selectedtoDate == null)
                    ? Consumer(
                        builder: (context, ref, child) {
                          String temp = ref.watch(searchProvider);
                          Map<String, dynamic> map = {
                            'uid': shop.uid,
                            'sid': shop.shopId,
                            'search': temp.toUpperCase().trim()
                          };
                          return ref
                              .watch(salesStreamProvider(jsonEncode(map)))
                              .when(
                                data: (data) => data.isEmpty
                                    ? const Center(
                                        child: Text('No sales yet.....!'),
                                      )
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          SalesModel sale = data[index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.05,
                                                right: deviceWidth * 0.05,
                                                top: deviceHeight * 0.03),
                                            child: InkWell(
                                              onTap: () {
                                                pushEncodeParty(
                                                    sales: sale,
                                                    sid: shop.shopId);
                                              },
                                              child: Container(
                                                height: deviceHeight * 0.1,
                                                decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Pallete.thirdColor,
                                                      offset: Offset(
                                                        5.0,
                                                        5.0,
                                                      ),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 2.0,
                                                    ), //BoxShadow
                                                    BoxShadow(
                                                      color: Pallete.thirdColor,
                                                      offset: Offset(0.0, 0.0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ), //BoxShadow
                                                  ],
                                                  color: Pallete.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.04),
                                                  border: Border.all(
                                                      color:
                                                          Pallete.thirdColor),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      deviceWidth * 0.025),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${sale.id}:  ${sale.name}',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.02,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                              DateFormat(
                                                                      'dd/mm/yyyy    hh:mm:ss a')
                                                                  .format(sale
                                                                      .saleDate),
                                                              style: TextStyle(
                                                                  color: Pallete
                                                                      .secondaryColor,
                                                                  fontSize:
                                                                      deviceHeight *
                                                                          0.012)),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          SizedBox(
                                                            width: deviceWidth *
                                                                0.3,
                                                            child: Center(
                                                              child: Text(
                                                                '₹ ${sale.totalPrice}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        deviceHeight *
                                                                            0.02,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Pallete
                                                                        .secondaryColor),
                                                              ),
                                                            ),
                                                          ),
                                                          // Text(
                                                          //   'You\'ll Get',
                                                          //   style: TextStyle(
                                                          //       color: Colors
                                                          //           .green,
                                                          //       fontSize:
                                                          //           deviceHeight *
                                                          //               0.012),
                                                          // )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                error: (error, stackTrace) => ErrorText(
                                  error: error.toString(),
                                ),
                                loading: () => const Loader(),
                              );
                        },
                      )
                    : Consumer(builder: (context, ref, child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'fDate': _selectedfromDate!.toIso8601String(),
                          'tDate': _selectedtoDate!.toIso8601String(),
                          'search': temp.toUpperCase().trim()
                        };
                        return ref
                            .watch(sortedSalesStreamProvider(jsonEncode(map)))
                            .when(
                              data: (data) => data.isEmpty
                                  ? const Center(
                                      child: Text('No sales yet.....!'),
                                    )
                                  : ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        SalesModel sale = data[index];
                                        return InkWell(
                                          onTap: () {
                                            pushEncodeParty(
                                                sales: sale, sid: shop.shopId);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.05,
                                                right: deviceWidth * 0.05,
                                                top: deviceHeight * 0.03),
                                            child: Container(
                                              height: deviceHeight * 0.1,
                                              decoration: BoxDecoration(
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Pallete.thirdColor,
                                                    offset: Offset(
                                                      5.0,
                                                      5.0,
                                                    ),
                                                    blurRadius: 10.0,
                                                    spreadRadius: 2.0,
                                                  ), //BoxShadow
                                                  BoxShadow(
                                                    color: Pallete.thirdColor,
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 0.0,
                                                    spreadRadius: 0.0,
                                                  ), //BoxShadow
                                                ],
                                                color: Pallete.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Pallete.thirdColor),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    deviceWidth * 0.025),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          ' SL${sale.id}:  ${sale.name}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Pallete
                                                                  .secondaryColor),
                                                        ),
                                                        Text(
                                                            DateFormat(
                                                                    'dd/mm/yyyy    hh:mm:ss a')
                                                                .format(sale
                                                                    .saleDate),
                                                            style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontSize:
                                                                    deviceHeight *
                                                                        0.012)),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '₹ ${sale.totalPrice}',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.02,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Pallete
                                                                  .secondaryColor),
                                                        ),
                                                        Text(
                                                          'You\'ll Get',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize:
                                                                  deviceHeight *
                                                                      0.012),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                              error: (error, stackTrace) => ErrorText(
                                error: error.toString(),
                              ),
                              loading: () => const Loader(),
                            );
                      })),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceWidth * 0.05,
                right: deviceWidth * 0.05,
                bottom: deviceHeight * 0.03),
            child: InkWell(
              onTap: () {
                pushEncodeAddSale(
                    uid: shop.uid, sid: shop.shopId, context: context);
              },
              child: Container(
                  height: deviceHeight * 0.07,
                  // width: deviceWidth * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Pallete.secondaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Icon(
                        Icons.add_circle_outline_sharp,
                        color: Pallete.primaryColor,
                        size: deviceWidth * 0.04,
                      )),
                      SizedBox(width: deviceWidth * 0.01),
                      Text(
                        'Add Sales ',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.04,
                            color: Pallete.primaryColor),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
