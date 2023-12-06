import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:intl/intl.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../controller/purchase_controller.dart';

class PurchaseScreenMobile extends StatefulWidget {
  final String encode;

  const PurchaseScreenMobile({super.key, required this.encode});

  @override
  State<PurchaseScreenMobile> createState() => _PurchaseScreenMobileState();
}

class _PurchaseScreenMobileState extends State<PurchaseScreenMobile> {
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  TextEditingController searchController = TextEditingController();

  DateTime? _selectedfromDate;
  DateTime? _selectedtoDate;

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

  ShopModel decode(String encode) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(encode));
    return ShopModel(
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
  }

  pushEncodePurch(String uid, String sid, BuildContext context) {
    Map<String, dynamic> map = {'sid': sid, 'uid': uid};
    String idEncode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/$sid/Purchase/${widget.encode}/${Uri.encodeComponent(idEncode)}');
  }

  pushEncodeParty({required PurchaseModel purchase, required String sid}) {
    Map<String, dynamic> map = {
      'supplierId': purchase.supplierId,
      'id': purchase.id,
      'name': purchase.name,
      'products': purchase.products,
      'purchaseDate': purchase.purchaseDate.toIso8601String(),
      'totalPrice': purchase.totalPrice,
    };
    String encode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/$sid/Purchase/${widget.encode}/details/${Uri.encodeComponent(encode)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode(widget.encode);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Pallete.primaryColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            icon: const Icon(CupertinoIcons.left_chevron),
            color: Pallete.secondaryColor,
          ),
          title: Text(
            'PURCHASE',
            style: TextStyle(
              fontSize: deviceHeight * 0.022,
              color: Pallete.secondaryColor,
              // fontWeight: FontWeight.bold,
            ),
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
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.1),
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.1),
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.1),
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.1),
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                        ),
                        labelText: 'Search your PS ID',
                        labelStyle: TextStyle(
                          fontSize: deviceHeight * 0.02,
                          color: Pallete.secondaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            ref
                                .watch(searchProvider.notifier)
                                .update((state) => '');
                            searchController.clear();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Pallete.secondaryColor,
                          ),
                        )),
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
                                .watch(purchasesStreamProvider(jsonEncode(map)))
                                .when(
                                  data: (data) => data.isEmpty
                                      ? const Center(
                                          child: Text('No purchases yet.....!'),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            var purchase = data[index];
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: deviceWidth * 0.05,
                                                  right: deviceWidth * 0.05,
                                                  top: deviceHeight * 0.03),
                                              child: GestureDetector(
                                                onTap: () {
                                                  pushEncodeParty(
                                                      purchase: purchase,
                                                      sid: shop.shopId);
                                                },
                                                child: Container(
                                                  height: deviceHeight * 0.1,
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color:
                                                            Pallete.thirdColor,
                                                        offset: Offset(
                                                          5.0,
                                                          5.0,
                                                        ),
                                                        blurRadius: 10.0,
                                                        spreadRadius: 2.0,
                                                      ), //BoxShadow
                                                      BoxShadow(
                                                        color:
                                                            Pallete.thirdColor,
                                                        offset:
                                                            Offset(0.0, 0.0),
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
                                                              '${purchase.id} : ${purchase.name}',
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
                                                                    .format(purchase
                                                                        .purchaseDate),
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
                                                              width:
                                                                  deviceWidth *
                                                                      0.3,
                                                              child: Text(
                                                                '₹ ${purchase.totalPrice}',
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
                                                            Text(
                                                              'You\'ll Get',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
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
                              .watch(
                                  sortedPurchaseStreamProvider(jsonEncode(map)))
                              .when(
                                data: (data) => data.isEmpty
                                    ? const Center(
                                        child: Text('No sales yet.....!'),
                                      )
                                    : ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          var purchase = data[index];
                                          return InkWell(
                                            onTap: () {
                                              pushEncodeParty(
                                                  purchase: purchase,
                                                  sid: shop.shopId);
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
                                                      color:
                                                          Pallete.thirdColor),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title: Text(
                                                      purchase.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Pallete
                                                              .secondaryColor),
                                                    ),
                                                    subtitle: Text(
                                                        DateFormat(
                                                                'dd/mm/yyyy    hh:mm:ss a')
                                                            .format(purchase
                                                                .purchaseDate),
                                                        style: TextStyle(
                                                            color: Pallete
                                                                .secondaryColor,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.012)),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '₹ ${purchase.totalPrice}',
                                                          style: const TextStyle(
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
                                                                      0.01),
                                                        )
                                                      ],
                                                    ),
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
                  pushEncodePurch(shop.uid, shop.shopId, context);
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
                          'Add Purchase ',
                          style: TextStyle(
                              fontSize: deviceWidth * 0.04,
                              color: Pallete.primaryColor),
                        )
                      ],
                    )),
              ),
            )
          ],
        ));
  }
}
