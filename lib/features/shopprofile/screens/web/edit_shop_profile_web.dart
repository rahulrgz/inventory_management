import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';

import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../../addstore/controller/addstore_controller.dart';

import '../../controller/edit_shop_controller.dart';

class EditShopProfileWeb extends StatefulWidget {
  final String shopId;
  const EditShopProfileWeb({Key? key, required this.shopId}) : super(key: key);

  @override
  State<EditShopProfileWeb> createState() => _EditShopProfileWebState();
}

class _EditShopProfileWebState extends State<EditShopProfileWeb> {
  TextEditingController storeName = TextEditingController(text: '~');
  String dropdownValue = 'Medical Store';

  final _formKey = GlobalKey<FormState>();

  editShop(
      {required ShopModel shopeModel,
      required WidgetRef ref,
      required BuildContext context1}) {
    if (storeName.text.trim().isEmpty) {
      showSnackBar(context, 'store name cannot be empty');
    } else {
      shopeModel = shopeModel.copyWith(
          name: storeName.text.trim(), category: dropdownValue);
      ref.watch(editShopControllerProvider.notifier).editShopProfile(
          context: context1,
          file: profileFile,
          androidFile: null,
          shopeModel: shopeModel);
    }
  }

  // addShop(WidgetRef ref){
  //   if(_formKey.currentState!.validate()){
  //     final userid=ref.read(userProvider)?.uid??'';
  //     ShopeModel shopeModel=ShopeModel(
  //         uid: userid,
  //         category: dropdownValue,
  //         name: storeName.text,
  //         shopId: '',
  //         subscriptionId: '',
  //         createdTime: DateTime.now(),
  //         shopProfile: '',
  //         deleted: false,
  //         setSearch: []
  //     );
  //     ref.watch(addStoreControllerProvider.notifier).addShop(context: context, shopeModel: shopeModel,profilePic: profileFile!);
  //   }
  // }

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
  void initState() {
    // Map<String,dynamic> map=jsonDecode(Uri.decodeComponent(w));
    // String shopName=map['name'];
    // String category=map['category'];
    // storeName=TextEditingController(text: shopName);
    // dropdownValue=category;
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
    // Map<String,dynamic> decode=jsonDecode(Uri.decodeComponent(widget.encode));
    // ShopeModel shop=ShopeModel(
    //   uid: decode['uid'],
    //   category: decode['category'],
    //   name: decode['name'],
    //   shopId: decode['shopId'],
    //   subscriptionId: decode['subscriptionId'],
    //   createdTime: DateTime.parse(decode['createdTime']),
    //   shopProfile: decode['shopProfile'],
    //   deleted: decode['deleted'],
    //   setSearch: List<String>.from(decode['setSearch']),
    // );
    if (deviceHeight < 500 || deviceWidth < 1000) {
      return Center(
        child: Container(
          child: Lottie.asset(AssetConstants.errorLottie),
        ),
      );
    } else {
      return Scaffold(
        body: Consumer(builder: (ctx, ref, child) {
          final isLoading = ref.watch(editShopControllerProvider);
          return isLoading
              ? const Loader()
              : ref.watch(getUserShopWebProvider(widget.shopId)).when(
                    data: (data) {
                      if (storeName.text == '~') {
                        storeName.text = data.name;
                      }
                      if (dropdownValue == 'first') {
                        dropdownValue = data.category;
                      }
                      // dropdownValue=data.category;
                      // storeName.text=data.name;
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: deviceHeight * 0.03),
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () =>
                                        Routemaster.of(context).pop(),
                                    style: ElevatedButton.styleFrom(
                                      // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            deviceHeight * 0.02),
                                        bottomRight: Radius.circular(
                                            deviceHeight * 0.02),
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
                                    "Edit Store",
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
                                  height: deviceHeight * 0.05,
                                  width: deviceWidth,
                                  child: Marquee(
                                    text:
                                        'Remember, If you change your profile admin have to re-verify you..!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[900],
                                        fontSize: deviceWidth * 0.0125),
                                    scrollAxis: Axis.horizontal,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    blankSpace: deviceWidth * 0.7,
                                    velocity: 100.0,
                                    pauseAfterRound: const Duration(seconds: 1),
                                    startPadding: 10.0,
                                    accelerationDuration:
                                        const Duration(seconds: 1),
                                    accelerationCurve: Curves.linear,
                                    decelerationDuration:
                                        const Duration(milliseconds: 500),
                                    decelerationCurve: Curves.easeOut,
                                  ),
                                ),
                              ],
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
                                                    ? Image.memory(profileFile!)
                                                    : data.shopProfile.isEmpty
                                                        ? Center(
                                                            child: Icon(
                                                              Icons
                                                                  .add_photo_alternate_outlined,
                                                              size:
                                                                  deviceHeight *
                                                                      0.05,
                                                              color: Pallete
                                                                  .secondaryColor,
                                                            ),
                                                          )
                                                        : Image.network(
                                                            data.shopProfile))),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceHeight * 0.04),
                                              border: Border.all(
                                                  color:
                                                      Pallete.secondaryColor),
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
                                                      maxLength: 25,
                                                      onFieldSubmitted:
                                                          (value) =>
                                                              setState(() {}),
                                                      cursorColor: Pallete
                                                          .secondaryColor,
                                                      controller: storeName,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Store Name can't be Empty!!";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Enter the Store Name',
                                                              hintStyle: TextStyle(
                                                                  color: Pallete
                                                                      .blackColor,
                                                                  fontSize:
                                                                      deviceWidth *
                                                                          0.011),
                                                              fillColor: Colors
                                                                  .transparent,
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
                                                                  borderRadius: BorderRadius.circular(
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
                                                      decoration:
                                                          InputDecoration(
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
                                                                .secondaryColor,
                                                          ),
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
                                                      hint: Text(
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
                                                        'Backery & Cool-bar',
                                                        'Book Stall',
                                                        'Clothig Store',
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
                                                                        0.011),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                                if (profileFile != null ||
                                                    storeName.text !=
                                                        data.name ||
                                                    dropdownValue !=
                                                        data.category)
                                                  Consumer(builder:
                                                      (cxt, ref, child) {
                                                    return ElevatedButton(
                                                        onPressed: () {
                                                          editShop(
                                                              shopeModel: data,
                                                              ref: ref,
                                                              context1:
                                                                  context);
                                                          storeName.clear();
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        deviceWidth *
                                                                            0.015)),
                                                            minimumSize: Size(
                                                                deviceWidth *
                                                                    0.25,
                                                                deviceHeight *
                                                                    0.075)),
                                                        child:
                                                            const Text("Save"));
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
}
