import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/utils.dart';
import '../../../../models/user_model.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/edit_user_profile_controller.dart';

class UserProfileScreenTab extends ConsumerStatefulWidget {
  const UserProfileScreenTab({super.key});
  @override
  ConsumerState createState() => _UserProfileTabState();
}

class _UserProfileTabState extends ConsumerState<UserProfileScreenTab> {
  final _formKey = GlobalKey<FormState>();
  String? userName;
  String? phoneNumber;
  TextEditingController userProfileName = TextEditingController();
  TextEditingController userPhoneNumber = TextEditingController();
  String dropdownValue = 'Medical Store';
  //
  // editUserProfile(
  //     {required WidgetRef ref,
  //     required BuildContext context1,
  //     required UserModel user}) {
  //   user = user.copyWith(
  //       name: userProfileName.text.trim(), phNo: userPhoneNumber.text.trim());
  //   ref.watch(editUserProfileControllerProvider.notifier).editUserProfilePic(
  //       context: context1,
  //       file: null,
  //       androidFile: profileFile,
  //       userModel: user);
  // }
  editUserProfile({
    required WidgetRef ref,
    required BuildContext context1,
    required UserModel user,
  }) async {
    if (_formKey.currentState!.validate()) {
      if (userProfileName.text.isEmpty) {
        showSnackBar(context, 'fill the name .');
      } else if (userPhoneNumber.text.isEmpty) {
        showSnackBar(context, 'please fill the number');
      } else {
        user = user.copyWith(
          name: userProfileName.text.trim() ?? userName,
          phNo: userPhoneNumber.text.trim(),
        );

        bool editSuccessful = await ref
            .watch(editUserProfileControllerProvider.notifier)
            .editUserProfilePic(
              context: context1,
              file: null,
              androidFile: profileFile,
              userModel: user,
            );
        Routemaster.of(context).pop();
        userProfileName?.clear();

        if (editSuccessful) {
          showSnackBar(context, 'Profile updated successfully.');
          userProfileName.clear();
        } else {
          showSnackBar(context, 'Failed to update profile. Please try again.');
        }
      }
    }
  }

  @override
  void initState() {
    userName = ref.read(userProvider)?.name ?? '';
    phoneNumber = ref.read(userProvider)?.phNo ?? '';
    userProfileName.text = userName!;
    userPhoneNumber.text = phoneNumber!;
    super.initState();
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
  Widget build(BuildContext context) {
    final isLoading = ref.watch(editUserProfileControllerProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.secondaryColor,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Routemaster.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Edit Profile',
          style: TextStyle(
              color: Pallete.primaryColor, fontSize: deviceWidth * 0.02),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    decelerationRate: ScrollDecelerationRate.normal),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: deviceHeight,
                          width: deviceWidth * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: deviceHeight * 0.5,
                                  width: deviceWidth * 0.3,
                                  child: Lottie.asset(
                                    AssetConstants.profileLottie,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight,
                          width: deviceWidth * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: deviceWidth * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.04),
                                  border:
                                      Border.all(color: Pallete.secondaryColor),
                                ),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(
                                      decelerationRate:
                                          ScrollDecelerationRate.fast),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: deviceHeight * 0.04,
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
                                                    child: Image.file(
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
                                                            user.profilePic,
                                                            fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: deviceHeight * 0.06,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(deviceWidth * 0.005),
                                        child: SizedBox(
                                          width: deviceWidth * 0.35,
                                          child: TextFormField(
                                            maxLength: 25,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "User Name can't be Empty!!";
                                              } else {
                                                return null;
                                              }
                                            },
                                            controller: userProfileName,
                                            decoration: InputDecoration(
                                              labelText: "User Name",
                                              fillColor: Pallete.primaryColor,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Pallete.secondaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.02),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceWidth * 0.02),
                                                  borderSide: const BorderSide(
                                                      color: Pallete
                                                          .primaryColor)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Pallete.secondaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        deviceWidth * 0.02),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.all(deviceWidth * 0.005),
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
                                                    .digitsOnly
                                              ],
                                            )),
                                      ),
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
                                                        BorderRadius.circular(
                                                            deviceWidth *
                                                                0.015)),
                                                minimumSize: Size(
                                                    deviceWidth * 0.25,
                                                    deviceHeight * 0.075)),
                                            child: const Text("Save"));
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
