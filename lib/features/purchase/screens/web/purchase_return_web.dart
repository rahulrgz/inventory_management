import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/alert_dialog_boxes_web.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

class PurchaseReturnScreenWeb extends ConsumerStatefulWidget {
  final String shopId;
  const PurchaseReturnScreenWeb({super.key, required this.shopId});

  @override
  ConsumerState<PurchaseReturnScreenWeb> createState() =>
      _PurchaseReturnScreenWebState();
}

class _PurchaseReturnScreenWebState
    extends ConsumerState<PurchaseReturnScreenWeb> {
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

  calculateTotalReturnPurchase(
      {required List<PurchaseReturnModel> purchaseReturn}) {
    double tot = 0;
    for (var i in purchaseReturn) {
      tot = tot + double.parse(i.total);
    }
    return tot;
  }

  pushEncodeParty({required PurchaseReturnModel pr}) {
    Map<String, dynamic> map = {
      'purchaseId': pr.purchaseId,
      'purchaseReturnId': pr.purchaseReturnId,
      'purchaseReturnDate': pr.purchaseReturnDate.toIso8601String(),
      'products': pr.products,
      'total': pr.total,
      'search': []
    };
    String enc = jsonEncode(map);
    Routemaster.of(context).push(
        "/store/homescreen/${widget.shopId}/purchasesReturn/${Uri.encodeComponent(enc)}/purchaseReturnSingle");
  }

  int dataLength = 0;
  @override
  Widget build(BuildContext context) {
    var uid = ref.watch(userProvider)!.uid;

    Map<String, dynamic> map = {'uid': uid, 'sid': widget.shopId, 'search': ''};
    dataLength = ref
            .watch(purchaseReturnStreamProvider(jsonEncode(map)))
            .value
            ?.length ??
        10;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: deviceHeight * 0.03),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => Routemaster.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallete.secondaryColor,
                    // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(deviceHeight * 0.02),
                      bottomRight: Radius.circular(deviceHeight * 0.02),
                    )),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.arrow_back_rounded,
                    color: Pallete.primaryColor,
                    size: deviceHeight * 0.03,
                  )),
                ),
                SizedBox(
                  width: deviceWidth * 0.4,
                ),
                Text(
                  "Purchase Return",
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth * .02,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: deviceWidth * 0.01,
                ),
                Container(
                  width: deviceWidth * 0.3,
                  decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    autofocus: false,
                    controller: searchController,
                    onChanged: (value) => ref
                        .read(searchProvider.notifier)
                        .update((state) => value),
                    cursorColor: Pallete.primaryColor,
                    style: const TextStyle(color: Pallete.primaryColor),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        contentPadding: EdgeInsets.all(deviceWidth * 0.0075),
                        hintStyle: const TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .watch(searchProvider.notifier)
                                  .update((state) => '');
                              searchController.clear();
                            },
                            icon: Icon(Icons.close))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.05, left: deviceWidth * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickDateDialogfrom();
                      },
                      child: Container(
                        height: deviceHeight * 0.1,
                        width: deviceWidth * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Pallete.containerColor),
                        child: Column(
                          children: [
                            Column(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.005,
                                    top: deviceHeight * 0.02),
                                child: Text('Date from',
                                    style: TextStyle(
                                        color: Pallete.secondaryColor,
                                        fontSize: deviceWidth * 0.012)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.07,
                                    top: deviceHeight * 0.001),
                                child: Row(
                                  children: [
                                    Text(
                                        _selectedfromDate == null
                                            ? 'choose Date'
                                            : DateFormat.yMMMd()
                                                .format(_selectedfromDate!),
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.011)),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Pallete.secondaryColor,
                                      size: deviceWidth * 0.013,
                                    )
                                  ],
                                ),
                              )
                            ])
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: deviceWidth * 0.05),
                    GestureDetector(
                      onTap: () {
                        _pickDateDialogto();
                      },
                      child: Container(
                        height: deviceHeight * 0.1,
                        width: deviceWidth * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Pallete.containerColor,
                        ),
                        child: Column(
                          children: [
                            Column(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.008,
                                    top: deviceHeight * 0.02),
                                child: Text('Date to',
                                    style: TextStyle(
                                        color: Pallete.secondaryColor,
                                        fontSize: deviceWidth * 0.012)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.07,
                                    top: deviceHeight * 0.001),
                                child: Row(
                                  children: [
                                    Text(
                                        _selectedtoDate == null
                                            ? 'choose Date'
                                            : DateFormat.yMMMd()
                                                .format(_selectedtoDate!),
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.011)),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Pallete.secondaryColor,
                                      size: deviceWidth * 0.013,
                                    )
                                  ],
                                ),
                              )
                            ])
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.25, top: deviceHeight * 0.05),
                    child: Column(
                      children: [
                        Container(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Pallete.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Shadow color
                                offset: Offset(0,
                                    4), // Shadow position, (horizontal, vertical)
                                blurRadius: 8, // Shadow blur radius
                                spreadRadius: 0, // Shadow spread radius
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.001,
                                      top: deviceHeight * 0.02),
                                  child: Text('No.of Txns',
                                      style: TextStyle(
                                          color: Pallete.secondaryColor,
                                          fontSize: deviceWidth * 0.012)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.022,
                                      top: deviceHeight * 0.001),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$dataLength',
                                        style: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.011,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.04,
                        ),
                        Container(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Pallete.primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Shadow color
                                offset: Offset(0,
                                    4), // Shadow position, (horizontal, vertical)
                                blurRadius: 8, // Shadow blur radius
                                spreadRadius: 0, // Shadow spread radius
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Column(children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.001,
                                      top: deviceHeight * 0.02),
                                  child: Text('Total PurchaseReturn',
                                      style: TextStyle(
                                          color: Pallete.secondaryColor,
                                          fontSize: deviceWidth * 0.01)),
                                ),
                                Consumer(builder: (context, ref, child) {
                                  Map<String, dynamic> map = {
                                    'sid': widget.shopId,
                                    'uid': uid,
                                  };

                                  return ref
                                      .watch(totalPurchaseReturnProvider(
                                          jsonEncode(map)))
                                      .when(
                                        data: (data) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.022,
                                                top: deviceHeight * 0.001),
                                            child: Row(
                                              children: [
                                                Text(
                                                  calculateTotalReturnPurchase(
                                                          purchaseReturn: data)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Pallete
                                                          .secondaryColor,
                                                      fontSize:
                                                          deviceWidth * 0.01,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, stackTrace) =>
                                            ErrorText(error: error.toString()),
                                        loading: () => Loader(),
                                      );
                                })
                              ])
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.04,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                        right: deviceWidth * 0.2, top: deviceHeight * 0.03),
                    child: Column(
                      children: [
                        (_selectedfromDate == null || _selectedtoDate == null)
                            ? Consumer(builder:
                                (BuildContext context, WidgetRef ref, child) {
                                var uid = ref.watch(userProvider)!.uid;
                                String temp = ref.watch(searchProvider);

                                Map<String, dynamic> map = {
                                  'uid': uid,
                                  'sid': widget.shopId,
                                  'search': temp.toUpperCase().trim()
                                };
                                return Container(
                                    height: deviceHeight * 0.52,
                                    width: deviceWidth * 0.4,
                                    child:
                                        ref
                                            .watch(purchaseReturnStreamProvider(
                                                jsonEncode(map)))
                                            .when(
                                              data: (data) => data.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                          'NO PURCHASE RETURN FOUND! \n PLEASE CHECK '))
                                                  : ListView.builder(
                                                      itemCount: data.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        PurchaseReturnModel pr =
                                                            data[index];
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom:
                                                                  deviceHeight *
                                                                      0.03,
                                                              top:
                                                                  deviceHeight *
                                                                      0.01),
                                                          child: InkWell(
                                                            onTap: () {
                                                              pushEncodeParty(
                                                                  pr: pr);
                                                            },
                                                            child: Container(
                                                              height:
                                                                  deviceHeight *
                                                                      0.15,
                                                              width:
                                                                  deviceWidth *
                                                                      0.005,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Pallete
                                                                    .containerColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    // Shadow color
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            4),
                                                                    // Shadow position, (horizontal, vertical)
                                                                    blurRadius:
                                                                        8,
                                                                    // Shadow blur radius
                                                                    spreadRadius:
                                                                        0, // Shadow spread radius
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(
                                                                    top: deviceHeight *
                                                                        0.05),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: deviceHeight * 0.01,
                                                                              left: deviceWidth * 0.04),
                                                                          child: Text(
                                                                              pr.purchaseId,
                                                                              style: TextStyle(color: Pallete.secondaryColor, fontSize: deviceWidth * 0.013, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Spacer(),
                                                                        Padding(
                                                                          padding: EdgeInsets.only(
                                                                              top: deviceHeight * 0.01,
                                                                              right: deviceWidth * 0.04),
                                                                          child: Text(
                                                                              '\u{20B9}${pr.total}',
                                                                              style: TextStyle(color: Pallete.secondaryColor, fontSize: deviceWidth * 0.013, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height: deviceHeight *
                                                                            0.01),
                                                                    Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(left: deviceWidth * 0.06),
                                                                          child: Text(
                                                                              DateFormat('dd-MM-yyyy').format(pr.purchaseReturnDate),
                                                                              style: TextStyle(
                                                                                color: Pallete.secondaryColor,
                                                                                fontSize: deviceWidth * 0.009,
                                                                              )),
                                                                        ),
                                                                        Spacer(),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(right: deviceWidth * 0.045),
                                                                          child: Text(
                                                                              "You'll Get",
                                                                              style: TextStyle(
                                                                                color: Colors.green,
                                                                                fontSize: deviceWidth * 0.009,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                              error: (error, stackTrace) =>
                                                  ErrorText(
                                                      error: error.toString()),
                                              loading: () => Loader(),
                                            ));
                              })
                            : Consumer(builder:
                                (BuildContext context, WidgetRef ref, child) {
                                var uid = ref.watch(userProvider)!.uid;
                                String temp = ref.watch(searchProvider);

                                Map<String, dynamic> map = {
                                  'uid': uid,
                                  'sid': widget.shopId,
                                  'fDate': _selectedfromDate!.toIso8601String(),
                                  'tDate': _selectedtoDate!.toIso8601String(),
                                  'search': temp.toUpperCase().trim()
                                };
                                return Container(
                                    height: deviceHeight * 0.52,
                                    width: deviceWidth * 0.4,
                                    child: ref
                                        .watch(
                                            sortedPurchaseReturnStreamProvider(
                                                jsonEncode(map)))
                                        .when(
                                          data: (data) => data.isEmpty
                                              ? Center(
                                                  child: Text(
                                                      'NO PURCHASE RETURN FOUND! \n PLEASE CHECK '))
                                              : ListView.builder(
                                                  itemCount: data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    PurchaseReturnModel pr =
                                                        data[index];
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: deviceHeight *
                                                              0.03,
                                                          top: deviceHeight *
                                                              0.01),
                                                      child: InkWell(
                                                        onTap: () {
                                                          pushEncodeParty(
                                                              pr: pr);
                                                        },
                                                        child: Container(
                                                          height: deviceHeight *
                                                              0.15,
                                                          width: deviceWidth *
                                                              0.005,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Pallete
                                                                .containerColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                // Shadow color
                                                                offset: Offset(
                                                                    0, 4),
                                                                // Shadow position, (horizontal, vertical)
                                                                blurRadius: 8,
                                                                // Shadow blur radius
                                                                spreadRadius:
                                                                    0, // Shadow spread radius
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.only(
                                                                top:
                                                                    deviceHeight *
                                                                        0.05),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: deviceHeight *
                                                                              0.01,
                                                                          left: deviceWidth *
                                                                              0.04),
                                                                      child: Text(
                                                                          pr
                                                                              .purchaseId,
                                                                          style: TextStyle(
                                                                              color: Pallete.secondaryColor,
                                                                              fontSize: deviceWidth * 0.013,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: deviceHeight *
                                                                              0.01,
                                                                          right:
                                                                              deviceWidth * 0.04),
                                                                      child: Text(
                                                                          '\u{20B9}${pr.total}',
                                                                          style: TextStyle(
                                                                              color: Pallete.secondaryColor,
                                                                              fontSize: deviceWidth * 0.013,
                                                                              fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        deviceHeight *
                                                                            0.01),
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left: deviceWidth *
                                                                              0.06),
                                                                      child: Text(
                                                                          DateFormat('dd-MM-yyyy').format(pr
                                                                              .purchaseReturnDate),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Pallete.secondaryColor,
                                                                            fontSize:
                                                                                deviceWidth * 0.009,
                                                                          )),
                                                                    ),
                                                                    Spacer(),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              deviceWidth * 0.045),
                                                                      child: Text(
                                                                          "You'll Get",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontSize:
                                                                                deviceWidth * 0.009,
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                  error: error.toString()),
                                          loading: () => Loader(),
                                        ));
                              }),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceHeight * 0.02),
              GestureDetector(
                onTap: () => Routemaster.of(context).push(
                    '/store/homescreen/${widget.shopId}/purchasesReturn/addPurchaseReturn'),
                child: Container(
                    height: deviceHeight * 0.09,
                    width: deviceWidth * 0.25,
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
                          size: deviceWidth * 0.013,
                        )),
                        SizedBox(width: deviceWidth * 0.001),
                        Text(
                          'Add Purchase Return',
                          style: TextStyle(
                              fontSize: deviceWidth * 0.013,
                              color: Pallete.primaryColor),
                        )
                      ],
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
