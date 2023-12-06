import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:io';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/addStore_controller.dart';

class AddStoreTab extends ConsumerStatefulWidget {
  const AddStoreTab({super.key});
  @override
  ConsumerState<AddStoreTab> createState() => _AddStoreTabState();
}

class _AddStoreTabState extends ConsumerState<AddStoreTab> {
  TextEditingController storeName = TextEditingController();
  String dropdownValuetab = 'Medical Store';
  File? profileimage;
  final _formKey = GlobalKey<FormState>();
  addShop(WidgetRef ref, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (storeName.text.trim().isEmpty) {
        showSnackBar(context, 'enter store name');
      } else {
        final userid = ref.read(userProvider)?.uid ?? '';
        ShopModel shopeModel = ShopModel(
            uid: userid,
            category: dropdownValuetab,
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
        ref.read(addStoreControllerProvider.notifier).addShop(
            context: context,
            shopeModel: shopeModel,
            profilePic: null,
            androidFile: profileimage);
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      String extension = res.files.first.path!.split('.').last.toLowerCase();
      List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (allowedExtensions.contains(extension)) {
        setState(() {
          profileimage = File(res.files.first.path!);
        });
      } else {
        // Show a snackbar or alert to inform the user that the selected file is not an image
        showSnackBar(context, 'Invalid file format. Please select an image.');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    storeName.dispose();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(addStoreControllerProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Routemaster.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Pallete.secondaryColor,
              )),
          title: const Center(
            child: Text("Add Store",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Pallete.blackColor)),
          ),
          toolbarHeight: deviceHeight * 0.1,
          backgroundColor: Pallete.primaryColor,
          elevation: 0,
        ),
        body: isLoading
            ? const Center(
                child: Loader(),
              )
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Lottie.asset(AssetConstants.addStoreLottietab,
                          height: deviceHeight * 0.5),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Pallete.secondaryColor),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.03)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: deviceHeight * 0.02,
                            ),
                            CircleAvatar(
                                // backgroundColor: Pallete.secondaryColor,
                                radius: deviceWidth * 0.05,
                                child: GestureDetector(
                                  onTap: () {
                                    selectProfileImage();
                                  },
                                  child: profileimage != null
                                      ? CircleAvatar(
                                          radius: deviceWidth * 0.05,
                                          backgroundImage:
                                              FileImage(profileimage!),
                                          // child: Image.file(profileimage!,
                                          //     fit: BoxFit.contain),
                                        ) // Display the selected image
                                      : const Icon(
                                          Icons.add_photo_alternate_outlined,
                                          color: Pallete.primaryColor,
                                        ),
                                )),
                            SizedBox(
                              height: deviceHeight * 0.05,
                            ),
                            SizedBox(
                              width: deviceWidth * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Enter Store Name :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: deviceWidth * 0.016)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.02),
                                    child: TextFormField(
                                      maxLength: 25,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Store Name can't be Empty!!";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: storeName,
                                      decoration: InputDecoration(
                                        hintText: " Store Name",
                                        fillColor: Pallete.primaryColor,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Pallete.secondaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.03),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                deviceWidth * 0.03),
                                            borderSide: const BorderSide(
                                                color: Pallete.primaryColor)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Pallete.secondaryColor,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.03),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.05,
                            ),
                            SizedBox(
                              width: deviceWidth * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Choose your Category :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: deviceWidth * 0.016)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.02),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.03),
                                          borderSide: const BorderSide(
                                              color: Pallete.secondaryColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.03),
                                          borderSide: const BorderSide(
                                            color: Pallete.secondaryColor,
                                          ),
                                        ),
                                      ),
                                      dropdownColor: Pallete.primaryColor,
                                      value: dropdownValuetab,
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownValuetab = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Medical Store',
                                        'Mobiles',
                                        'Footwear',
                                        'SuperMarket',
                                        'Textiles'
                                      ].map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: deviceHeight * 0.1,
                            ),
                            Consumer(
                              builder: (BuildContext context1, WidgetRef ref,
                                  Widget? child) {
                                return InkWell(
                                  onTap: () {
                                    addShop(ref, context);
                                  },
                                  child: Container(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.35,
                                    decoration: BoxDecoration(
                                        color: Pallete.secondaryColor,
                                        borderRadius: BorderRadius.circular(
                                            deviceWidth * 0.03)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add Your Store ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: deviceWidth * 0.015),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: deviceWidth * 0.02,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
