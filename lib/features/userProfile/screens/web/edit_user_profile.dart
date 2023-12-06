import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/userProfile/controller/edit_user_profile_controller.dart';
import 'package:inventory_management_shop/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';

class EditUserProfile extends ConsumerStatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends ConsumerState<EditUserProfile> {
  String? userName;
  TextEditingController? storeName;
  String dropdownValue = 'Medical Store';
  TextEditingController userPhoneNumber = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  editUserProfile(
      {required WidgetRef ref,
      required BuildContext context1,
      required UserModel user}) async {
    if (_formKey.currentState!.validate()) {
      if (storeName!.text.isEmpty) {
        showSnackBar(context, 'fill the name');
      } else if (userPhoneNumber.text.isEmpty) {
        showSnackBar(context, 'please fill the number');
      } else {
        user = user.copyWith(
            name: storeName?.text.trim() ?? userName,
            phNo: userPhoneNumber.text.trim());

        bool editSuccesfull = await ref
            .watch(editUserProfileControllerProvider.notifier)
            .editUserProfilePic(
                context: context1,
                file: profileFile,
                userModel: user,
                androidFile: null);
        storeName!.clear();
        if (editSuccesfull) {
          showSnackBar(context, 'profile edit success');
          storeName!.clear();
        } else {
          showSnackBar(context, 'faild to update please try again');
        }
      }
    }
  }

  @override
  void initState() {
    userName = ref.read(userProvider)?.name ?? '';
    storeName = TextEditingController(text: userName);
    super.initState();
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
    storeName?.dispose();
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
      final isLoading = ref.watch(editUserProfileControllerProvider);
      final user = ref.watch(userProvider);
      return Scaffold(
        body: isLoading
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
                            "Edit Profile",
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
                              SizedBox(
                                  height: deviceHeight * 0.5,
                                  width: deviceWidth * 0.3,
                                  child: Lottie.asset(
                                      AssetConstants.editProfileLottie))
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
                                    height: deviceHeight * 0.77,
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
                                        GestureDetector(
                                          onTap: selectProfileImage,
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            strokeCap: StrokeCap.round,
                                            dashPattern: const [10, 4],
                                            radius: const Radius.circular(10),
                                            color: Pallete.secondaryColor,
                                            child: Container(
                                              height: deviceHeight * 0.2,
                                              width: deviceWidth * 0.125,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: profileFile != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.memory(
                                                        profileFile!,
                                                        fit: BoxFit.fill,
                                                      ))
                                                  : user!.profilePic.isEmpty
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
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                              user.profilePic ??
                                                                  '',
                                                              fit:
                                                                  BoxFit.fill)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: deviceHeight * 0.06,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: deviceWidth * 0.055),
                                              child: const Text('User Name :'),
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
                                              onFieldSubmitted: (value) =>
                                                  setState(() {}),
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
                                                      'Enter the User Name',
                                                  hintStyle: TextStyle(
                                                      color: Pallete.blackColor,
                                                      fontSize:
                                                          deviceWidth * 0.011),
                                                  fillColor: Colors.transparent,
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
                                                          color: Pallete
                                                              .secondaryColor))),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              deviceWidth * 0.005),
                                          child: SizedBox(
                                              width: deviceWidth * 0.35,
                                              child: IntlPhoneField(
                                                controller: userPhoneNumber,
                                                decoration: InputDecoration(
                                                  enabledBorder: OutlineInputBorder(
                                                      borderSide: const BorderSide(
                                                          color: Pallete
                                                              .secondaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceWidth *
                                                                  0.02)),
                                                  labelText: 'Phone',
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              deviceWidth *
                                                                  0.02)),
                                                ),
                                                initialCountryCode: 'IN',
                                                onChanged: (phone) {},
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]'))
                                                ],
                                              )),
                                        ),
                                        if (profileFile != null ||
                                            storeName!.text != user!.name)
                                          Consumer(builder: (cxt, ref, child) {
                                            return ElevatedButton(
                                                onPressed: () {
                                                  editUserProfile(
                                                      ref: ref,
                                                      context1: context,
                                                      user: user!);
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
                                                child: Text("Save"));
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
              ),
      );
    }
  }
}
