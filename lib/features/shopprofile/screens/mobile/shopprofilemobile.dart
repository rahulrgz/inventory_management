import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/controller/addstore_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../controller/edit_shop_controller.dart';

class ShopProfileEditMobile extends StatefulWidget {
  final String sid;
  const ShopProfileEditMobile({super.key, required this.sid});

  @override
  State<ShopProfileEditMobile> createState() => _ShopProfileEditMobileState();
}

class _ShopProfileEditMobileState extends State<ShopProfileEditMobile> {
  TextEditingController storeName = TextEditingController(text: '~');
  String dropdownValue = 'Medical Store';

  final _formKey = GlobalKey<FormState>();

  editShop(
      {required ShopModel shopeModel,
      required WidgetRef ref,
      required BuildContext context1}) {
    if (storeName.text.trim().isEmpty) {
      showSnackBar(context, 'store name cannot be empty ');
    } else {
      shopeModel = shopeModel.copyWith(
          name: storeName.text.trim(), category: dropdownValue);
      ref.watch(editShopControllerProvider.notifier).editShopProfile(
          context: context1,
          file: null,
          androidFile: profileFile,
          shopeModel: shopeModel);
      Routemaster.of(context).pop();
    }
  }

  File? profileFile;
  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      String extension = res.files.first.path!.split('.').last.toLowerCase();
      List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (allowedExtensions.contains(extension)) {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      } else {
        // Show a snackbar or alert to inform the user that the selected file is not an image
        showSnackBar(context, 'Invalid file format. Please select an image.');
      }
    }
  }

  @override
  void dispose() {
    storeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Pallete.secondaryColor,
        ),
        title: Text(
          'Edit Shop',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceWidth * 0.06),
        ),
      ),
      body: Consumer(builder: (ctxt, ref, child) {
        final isLoading = ref.watch(editShopControllerProvider);
        // final user = ref.watch(userProvider);
        return isLoading
            ? const Loader()
            : ref.watch(getUserShopWebProvider(widget.sid)).when(
                  data: (data) {
                    if (storeName.text == '~') {
                      storeName.text = data.name;
                    }
                    if (dropdownValue == 'first') {
                      dropdownValue = data.category;
                    }
                    return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: deviceHeight * 0.1),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: selectProfileImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [10, 4],
                                  radius: const Radius.circular(10),
                                  color: Pallete.secondaryColor,
                                  child: Container(
                                      height: deviceHeight * 0.23,
                                      width: deviceWidth * 0.47,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: profileFile != null
                                              ? Image.file(
                                                  profileFile!,
                                                  fit: BoxFit.fill,
                                                )
                                              : data.shopProfile.isEmpty
                                                  ? Image.asset(
                                                      AssetConstants
                                                          .noShop, // Replace this with your asset image path
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.network(
                                                      data.shopProfile))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: deviceHeight * 0.08,
                                  width: deviceWidth * 0.8,
                                  child: TextFormField(
                                    onFieldSubmitted: (value) {
                                      setState(() {});
                                    },
                                    maxLength: 25,
                                    cursorColor: Pallete.secondaryColor,
                                    controller: storeName,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Store Name cant be Empty!!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                              color: Pallete.secondaryColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.015),
                                          borderSide: const BorderSide(
                                            color: Pallete.secondaryColor,
                                          ),
                                        ),
                                        hintText: 'Enter Store name',
                                        hintStyle: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.04),
                                        fillColor: Colors.transparent,
                                        filled: true),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: deviceHeight * 0.02,
                            ),
                            SizedBox(
                              height: deviceHeight * 0.09,
                              width: deviceWidth * 0.8,
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.015),
                                    borderSide: const BorderSide(
                                        color: Pallete.secondaryColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.015),
                                    borderSide: const BorderSide(
                                      color: Pallete.secondaryColor,
                                    ),
                                  ),
                                ),
                                dropdownColor: Pallete.thirdColor,
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
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
                                  'Electronics Store'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: deviceWidth * 0.038,
                                          color: Pallete.secondaryColor),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.15,
                            ),
                            if (profileFile != null ||
                                storeName.text != data.name ||
                                dropdownValue != data.category)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: deviceWidth * 0.1,
                                    right: deviceWidth * 0.1),
                                child: ElevatedButton(
                                    onPressed: () {
                                      editShop(
                                          shopeModel: data,
                                          ref: ref,
                                          context1: context);
                                      storeName.clear();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(deviceWidth * 0.01,
                                          deviceHeight * 0.06),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusDirectional.all(
                                          Radius.circular(deviceWidth * 0.02),
                                        ),
                                      ),
                                    ),
                                    child: Center(child: Text('Save'))),
                              ),
                            SizedBox(
                              height: deviceHeight * 0.05,
                            ),
                          ],
                        ));
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => Loader(),
                );
      }),
    );
  }
}
