import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/addstore/controller/addStore_controller.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

class AddStoreScreenWeb extends StatefulWidget {
  const AddStoreScreenWeb({Key? key}) : super(key: key);

  @override
  State<AddStoreScreenWeb> createState() => _AddStoreScreenWebState();
}

class _AddStoreScreenWebState extends State<AddStoreScreenWeb> {
  TextEditingController storeName = TextEditingController();
  String? dropdownValue;

  final _formKey = GlobalKey<FormState>();

  addShop(WidgetRef ref, BuildContext context1) {
    if (_formKey.currentState!.validate()) {
      if (storeName.text.trim().isEmpty) {
        showSnackBar(context, 'enter store name');
      } else {
        final userid = ref.read(userProvider)?.uid ?? '';
        ShopModel shopeModel = ShopModel(
            uid: userid,
            category: dropdownValue.toString(),
            name: storeName.text.trim(),
            shopId: '',
            subscriptionId: '',
            createdTime: DateTime.now(),
            shopProfile: '',
            deleted: false,
            setSearch: [],
            accepted: false,
            blocked: false,
            reason: '',
            expirationDate: DateTime.now());
        ref.watch(addStoreControllerProvider.notifier).addShop(
            context: context1,
            shopeModel: shopeModel,
            profilePic: profileFile,
            androidFile: null);
      }
    }
  }

  Uint8List? profileFile;

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = res.files.first.bytes;
      });
    }
  }
  // profileFile != null ? Image.file(profileFile!):null

  @override
  void dispose() {
    storeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    if (deviceHeight < 500 || deviceWidth < 1000) {
      return Center(
        child: Container(
          child: Lottie.asset(AssetConstants.errorLottie),
        ),
      );
    } else {
      return Scaffold(
        body: Consumer(builder: (ctx, ref, child) {
          final isLoading = ref.watch(addStoreControllerProvider);
          return isLoading
              ? Loader()
              : Form(
                  key: _formKey,
                  child: Column(
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
                                  topRight:
                                      Radius.circular(deviceHeight * 0.02),
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
                              "Add Store",
                              style: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontSize: deviceWidth * .02,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.8,
                            width: deviceWidth * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: selectProfileImage,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: deviceWidth * 0.15),
                                        child: Text(
                                          'Choose Shop Profile',
                                          style: TextStyle(
                                              color: Pallete.secondaryColor),
                                        ),
                                      ),
                                      DottedBorder(
                                        borderType: BorderType.RRect,
                                        strokeCap: StrokeCap.round,
                                        dashPattern: const [10, 4],
                                        radius: const Radius.circular(10),
                                        color: Pallete.secondaryColor,
                                        child: Container(
                                            height: deviceHeight * 0.4,
                                            width: deviceWidth * 0.25,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: profileFile != null
                                                ? Image.memory(profileFile!)
                                                : Center(
                                                    child: Icon(
                                                      Icons
                                                          .add_photo_alternate_outlined,
                                                      size: deviceHeight * 0.05,
                                                      color: Pallete
                                                          .secondaryColor,
                                                    ),
                                                  )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.8,
                            width: deviceWidth * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: deviceWidth * 0.4,
                                      height: deviceHeight * 0.7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.04),
                                        border: Border.all(
                                            color: Pallete.secondaryColor),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: deviceHeight * 0.1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: deviceWidth * 0.055),
                                                child: Text('Store Name :'),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                deviceWidth * 0.01),
                                            child: SizedBox(
                                              height: deviceHeight * 0.1,
                                              width: deviceWidth * 0.3,
                                              child: TextFormField(
                                                maxLength: 25,
                                                cursorColor:
                                                    Pallete.secondaryColor,
                                                controller: storeName,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Store Name can't be Empty!!";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Enter the Store Name',
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Pallete.blackColor,
                                                        fontSize: deviceWidth *
                                                            0.011),
                                                    fillColor:
                                                        Colors.transparent,
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceHeight *
                                                                  0.015),
                                                      borderSide: const BorderSide(
                                                          color: Pallete
                                                              .secondaryColor),
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                deviceHeight *
                                                                    0.015),
                                                        borderSide: const BorderSide(
                                                            color: Pallete
                                                                .primaryColor)),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                deviceHeight *
                                                                    0.015),
                                                        borderSide: const BorderSide(
                                                            color:
                                                                Pallete.secondaryColor))),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: deviceWidth * 0.055),
                                                child: Text('Category Name :'),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                deviceWidth * 0.01),
                                            child: SizedBox(
                                              height: deviceHeight * 0.1,
                                              width: deviceWidth * 0.3,
                                              child: DropdownButtonFormField<
                                                  String?>(
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Please Select Category ';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            deviceHeight *
                                                                0.015),
                                                    borderSide: const BorderSide(
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            deviceHeight *
                                                                0.015),
                                                    borderSide: const BorderSide(
                                                        color: Pallete
                                                            .secondaryColor),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            deviceHeight *
                                                                0.015),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Pallete
                                                          .secondaryColor,
                                                    ),
                                                  ),
                                                ),
                                                dropdownColor:
                                                    Pallete.thirdColor,
                                                value: dropdownValue,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue = newValue!;
                                                  });
                                                },
                                                hint: Text('Choose Your Shop'),
                                                items: <String>[
                                                  'Medical Store',
                                                  'Mobile Shop',
                                                  'Fancy & Footwear',
                                                  'SuperMarket',
                                                  'Textiles',
                                                  'Fancy',
                                                  'Footwear',
                                                  'Hypermarket',
                                                  'Toy Store',
                                                  'Backery & Cool-bar',
                                                  'Book Stall',
                                                  'Clothig Store',
                                                  'Grocery store',
                                                  'Electronics Store',
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: TextStyle(
                                                          fontSize:
                                                              deviceWidth *
                                                                  0.011),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                          Consumer(builder: (cxt, ref, child) {
                                            return ElevatedButton(
                                                onPressed: () {
                                                  addShop(ref, context);
                                                  storeName.clear();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    deviceWidth *
                                                                        0.015)),
                                                    minimumSize: Size(
                                                        deviceWidth * 0.25,
                                                        deviceHeight * 0.075)),
                                                child: Text("ADD YOUR STORE"));
                                          }),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
        }),
      );
    }
  }
}
