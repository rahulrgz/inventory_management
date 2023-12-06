import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/supplier_model.dart';
import '../../controller/supplier_controller.dart';

class Suppliers_Screen_Web extends ConsumerStatefulWidget {
  final String shopId;

  Suppliers_Screen_Web({super.key, required this.shopId});

  @override
  ConsumerState createState() => _Suppliers_Screen_WebState();
}

class _Suppliers_Screen_WebState extends ConsumerState<Suppliers_Screen_Web> {
  TextEditingController suppliername = TextEditingController();
  TextEditingController supplierphone = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  deleteAlertDialog(BuildContext context, supplierList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Pallete.secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            TextButton(
              onPressed: () {
                deleteSupplier(ref, supplierList, context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Yes',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  // ShopModel decode(String encode) {
  //   Map<String, dynamic> decode = jsonDecode(Uri.decodeComponent(encode));
  //   return ShopModel(
  //       uid: decode['uid'],
  //       category: decode['category'],
  //       name: decode['name'],
  //       shopId: decode['shopId'],
  //       subscriptionId: decode['subscriptionId'],
  //       createdTime: DateTime.parse(decode['createdTime']),
  //       shopProfile: decode['shopProfile'],
  //       deleted: decode['deleted'],
  //       setSearch: List<String>.from(decode['setSearch']),
  //       accepted: decode['accepted'],
  //       blocked: decode['blocked'],
  //       reason: decode['reason']);
  // }

  addSupplier(WidgetRef ref, BuildContext context) {
    // Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    // String shopId = map['shopId'];
    if (_formKey.currentState!.validate()) {
      SupplierModel supplierModel = SupplierModel(
        name: suppliername.text.trim(),
        phoneNumber: supplierphone.text.trim(),
        shopId: [widget.shopId],
        setSearch: [],
        createdTime: DateTime.now(),
        deleted: false,
        PurchaseId: [],
      );
      ref.watch(supplierControllerProvider.notifier).addSuppliers(
            context: context,
            supplierModel: supplierModel,
          );
    }
  }

  // Uint8List? profileFile;
  //
  // void selectProfileImage() async {
  //   final res = await pickImage();
  //   if (res != null) {
  //     setState(() {
  //       profileFile = res.files.first.bytes;
  //     });
  //   }
  // }

  deleteSupplier(
      WidgetRef ref, SupplierModel supplierModel, BuildContext context) {
    supplierModel = supplierModel.copyWith(deleted: true);
    ref
        .read(supplierControllerProvider.notifier)
        .deleteSupplier(supplierModel, context);
  }

  @override
  Widget build(BuildContext context) {
    // ShopeModel shop = decode(widget.encode);
    final isLoding = ref.watch(supplierControllerProvider);
    return isLoding
        ? const Loader()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(children: [
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
                        "Suppliers",
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceWidth * .02,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.03, top: deviceHeight * 0.08),
                    child: SizedBox(
                        height: deviceHeight * 0.85,
                        width: deviceWidth,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: deviceHeight * 0.85,
                                width: deviceWidth * 0.6,
                                child: Consumer(
                                  builder:
                                      (context, WidgetRef ref, Widget? child) {
                                    // Map<String, dynamic> map = jsonDecode(
                                    //     Uri.decodeComponent(widget.encode));
                                    // String shopId = map['shopId'];
                                    var supplier = ref.watch(
                                        getSupplierProvider(widget.shopId));
                                    return supplier.when(
                                      data: (data) {
                                        return data.isEmpty
                                            ? Center(
                                                child: Column(
                                                children: [
                                                  SizedBox(
                                                      height:
                                                          deviceHeight * 0.5,
                                                      width: deviceWidth * 0.5,
                                                      child: Lottie.asset(
                                                          AssetConstants
                                                              .noSmiley)),
                                                  Text(
                                                    "Oops! No Suppliers Yet...",
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceWidth * 0.015,
                                                        color: Pallete
                                                            .secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ))
                                            : GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                            2, // Number of columns you want in the grid
                                                        crossAxisSpacing:
                                                            deviceWidth *
                                                                0.02, // Spacing between columns
                                                        mainAxisSpacing:
                                                            deviceWidth *
                                                                0.02, // Spacing between rows
                                                        childAspectRatio: 3 / 4,
                                                        mainAxisExtent: 100),
                                                itemCount: data.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  SupplierModel supplierList =
                                                      data[index];
                                                  return Container(
                                                    height: deviceHeight * 0.1,
                                                    width: deviceWidth * 0.2,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      border: Border.all(
                                                        width:
                                                            deviceWidth * 0.001,
                                                        color: Pallete
                                                            .secondaryColor,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            width: deviceWidth *
                                                                0.02),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: deviceWidth *
                                                                0.005,
                                                            top: deviceHeight *
                                                                0.033,
                                                          ),
                                                          child: Container(
                                                            height:
                                                                deviceHeight *
                                                                    0.1,
                                                            width: deviceWidth *
                                                                0.19,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  supplierList
                                                                      .name,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.011,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  supplierList
                                                                      .phoneNumber,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.009,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              left:
                                                                  deviceWidth *
                                                                      0.015,
                                                              top:
                                                                  deviceHeight *
                                                                      0.033,
                                                              right:
                                                                  deviceWidth *
                                                                      0.001),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              deleteAlertDialog(
                                                                  context,
                                                                  supplierList);
                                                              setState(() {});
                                                            },
                                                            child: Column(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Pallete
                                                                        .secondaryColor),
                                                                Text(
                                                                  'Delete',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Pallete
                                                                        .secondaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        deviceWidth *
                                                                            0.009,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                      },
                                      error: (error, stackTrace) {
                                        return ErrorText(
                                            error: error.toString());
                                      },
                                      loading: () {
                                        return const Loader();
                                      },
                                    );
                                  },
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                thickness: 1,
                                indent: deviceHeight * 0.02,
                                endIndent: deviceHeight * 0.02,
                              ),
                              SizedBox(
                                height: deviceHeight * 0.85,
                                child: Form(
                                  key: _formKey1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: deviceWidth * 0.3,
                                        height: deviceHeight * 0.3,
                                        child: Lottie.asset(
                                            AssetConstants.supplierLottie),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.10,
                                        width: deviceWidth * 0.2,
                                        child: TextFormField(
                                          maxLength: 25,
                                          controller: suppliername,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Name',
                                            labelStyle: const TextStyle(
                                                color: Pallete.secondaryColor),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter suppliar name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.02,
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.10,
                                        width: deviceWidth * 0.2,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          controller: supplierphone,
                                          decoration: InputDecoration(
                                            labelText: 'Enter Number',
                                            labelStyle: const TextStyle(
                                                color: Pallete.secondaryColor),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.01),
                                                borderSide: const BorderSide(
                                                    color: Pallete
                                                        .secondaryColor)),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter phone number';
                                            }
                                            final isNumeric =
                                                int.tryParse(value);
                                            if (isNumeric == null ||
                                                value.length != 10) {
                                              return 'Phone number must be exactly 10 digits';
                                            }
                                            return null;
                                          },
                                          maxLength: 10,
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.02,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (_formKey1.currentState!
                                              .validate()) {
                                            if (suppliername.text
                                                    .trim()
                                                    .isEmpty ||
                                                supplierphone.text
                                                    .trim()
                                                    .isEmpty) {
                                              // Show Snackbar if any of the fields is empty
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Please fill all the fields.'),
                                                ),
                                              );
                                            } else {
                                              // All fields are filled, add the supplier
                                              await addSupplier(ref, context);
                                              suppliername.clear();
                                              supplierphone.clear();
                                            }
                                          }
                                        },
                                        child: Container(
                                            height: deviceHeight * 0.07,
                                            width: deviceWidth * 0.13,
                                            decoration: BoxDecoration(
                                              color: Pallete.secondaryColor,
                                              border: Border.all(
                                                color: Pallete.primaryColor,
                                                // Border color
                                                width: deviceWidth * 0.001,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Add Suppliers',
                                                  style: TextStyle(
                                                      fontSize:
                                                          deviceWidth * 0.011,
                                                      color:
                                                          Pallete.primaryColor),
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ])),
                  ),
                ),
              ]),
            ),
          );
  }
}
