import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/features/addstore/controller/addstore_controller.dart';
import 'package:inventory_management_shop/features/purchase/controller/purchase_controller.dart';
import 'package:inventory_management_shop/models/purchase_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class PurchaseScreenWeb extends StatefulWidget {
  final String shopId;
  const PurchaseScreenWeb({Key? key, required this.shopId}) : super(key: key);

  @override
  State<PurchaseScreenWeb> createState() => _PurchaseScreenWebState();
}

class _PurchaseScreenWebState extends State<PurchaseScreenWeb> {
  DateTime? _selectedFromDate;
  DateTime? _selectedToDate;
  final searchProvider = StateProvider<String>((ref) {
    return '';
  });
  TextEditingController searchController = TextEditingController();

  ///Date picker from
  void _pickDateDialogFrom() {
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
        _selectedFromDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0);
      });
    });
  }

  ///date picker to
  void _pickDateDialogTo() {
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
        _selectedToDate = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day, 23, 59, 59);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    // Map<String, dynamic> decode =
    //     jsonDecode(Uri.decodeComponent(widget.encode));
    // ShopModel shop = ShopModel(
    //     uid: decode['uid'],
    //     category: decode['category'],
    //     name: decode['name'],
    //     shopId: decode['shopId'],
    //     subscriptionId: decode['subscriptionId'],
    //     createdTime: DateTime.parse(decode['createdTime']),
    //     shopProfile: decode['shopProfile'],
    //     deleted: decode['deleted'],
    //     setSearch: List<String>.from(decode['setSearch']),
    //     accepted: decode['accepted'],
    //     blocked: decode['blocked'],
    //     reason: decode['reason']);
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          return ref.watch(getUserShopWebProvider(widget.shopId)).when(
                data: (data) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.03),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => Routemaster.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(deviceHeight * 0.02),
                                bottomRight:
                                    Radius.circular(deviceHeight * 0.02),
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
                            "Purchases",
                            style: TextStyle(
                                color: Pallete.secondaryColor,
                                fontSize: deviceWidth * .02,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: deviceWidth * 0.1,
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
                              style:
                                  const TextStyle(color: Pallete.primaryColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  contentPadding:
                                      EdgeInsets.all(deviceWidth * 0.0075),
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
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
                      height: deviceHeight * 0.055,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Date From\n${_selectedFromDate == null ? 'Choose Date' : DateFormat.yMMMd().format(_selectedFromDate!)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.secondaryColor,
                                  fontSize: deviceWidth * 0.011,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _pickDateDialogFrom();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Pallete.secondaryColor,
                                  ))
                            ],
                          ),
                          VerticalDivider(
                            width: deviceWidth * 0.05,
                            color: Pallete.secondaryColor,
                          ),
                          Row(
                            children: [
                              Text(
                                "Date To\n${_selectedToDate == null ? 'Choose Date' : DateFormat.yMMMd().format(_selectedToDate!)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.secondaryColor,
                                  fontSize: deviceWidth * 0.011,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    _pickDateDialogTo();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Pallete.secondaryColor,
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.055,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: deviceHeight * 0.7,
                                width: deviceWidth * 0.45,
                                child:
                                    (_selectedFromDate == null ||
                                            _selectedToDate == null)
                                        ? Consumer(
                                            builder: (context, ref, child) {
                                            String temp =
                                                ref.watch(searchProvider);

                                            Map<String, dynamic> map = {
                                              'uid': data.uid,
                                              'sid': data.shopId,
                                              'search':
                                                  temp.toUpperCase().trim()
                                            };
                                            return ref
                                                .watch(purchasesStreamProvider(
                                                    jsonEncode(map)))
                                                .when(
                                                  data: (data) => data.isEmpty
                                                      ? Center(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height:
                                                                      deviceHeight *
                                                                          0.5,
                                                                  width:
                                                                      deviceWidth *
                                                                          0.5,
                                                                  child: Lottie.asset(
                                                                      AssetConstants
                                                                          .noSmiley)),
                                                              Text(
                                                                "Oops! No Purchases Yet...",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.015,
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : ListView.builder(
                                                          itemCount:
                                                              data.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            PurchaseModel
                                                                purchase =
                                                                data[index];
                                                            String
                                                                purchaseEncode =
                                                                jsonEncode({
                                                              'name':
                                                                  purchase.name,
                                                              'id': purchase.id,
                                                              'purchaseDate': purchase
                                                                  .purchaseDate
                                                                  .toIso8601String(),
                                                              'total': purchase
                                                                  .totalPrice,
                                                              'products':
                                                                  purchase
                                                                      .products,
                                                              'sid': purchase
                                                                  .supplierId
                                                            });
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () =>
                                                                    Routemaster.of(
                                                                            context)
                                                                        .push(
                                                                            '/store/homescreen/${widget.shopId}/purchases/${Uri.encodeComponent(purchaseEncode)}/purchaseSingle'),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  minimumSize: Size(
                                                                      deviceWidth *
                                                                          0.2,
                                                                      deviceHeight *
                                                                          0.125),
                                                                  backgroundColor:
                                                                      Pallete
                                                                          .primaryColor,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(deviceHeight *
                                                                              0.02),
                                                                      side: const BorderSide(
                                                                          color:
                                                                              Pallete.secondaryColor)),
                                                                ),
                                                                child: Padding(
                                                                  padding: EdgeInsets.all(
                                                                      deviceWidth *
                                                                          0.015),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            ' ${purchase.name}:${purchase.id}',
                                                                            style: TextStyle(
                                                                                fontSize: deviceWidth * 0.01,
                                                                                color: Pallete.secondaryColor,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                deviceWidth * 0.2,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                deviceWidth * 0.05,
                                                                            child:
                                                                                Text(
                                                                              "\₹ ${purchase.totalPrice}",
                                                                              style: TextStyle(fontSize: deviceWidth * 0.011, color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: deviceHeight *
                                                                            0.01,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            purchase.purchaseDate.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: deviceWidth * 0.008,
                                                                              color: Pallete.secondaryColor,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                deviceWidth * 0.2,
                                                                          ),
                                                                          Text(
                                                                            "You will Give",
                                                                            style:
                                                                                TextStyle(fontSize: deviceWidth * 0.008, color: Colors.red),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  error: (error, stackTrace) {
                                                    return ErrorText(
                                                        error:
                                                            error.toString());
                                                  },
                                                  loading: () => const Loader(),
                                                );
                                          })
                                        : Consumer(
                                            builder: (context, ref, child) {
                                              String temp =
                                                  ref.watch(searchProvider);

                                              Map<String, dynamic> map = {
                                                'uid': data.uid,
                                                'sid': data.shopId,
                                                'fDate': _selectedFromDate!
                                                    .toIso8601String(),
                                                'tDate': _selectedToDate!
                                                    .toIso8601String(),
                                                'search':
                                                    temp.toUpperCase().trim(),
                                              };
                                              return ref
                                                  .watch(
                                                      sortedPurchaseStreamProvider(
                                                          jsonEncode(map)))
                                                  .when(
                                                    data: (data) => data.isEmpty
                                                        ? Center(
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        deviceHeight *
                                                                            0.5,
                                                                    width:
                                                                        deviceWidth *
                                                                            0.5,
                                                                    child: Lottie.asset(
                                                                        AssetConstants
                                                                            .noSmiley)),
                                                                Text(
                                                                  "Oops! No Purchases on this Date...",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          deviceWidth *
                                                                              0.015,
                                                                      color: Pallete
                                                                          .secondaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : ListView.builder(
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              PurchaseModel
                                                                  purchase =
                                                                  data[index];
                                                              String
                                                                  purchaseEncode =
                                                                  jsonEncode({
                                                                'name': purchase
                                                                    .name,
                                                                'id':
                                                                    purchase.id,
                                                                'purchaseDate': purchase
                                                                    .purchaseDate
                                                                    .toIso8601String(),
                                                                'total': purchase
                                                                    .totalPrice,
                                                                'products':
                                                                    purchase
                                                                        .products,
                                                                'sid': purchase
                                                                    .supplierId
                                                              });
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed: () =>
                                                                      Routemaster.of(
                                                                              context)
                                                                          .push(
                                                                              '/store/homescreen/${widget.shopId}/purchases/${Uri.encodeComponent(purchaseEncode)}/purchaseSingle'),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    minimumSize: Size(
                                                                        deviceWidth *
                                                                            0.2,
                                                                        deviceHeight *
                                                                            0.125),
                                                                    backgroundColor:
                                                                        Pallete
                                                                            .primaryColor,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(deviceHeight *
                                                                                0.02),
                                                                        side: const BorderSide(
                                                                            color:
                                                                                Pallete.secondaryColor)),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(
                                                                        deviceWidth *
                                                                            0.01),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              '${purchase.name}:${purchase.id}',
                                                                              style: TextStyle(fontSize: deviceWidth * 0.01, color: Pallete.secondaryColor, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            // SizedBox(
                                                                            //   width: deviceWidth * 0.25,
                                                                            // ),
                                                                            Text(
                                                                              "\₹ ${purchase.totalPrice}",
                                                                              style: TextStyle(fontSize: deviceWidth * 0.01, color: Pallete.secondaryColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              deviceHeight * 0.01,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              purchase.purchaseDate.toString(),
                                                                              style: TextStyle(
                                                                                fontSize: deviceWidth * 0.008,
                                                                                color: Pallete.secondaryColor,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: deviceWidth * 0.2,
                                                                            ),
                                                                            Text(
                                                                              "You will Give",
                                                                              style: TextStyle(fontSize: deviceWidth * 0.008, color: Colors.red),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                    error: (error, stackTrace) {
                                                      return ErrorText(
                                                          error:
                                                              error.toString());
                                                    },
                                                    loading: () =>
                                                        const Loader(),
                                                  );
                                            },
                                          )),
                          ],
                        ),
                        SizedBox(
                          width: deviceWidth * 0.055,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: deviceWidth * 0.3,
                              height: deviceHeight * 0.55,
                              child:
                                  Lottie.asset(AssetConstants.purchaseLottie),
                            ),
                            ElevatedButton(
                              onPressed: () => Routemaster.of(context).push(
                                  '/store/homescreen/${widget.shopId}/purchases/addPurchase'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(
                                    deviceWidth * 0.3, deviceHeight * 0.09),
                                backgroundColor: Pallete.secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.02),
                                    side: const BorderSide(
                                        color: Pallete.secondaryColor)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: Pallete.primaryColor,
                                    size: deviceWidth * 0.0125,
                                  ),
                                  SizedBox(
                                    width: deviceWidth * 0.009,
                                  ),
                                  Text(
                                    'Add Purchase',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.0125,
                                        color: Pallete.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              );
        }),
      ),
    );
  }
}
