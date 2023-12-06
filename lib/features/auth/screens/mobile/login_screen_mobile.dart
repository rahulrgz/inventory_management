import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';
import '../../controller/auth_controller.dart';

class LoginScreenMobile extends ConsumerStatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  ConsumerState<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends ConsumerState<LoginScreenMobile> {
  bool check = false;
  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();

  void signInWithgoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signinWithGoogle(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Pallete.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(color: Pallete.secondaryColor),
        ),
      ),
      body: isLoading == true
          ? const Loader()
          : Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.05, right: deviceWidth * 0.05),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: deviceWidth,
                        height: deviceHeight * 0.4,
                        child: Lottie.asset(AssetConstants.loginLottieMobile,
                            fit: BoxFit.fitHeight)),
                    Text(
                      'Sign in',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceWidth * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                    // SizedBox(height: deviceHeight*0.01,),
                    Text(
                      'Sign in to get started quickly',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontSize: deviceWidth * 0.03),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),

                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.06,
                          bottom: deviceHeight * 0.04),
                      child: GestureDetector(
                        onTap: () {
                          signInWithgoogle(ref, context);
                        },
                        child: Container(
                          width: deviceWidth * 0.8,
                          height: deviceHeight * 0.09,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.08),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: deviceWidth * 0.035,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: const AssetImage(
                                    AssetConstants.google,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                        fontSize: deviceWidth * 0.04,
                                        color: Pallete.secondaryColor),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: deviceWidth * 0.06),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: deviceWidth * 0.8,
                          height: deviceHeight * 0.09,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.08),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: deviceWidth * 0.035,
                                backgroundColor: Colors.transparent,
                                backgroundImage: const AssetImage(
                                  AssetConstants.apple,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Continue with Apple",
                                  style: TextStyle(
                                      fontSize: deviceWidth * 0.04,
                                      color: Pallete.secondaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceHeight * 0.018,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    Center(
                      child: Text(
                        'By clicking, I accept the Terms & Conditions & Privacy Policy',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.027,
                            color: Pallete.secondaryColor),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),

                    SizedBox(
                      height: deviceHeight * 0.025,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
