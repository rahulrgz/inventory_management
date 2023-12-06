import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/stock_model.dart';
import '../../../stocks/controller/stock_controller.dart';

class SaleStockScreen extends ConsumerStatefulWidget {
  final String sid;
  final String uid;
  const SaleStockScreen({Key? key, required this.uid, required this.sid})
      : super(key: key);

  @override
  ConsumerState<SaleStockScreen> createState() => _SaleStockScreenState();
}

class _SaleStockScreenState extends ConsumerState<SaleStockScreen> {
  final searchProvider = StateProvider<String>((ref) => '');
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String a = ref.watch(searchProvider);

    Map<String, dynamic> map = {
      'uid': widget.uid,
      'shopId': widget.sid,
      'search': a.toUpperCase(),
    };
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Pallete.primaryColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Pallete.secondaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ref.watch(stockStreamProvider(jsonEncode(map))).when(
              data: (data) => Container(
                height:
                    deviceHeight, // Set the height according to your preference
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.05,
                    ),
                    SizedBox(
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
                              labelText: 'Search Stock Item',
                              labelStyle: TextStyle(
                                fontSize: deviceHeight * 0.02,
                                color: Pallete.secondaryColor,
                              ),
                              suffixIcon:
                                  Consumer(builder: (context, ref, child) {
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
                        )),
                    SizedBox(
                      height: deviceHeight * 0.42,
                      child: ListView.builder(
                        itemCount: data
                            .length, // Replace data with your list of stock items
                        itemBuilder: (BuildContext context, int index) {
                          final StockModel stockItem = data[
                              index]; // Replace StockModel with your actual stock item model
                          return ListTile(
                            onTap: () {
                              // Close the modal bottom sheet after selecting an ite
                            },
                            title: Text(
                              stockItem.itemName,
                              style: TextStyle(color: Pallete.secondaryColor),
                            ),
                            subtitle: Text(
                              'Sale Price: ${stockItem.salePrice}',
                              style: TextStyle(color: Pallete.secondaryColor),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  Navigator.pop(context, {
                                    'itemName': stockItem.itemName,
                                    'purchasePrice': stockItem.purchasePrice,
                                    'quantity': stockItem.quantity
                                  });
                                },
                                icon: Icon(Icons.check)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //

              //

              // RawAutocomplete<StockModel>(
              //   optionsBuilder: (TextEditingValue
              //       textEditingValue) {
              //     itemNameController.text =
              //         textEditingValue.text;
              //     textEditingValue.text;
              //     name1 = textEditingValue.text;
              //     if (textEditingValue.text == '') {
              //       return const Iterable<
              //           StockModel>.empty();
              //     } else {
              //       List<StockModel> stock = [];
              //       for (var i in data) {
              //         if (i.itemName.contains(
              //             textEditingValue.text)) {
              //           stock.add(i);
              //         }
              //       }
              //       return stock;
              //     }
              //   },
              //   fieldViewBuilder: (
              //     BuildContext context,
              //     TextEditingController
              //         itemNameController,
              //     FocusNode focusNode,
              //     VoidCallback onFieldSubmitted,
              //   ) {
              //     itemNameController.text = name1;
              //     return TextFormField(
              //       maxLength: 25,
              //       validator: (value) {
              //         if (value!.isEmpty) {
              //           return "product name cannot be empty";
              //         }
              //         return null;
              //       },
              //       controller: itemNameController,
              //       focusNode: focusNode,
              //       decoration: InputDecoration(
              //         // alignLabelWithHint: true,
              //         focusedBorder:
              //             OutlineInputBorder(
              //           borderRadius:
              //               BorderRadius.circular(
              //                   deviceHeight * 0.015),
              //           borderSide: const BorderSide(
              //               color: Pallete
              //                   .secondaryColor),
              //         ),
              //         border: OutlineInputBorder(
              //             borderRadius:
              //                 BorderRadius.circular(
              //                     deviceHeight *
              //                         0.015),
              //             borderSide:
              //                 const BorderSide(
              //                     color: Pallete
              //                         .primaryColor)),
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius:
              //                 BorderRadius.circular(
              //                     deviceHeight *
              //                         0.015),
              //             borderSide: const BorderSide(
              //                 color: Pallete
              //                     .secondaryColor)),
              //         labelText: 'Product Name',
              //         labelStyle: const TextStyle(
              //             color:
              //                 Pallete.secondaryColor),
              //       ),
              //     );
              //   },
              //   optionsViewBuilder: (
              //     BuildContext context,
              //     AutocompleteOnSelected<StockModel>
              //         onSelected,
              //     Iterable<StockModel> options,
              //   ) {
              //     return Align(
              //       alignment: Alignment.topLeft,
              //       child: Material(
              //         elevation: 4.0,
              //         child: SizedBox(
              //           height: deviceHeight * 0.1,
              //           width: deviceWidth * 0.7,
              //           child: ListView.builder(
              //             padding:
              //                 const EdgeInsets.all(
              //                     8.0),
              //             itemCount: options.length,
              //             itemBuilder:
              //                 (BuildContext context,
              //                     int index) {
              //               final StockModel option =
              //                   options
              //                       .elementAt(index);
              //               return ListTile(
              //                 onTap: () {
              //                   count =
              //                       option.quantity;
              //                   name1 =
              //                       option.itemName;
              //                   salepriceController
              //                           .text =
              //                       option.salePrice
              //                           .toString();
              //                   setState(() {});
              //                 },
              //                 title: Column(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment
              //                           .start,
              //                   children: [
              //                     Text(option
              //                         .itemName),
              //                     Text(
              //                       option.salePrice
              //                           .toString(),
              //                       style:
              //                           const TextStyle(
              //                               fontSize:
              //                                   9),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ));
  }
}
