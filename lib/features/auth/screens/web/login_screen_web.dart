import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';

import '../../controller/auth_controller.dart';

class LoginScreenWeb extends ConsumerWidget {
  const LoginScreenWeb({Key? key}) : super(key: key);

  void signInWithgoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signinWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      body: isLoading
          ? Loader()
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight * 0.03),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
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
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                              height: deviceHeight * .7,
                              width: deviceWidth * 0.5,
                              child: const Center(
                                  child: Image(
                                      image:
                                          AssetImage(AssetConstants.appLogo))))
                        ],
                      ),
                      SizedBox(
                        height: deviceHeight * 0.9,
                        width: deviceWidth * 0.5,
                        child: Stack(children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.04),
                              border: Border.all(color: Pallete.secondaryColor),
                            ),
                            height: deviceHeight * 0.85,
                            width: deviceWidth * 0.4,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: deviceHeight * 0.055,
                                  ),
                                  Text(
                                    'Welcome Back !',
                                    style: GoogleFonts.lora(
                                        textStyle: TextStyle(
                                            color: Pallete.secondaryColor,
                                            fontSize: deviceWidth * 0.035)),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.055,
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        signInWithgoogle(ref, context),
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(deviceWidth * 0.25,
                                          deviceHeight * 0.075),
                                      minimumSize: Size(deviceWidth * 0.25,
                                          deviceHeight * 0.075),
                                      backgroundColor: Pallete.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.02),
                                          side: const BorderSide(
                                              color: Pallete.secondaryColor)),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: deviceWidth * 0.015,
                                        ),
                                        Image.asset(AssetConstants.google,
                                            width: deviceWidth * 0.035,
                                            height: deviceHeight * 0.065),
                                        Text(
                                          'Continue with Google',
                                          style: TextStyle(
                                              color: Pallete.blackColor,
                                              fontSize: deviceWidth * 0.0145,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.045,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      maximumSize: Size(deviceWidth * 0.25,
                                          deviceHeight * 0.075),
                                      minimumSize: Size(deviceWidth * 0.25,
                                          deviceHeight * 0.075),
                                      backgroundColor: Pallete.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceHeight * 0.02),
                                          side: const BorderSide(
                                              color: Pallete.secondaryColor)),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: deviceWidth * 0.015,
                                        ),
                                        Image.asset(AssetConstants.apple,
                                            width: deviceWidth * 0.035,
                                            height: deviceHeight * 0.065),
                                        Text(
                                          'Continue with Apple',
                                          style: TextStyle(
                                              color: Pallete.blackColor,
                                              fontSize: deviceWidth * 0.0145,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.045,
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.38,
                                    width: deviceWidth * 0.23,
                                    child: Lottie.asset(
                                      AssetConstants.loginLottie,
                                      height: deviceHeight * 0.1,
                                      width: deviceWidth * 0.1,
                                    ),
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.045,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                ],
              ),
            )),
    );
  }
}
