import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../controller/auth_controller.dart';

class ScreenLoginTab extends ConsumerWidget {
  const ScreenLoginTab({super.key});
  void signInWithgoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signinWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: isLoading
              ? const Loader()
              : Row(
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.55,
                      child: Lottie.asset(
                        AssetConstants.loginLottietab,
                        height: deviceHeight * 0.8,
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    Container(
                      color: Pallete.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: deviceHeight * 0.2,
                          ),
                          Text(
                            "Sign in",
                            style: GoogleFonts.crimsonText(
                                fontSize: deviceWidth * 0.03,
                                color: Pallete.secondaryColor),
                          ),
                          Text(
                            "Sign in to get started quickly",
                            style: GoogleFonts.crimsonText(
                                fontSize: deviceWidth * 0.015,
                                color: Pallete.secondaryColor),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.04,
                          ),
                          SizedBox(
                            width: deviceWidth * 0.3,
                            // color: Colors.red,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    signInWithgoogle(ref, context);
                                  },
                                  child: Container(
                                    height: deviceHeight * 0.1,
                                    width: deviceWidth * 0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          deviceHeight * 0.05),
                                      border: Border.all(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: deviceWidth * 0.009,
                                          backgroundColor: Pallete.primaryColor,
                                          backgroundImage: const AssetImage(
                                              AssetConstants.google),
                                        ),
                                        Text('Continue with Google',
                                            style: TextStyle(
                                                fontSize: deviceWidth * 0.015))
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: deviceHeight * 0.04),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: deviceHeight * 0.1,
                                      width: deviceWidth * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight * 0.05),
                                        border: Border.all(),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: deviceWidth * 0.009,
                                            backgroundColor:
                                                Pallete.primaryColor,
                                            backgroundImage: const AssetImage(
                                                AssetConstants.apple),
                                          ),
                                          Text(
                                            'Continue with Apple',
                                            style: TextStyle(
                                                fontSize: deviceWidth * 0.015),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.02,
                                ),
                                Text(
                                  'I accept the Terms & Conditions & Privacy Policy',
                                  style:
                                      TextStyle(fontSize: deviceHeight * 0.018),
                                ),
                                SizedBox(
                                  height: deviceHeight * 0.04,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: Size(deviceWidth * 0.3,
                                          deviceHeight * 0.08),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('SIGN IN '),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: deviceHeight * 0.026,
                                        color: Pallete.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }
}
