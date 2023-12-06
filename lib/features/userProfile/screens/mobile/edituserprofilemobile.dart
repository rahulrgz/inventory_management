import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/userProfile/controller/edit_user_profile_controller.dart';
import 'package:inventory_management_shop/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';

class EditUserMobile extends ConsumerStatefulWidget {
  const EditUserMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditUserMobile> createState() => _EditUserProfileMobileState();
}

class _EditUserProfileMobileState extends ConsumerState<EditUserMobile> {
  final _formKey = GlobalKey<FormState>();
  String? userName;
  TextEditingController storeName = TextEditingController();
  TextEditingController userPhoneNumber = TextEditingController();

  String dropdownValue = 'Medical Store';

  editUserProfile({
    required WidgetRef ref,
    required BuildContext context1,
    required UserModel user,
  }) async {
    if (_formKey.currentState!.validate()) {
      if (storeName.text.isEmpty) {
        showSnackBar(context, 'fill the name .');
      } else if (userPhoneNumber.text.isEmpty) {
        showSnackBar(context, 'please fill the number');
      } else {
        user = user.copyWith(
          name: storeName.text.trim() ?? userName,
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
        storeName?.clear();

        if (editSuccessful) {
          showSnackBar(context, 'Profile updated successfully.');
          storeName.clear();
        } else {
          showSnackBar(context, 'Failed to update profile. Please try again.');
        }
      }
    }
  }

  @override
  void initState() {
    userName = ref.read(userProvider)?.name ?? '';
    storeName.text = userName!;

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
    // var user = ref.watch(userProvider);
    final isLoading = ref.watch(editUserProfileControllerProvider);
    final user = ref.watch(userProvider);
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
          'Edit Profile',
          style: TextStyle(
              color: Pallete.secondaryColor, fontSize: deviceWidth * 0.06),
        ),
      ),
      body: isLoading
          ? Loader()
          : Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                          child: profileFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    profileFile!,
                                    fit: BoxFit.fill,
                                  ))
                              : user!.profilePic.isEmpty
                                  ? Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: deviceHeight * 0.05,
                                        color: Pallete.secondaryColor,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                          user.profilePic ?? '',
                                          fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.02,
                        left: deviceWidth * 0.07,
                        right: deviceWidth * 0.07),
                    child: TextFormField(
                      onFieldSubmitted: (value) => setState(() {}),
                      maxLength: 20,
                      cursorColor: Pallete.secondaryColor,
                      controller: storeName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'User Name cant be Empty!!';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Pallete.secondaryColor,
                              width: deviceWidth * 0.001),
                          borderRadius:
                              BorderRadius.circular(deviceWidth * 0.04),
                        ),
                        hintText: 'Enter Name',
                        hintStyle: TextStyle(
                            color: Pallete.secondaryColor,
                            fontSize: deviceHeight * 0.02),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: deviceWidth * 0.85,
                      child: IntlPhoneField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: userPhoneNumber,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02)),
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.02)),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      )),
                  SizedBox(
                    height: deviceHeight * 0.03,
                  ),
                  if (profileFile != null || storeName.text != user!.name)
                    Consumer(builder: (cxt, ref, child) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: deviceWidth * 0.067,
                            right: deviceWidth * 0.067),
                        child: ElevatedButton(
                          onPressed: () {
                            editUserProfile(
                                ref: ref, context1: cxt, user: user!);
                          },
                          style: ElevatedButton.styleFrom(
                            // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(deviceHeight * 0.015)),
                            ),
                          ),
                          child: Center(
                            child: Text('Save'),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
