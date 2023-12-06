import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreenMobile extends StatelessWidget {
  const WelcomeScreenMobile({Key? key}) : super(key: key);
  navigateFunc({required BuildContext context}) async {
    Routemaster.of(context).replace('/login');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs;
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Pallete.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // SizedBox(
          //   height: deviceHeight * 0.1,
          // ),
          Padding(
            padding: EdgeInsets.all(deviceHeight * 0.03),
            child: Lottie.asset(
              AssetConstants.welcomeLottieMobile,
              // 'https://lottie.host/e8859ea3-c96c-4c8d-ad82-b2687bbf59d2/sYDi3SILeq.json',
              height: deviceHeight * 0.3,
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.06,
          ),
          Container(
            // height: deviceHeight * 0.4415,
            width: deviceWidth,
            decoration: BoxDecoration(
                color: Pallete.secondaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(deviceHeight * 0.05),
                    topRight: Radius.circular(deviceHeight * 0.05))),
            child: Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth * 0.08,
                  right: deviceWidth * 0.05,
                  bottom: deviceWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: deviceHeight * 0.054,
                  ),
                  Text(
                    'WELCOME,',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Pallete.primaryColor,
                        fontSize: deviceWidth * 0.06),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.01,
                  ),
                  Text(
                    "Sortify is a set of tools and processes used to track goods across the supply chain, from ordering items from suppliers and vendors to delivering products to end consumers. By tracking inventory across the supply chain, companies can monitor trends and identify areas for improvement.",
                    style: TextStyle(
                        color: Pallete.primaryColor,
                        fontWeight: FontWeight.w200,
                        fontSize: deviceWidth * 0.025),
                  ),
                  SizedBox(
                    height: deviceHeight * 0.04,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () => Routemaster.of(context).push('/signUp'),
                      child: Container(
                        width: deviceWidth * 0.45,
                        height: deviceHeight * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Pallete.primaryColor),
                          borderRadius: BorderRadius.all(
                              Radius.circular(deviceWidth * 0.04)),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SIGN UP ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Pallete.primaryColor,
                                    fontSize: deviceWidth * 0.04),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Pallete.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
