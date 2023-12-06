import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/models/purchase_return_model.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../controller/purchase_controller.dart';

class PurchaseReturnTab extends ConsumerStatefulWidget {
  final String encode;
  const PurchaseReturnTab({super.key, required this.encode});
  @override
  ConsumerState<PurchaseReturnTab> createState() => _PurchaseReturnTabState();
}

class _PurchaseReturnTabState extends ConsumerState<PurchaseReturnTab> {
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  TextEditingController searchController = TextEditingController();
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });

  calculateTotalReturnPurchase(
      {required List<PurchaseReturnModel> purchaseReturn}) {
    double tot = 0;
    for (var i in purchaseReturn) {
      tot = tot + double.parse(i.total);
    }
    return tot;
  }

  decode(String encode) {
    Map<String, dynamic> decode = jsonDecode(Uri.decodeComponent(encode));
    ShopModel shop = ShopModel(
      uid: decode['uid'],
      category: decode['category'],
      name: decode['name'],
      shopId: decode['shopId'],
      subscriptionId: decode['subscriptionId'],
      createdTime: DateTime.parse(decode['createdTime']),
      shopProfile: decode['shopProfile'],
      deleted: decode['deleted'],
      setSearch: List<String>.from(decode['setSearch']),
      accepted: decode['accepted'],
      blocked: decode['blocked'],
      reason: decode['reason'],
      expirationDate: DateTime.now(),
    );
    return shop;
  }

  pushEncodeParty({required PurchaseReturnModel pr}) {
    Map<String, dynamic> map = {
      'purchaseId': pr.purchaseId,
      'purchaseReturnId': pr.purchaseReturnId,
      'purchaseReturnDate': pr.purchaseReturnDate.toIso8601String(),
      'products': pr.products,
      'total': pr.total,
    };
    String enc = jsonEncode(map);
    Routemaster.of(context).push("prp/${Uri.encodeComponent(enc)}");
  }

  int dataLength = 0;
  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode(widget.encode);
    Map<String, dynamic> map = {
      'uid': shop.uid,
      'sid': shop.shopId,
      'search': ''
    };
    dataLength = ref
            .watch(purchaseReturnStreamProvider(jsonEncode(map)))
            .value
            ?.length ??
        10;
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: deviceHeight * 0.13,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop('/store/homescreen/:shop');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
            )),
        title: const Text(
          "Purchase Return",
          style: TextStyle(
              color: Pallete.secondaryColor, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: deviceHeight * 0.003),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: deviceWidth * 0.03,
            ),
            Column(
              children: [
                SizedBox(
                  width: deviceWidth * 0.03,
                ),
                InkWell(
                  onTap: () async {
                    selectedFromDate = await pickDateFrom(context: context);
                    setState(() {});
                  },
                  child: Container(
                    height: deviceWidth * 0.07,
                    width: deviceWidth * 0.15,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(4, 4))
                        ],
                        color: Pallete.thirdColor,
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        const Text("Date From :"),
                        SizedBox(
                          height: deviceHeight * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(selectedFromDate == null
                                ? 'Choose Date'
                                : DateFormat.yMMMd().format(selectedFromDate!)),
                            const Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                InkWell(
                  onTap: () async {
                    selectedToDate = await pickDateTo(context: context);
                    setState(() {});
                  },
                  child: Container(
                    height: deviceWidth * 0.07,
                    width: deviceWidth * 0.15,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(4, 4))
                        ],
                        color: Pallete.thirdColor,
                        borderRadius:
                            BorderRadius.circular(deviceHeight * 0.02)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        const Text("Date To :"),
                        SizedBox(
                          height: deviceHeight * 0.005,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(selectedToDate == null
                                ? 'Choose Date'
                                : DateFormat.yMMMd().format(selectedToDate!)),
                            const Icon(Icons.keyboard_arrow_down)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: deviceWidth * 0.05,
            ),
            SizedBox(
              width: deviceWidth * 0.4,
              child: (selectedFromDate == null || selectedToDate == null)
                  ? Consumer(
                      builder: (context, ref, child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'search': temp.toUpperCase().trim()
                        };
                        return ref
                            .watch(
                                purchaseReturnStreamProvider(jsonEncode(map)))
                            .when(
                              data: (data) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Pallete.primaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white70,
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                        offset: Offset(1, 1),
                                      )
                                    ],
                                  ),
                                  width: deviceWidth * 0.45,
                                  height: deviceHeight,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        PurchaseReturnModel purchaseReturn =
                                            data[index];
                                        return InkWell(
                                          onTap: () {
                                            pushEncodeParty(pr: purchaseReturn);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                deviceWidth * 0.01),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceHeight * 0.03)),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    deviceHeight * 0.01),
                                                child: ListTile(
                                                  title: Text(
                                                    'Bill No : ${purchaseReturn.purchaseId}',
                                                    style: TextStyle(
                                                        color: Pallete
                                                            .secondaryColor,
                                                        fontSize: deviceHeight *
                                                            0.033,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                      DateFormat('yMMMd')
                                                          .format(purchaseReturn
                                                              .purchaseReturnDate),
                                                      style: TextStyle(
                                                          color: Pallete
                                                              .secondaryColor,
                                                          fontSize:
                                                              deviceHeight *
                                                                  0.025)),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          '₹ ${purchaseReturn.total}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Pallete
                                                                .secondaryColor,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.03,
                                                          )),
                                                      Text(
                                                        'Successfully Returned',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.017),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      },
                    )
                  : Consumer(
                      builder: (context, ref, child) {
                        String temp = ref.watch(searchProvider);
                        Map<String, dynamic> map = {
                          'uid': shop.uid,
                          'sid': shop.shopId,
                          'search': temp.toUpperCase().trim(),
                          'fDate': selectedFromDate!.toIso8601String(),
                          'tDate': selectedToDate!.toIso8601String()
                        };
                        return ref
                            .watch(sortedPurchaseReturnStreamProvider(
                                jsonEncode(map)))
                            .when(
                              data: (data) {
                                return SizedBox(
                                  height: deviceHeight,
                                  width: deviceWidth * 0.4,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: data.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        PurchaseReturnModel purchaseReturn =
                                            data[index];
                                        return InkWell(
                                          onTap: () {
                                            pushEncodeParty(pr: purchaseReturn);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                deviceWidth * 0.01),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceHeight * 0.03)),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    deviceHeight * 0.01),
                                                child: ListTile(
                                                  title: Text(
                                                    'Bill No : ${purchaseReturn.purchaseId}',
                                                    style: TextStyle(
                                                        color: Pallete
                                                            .secondaryColor,
                                                        fontSize: deviceHeight *
                                                            0.033,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: Text(
                                                      DateFormat('yMMMd')
                                                          .format(purchaseReturn
                                                              .purchaseReturnDate),
                                                      style: TextStyle(
                                                          color: Pallete
                                                              .secondaryColor,
                                                          fontSize:
                                                              deviceHeight *
                                                                  0.025)),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                          '₹ ${purchaseReturn.total}',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Pallete
                                                                .secondaryColor,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.03,
                                                          )),
                                                      Text(
                                                        'Successfully Returned',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.017),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              },
                              error: (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                              loading: () => const Loader(),
                            );
                      },
                    ),
            ),
            SizedBox(
              width: deviceWidth * 0.05,
            ),
            Column(
              children: [
                Consumer(
                  builder: (context, ref, child) => SizedBox(
                    height: deviceHeight * 0.1,
                    width: deviceWidth * 0.27,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Search Data",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.03))),
                      onChanged: (value) => ref
                          .read(searchProvider.notifier)
                          .update((state) => value),
                      controller: searchController,
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                Container(
                  height: deviceWidth * 0.07,
                  width: deviceWidth * 0.27,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 1,
                            offset: Offset(4, 4))
                      ],
                      color: Pallete.thirdColor,
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02)),
                  child: Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No of Transactions",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceHeight * 0.02,
                              color: Pallete.secondaryColor),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.006,
                        ),
                        Text(
                          '$dataLength',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: deviceHeight * 0.03),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                Consumer(builder: (context, ref, child) {
                  Map<String, dynamic> map = {
                    'sid': shop.shopId,
                    'uid': shop.uid,
                  };
                  return ref
                      .watch(totalPurchaseReturnProvider(jsonEncode(map)))
                      .when(
                        data: (data) {
                          return Container(
                            height: deviceWidth * 0.07,
                            width: deviceWidth * 0.27,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(4, 4))
                                ],
                                color: Pallete.thirdColor,
                                borderRadius:
                                    BorderRadius.circular(deviceHeight * 0.02)),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: deviceWidth * 0.02),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Purchase Return",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceHeight * 0.02,
                                        color: Pallete.secondaryColor),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.006,
                                  ),
                                  Text(
                                    calculateTotalReturnPurchase(
                                            purchaseReturn: data)
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: deviceHeight * 0.03),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                }),
                SizedBox(
                  height: deviceHeight * 0.05,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: deviceHeight * 0.03),
                  child: InkWell(
                    onTap: () => Routemaster.of(context).push(
                        '/store/${shop.shopId}/Purchase_Return/${widget.encode}/addPurchase_Return'),
                    child: Container(
                      height: deviceWidth * 0.05,
                      width: deviceWidth * 0.25,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          color: Pallete.secondaryColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_outlined,
                            color: Pallete.primaryColor,
                            size: deviceHeight * 0.03,
                          ),
                          Text(
                            " Add Purchase return",
                            style: TextStyle(
                                color: Pallete.primaryColor,
                                fontSize: deviceWidth * 0.013),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: deviceWidth * 0.03,
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
