import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../../addstore/controller/addstore_controller.dart';

import '../../controller/edit_shop_controller.dart';

class EditShopProfileTab extends StatefulWidget {
  final String shopId;
  const EditShopProfileTab({Key? key, required this.shopId}) : super(key: key);

  @override
  State<EditShopProfileTab> createState() => _EditShopProfileTabState();
}

class _EditShopProfileTabState extends State<EditShopProfileTab> {
  TextEditingController storeName = TextEditingController();
  String dropdownValue = 'first';

  final _formKey = GlobalKey<FormState>();

  editShop(
      {required ShopModel shopeModel,
      required WidgetRef ref,
      required BuildContext context1}) {
    if (storeName.text.trim().isEmpty) {
      showSnackBar(context, 'storename cant empty');
    } else {
      shopeModel = shopeModel.copyWith(
          name: storeName.text.trim(), category: dropdownValue);
      ref.watch(editShopControllerProvider.notifier).editShopProfile(
          context: context1,
          file: null,
          androidFile: profileFile,
          shopeModel: shopeModel);
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    storeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Pallete.secondaryColor,
        title: const Text("Edit Shop Profile"),
      ),
      body: Consumer(builder: (ctx, ref, child) {
        final isLoading = ref.watch(editShopControllerProvider);
        return isLoading
            ? const Loader()
            : ref.watch(getUserShopWebProvider(widget.shopId)).when(
                  data: (data) {
                    if (storeName.text.isEmpty) {
                      storeName.text = data.name;
                    }
                    if (dropdownValue == 'first') {
                      dropdownValue = data.category;
                    }
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                      child: DottedBorder(
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
                                                ? Image.file(profileFile!)
                                                : data.shopProfile.isEmpty
                                                    ? Center(
                                                        child: Icon(
                                                          Icons
                                                              .add_photo_alternate_outlined,
                                                          size: deviceHeight *
                                                              0.05,
                                                          color: Pallete
                                                              .secondaryColor,
                                                        ),
                                                      )
                                                    : Image.network(
                                                        data.shopProfile)),
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
                                                        left: deviceWidth *
                                                            0.055),
                                                    child: const Text(
                                                        'Store Name :'),
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
                                                            color: Pallete
                                                                .blackColor,
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
                                                          borderSide:
                                                              const BorderSide(
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
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Pallete.secondaryColor))),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: deviceWidth *
                                                            0.055),
                                                    child: const Text(
                                                        'Category Name :'),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    deviceWidth * 0.01),
                                                child: SizedBox(
                                                  height: deviceHeight * 0.1,
                                                  width: deviceWidth * 0.3,
                                                  child:
                                                      DropdownButtonFormField(
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                deviceHeight *
                                                                    0.015),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Pallete
                                                                    .secondaryColor),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                deviceHeight *
                                                                    0.015),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Pallete
                                                                    .secondaryColor),
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Pallete.thirdColor,
                                                    value: dropdownValue,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue!;
                                                      });
                                                    },
                                                    hint: const Text(
                                                        "Choose Your Shop"),
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
                                                      'Bakery & Cool-bar',
                                                      'Book Stall',
                                                      'Clothing Store',
                                                      'Grocery store',
                                                      'Electronics Store'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  deviceWidth *
                                                                      0.015),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              Consumer(
                                                  builder: (cxt, ref, child) {
                                                return ElevatedButton(
                                                    onPressed: () {
                                                      editShop(
                                                          shopeModel: data,
                                                          ref: ref,
                                                          context1: context);
                                                      storeName.clear();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    deviceWidth *
                                                                        0.015)),
                                                        minimumSize: Size(
                                                            deviceWidth * 0.25,
                                                            deviceHeight *
                                                                0.075)),
                                                    child: const Text("Save"));
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
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
      }),
    );
  }
}
