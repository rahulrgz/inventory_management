import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/utils.dart';
import '../../../../models/shope_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/addStore_controller.dart';

class AddstoreMobile extends ConsumerStatefulWidget {
  const AddstoreMobile({super.key});
  @override
  ConsumerState<AddstoreMobile> createState() => _AddstoreMobileState();
}

class _AddstoreMobileState extends ConsumerState<AddstoreMobile> {
  TextEditingController storeName = TextEditingController();
  String dropdownValue = 'Medical Store';
  final _formKey = GlobalKey<FormState>();
  addShop(WidgetRef ref, BuildContext context1) {
    if (_formKey.currentState!.validate()) {
      if (storeName.text.trim().isEmpty) {
        showSnackBar(context, 'enter store name');
      } else {
        final userid = ref.read(userProvider)?.uid ?? '';
        ShopModel shopeModel = ShopModel(
            uid: userid,
            category: dropdownValue,
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
            profilePic: null,
            androidFile: profileFile);
      }
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
  // profileFile != null ? Image.file(profileFile!):null

  @override
  void dispose() {
    storeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(addStoreControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: ElevatedButton(
          onPressed: () => Routemaster.of(context).pop(),
          style: ElevatedButton.styleFrom(
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
        title: const Text(
          'Add Store',
          style: TextStyle(color: Pallete.secondaryColor),
        ),
      ),
      body: isLoading
          ? const Center(
              child: Loader(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.08,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          selectProfileImage();
                        },
                        child: profileFile == null
                            ? CircleAvatar(
                                backgroundColor: Pallete.secondaryColor,
                                radius: deviceHeight * 0.1,
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: deviceHeight * 0.05,
                                  color: Pallete.primaryColor,
                                ))
                            : CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: deviceHeight * 0.1,
                              ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.06,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Enter Store Name :',
                        style: TextStyle(fontSize: deviceWidth * 0.04),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        maxLength: 25,
                        controller: storeName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Store Name can't be Empty!!";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                  color: Pallete.primaryColor)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                const BorderSide(color: Pallete.secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Category Name :',
                        style: TextStyle(fontSize: deviceWidth * 0.04),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: DropdownButtonFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select category';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide:
                                BorderSide(color: Pallete.secondaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: BorderSide(
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
                              style: TextStyle(fontSize: deviceWidth * 0.04),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.05,
                    ),
                    Consumer(builder:
                        (BuildContext context1, WidgetRef ref, Widget? child) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: deviceWidth * 0.05,
                            right: deviceWidth * 0.05,
                            bottom: deviceHeight * 0.08),
                        child: InkWell(
                          onTap: () {
                            addShop(ref, context);
                            storeName.clear();
                          },
                          child: Container(
                              height: deviceHeight * 0.07,
                              // width: deviceWidth * 0.11,
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
                                    size: deviceWidth * 0.04,
                                  )),
                                  SizedBox(width: deviceWidth * 0.01),
                                  Text(
                                    'Add Store ',
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.04,
                                        color: Pallete.primaryColor),
                                  )
                                ],
                              )),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
    );
  }
}
