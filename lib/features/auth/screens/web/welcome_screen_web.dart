import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/home/screens/web/side_bar_navigation_web.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/global_variables/global_variables.dart';

class WelcomeScreenWeb extends StatelessWidget {
  const WelcomeScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Lottie.network(
                'https://lottie.host/e8859ea3-c96c-4c8d-ad82-b2687bbf59d2/sYDi3SILeq.json',
                height: deviceHeight * 0.5,
                width: deviceWidth * 0.5,
              ),
              Container(
                height: deviceHeight * 0.5,
                width: deviceWidth * 0.4,
                decoration: BoxDecoration(
                    color: Pallete.secondaryColor,
                    borderRadius: BorderRadius.circular(deviceWidth * 0.04)),
                child: Padding(
                  padding: EdgeInsets.all(deviceHeight * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Welcome",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth * 0.04,
                                color: Pallete.primaryColor),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: deviceHeight * 0.02,
                      //),
                      Text(
                          "Here you can purchase anything you want\n"
                          "To see more continue Signin",
                          style: TextStyle(
                              fontSize: deviceWidth * 0.01,
                              color: Pallete.primaryColor)),
                      Center(
                        child: ElevatedButton(
                          onPressed: () =>Routemaster.of(context).push('/welcome/login'),
                          // label: const Text(
                          //   'Sign In',
                          //   style: TextStyle(fontSize: 18),
                          // ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.secondaryColor,
                              minimumSize:
                                  Size(deviceWidth * 0.15, deviceHeight * 0.09),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Pallete.primaryColor),
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02))),
                          child: SizedBox(
                            width: deviceWidth * 0.052,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign In',
                                  style:
                                      TextStyle(fontSize: deviceWidth * 0.012),
                                ),
                                Icon(
                                  Icons.arrow_forward_sharp,
                                  color: Pallete.primaryColor,
                                  size: deviceWidth * 0.012,
                                ),
                              ],
                            ),
                          ),
                          // icon: Icon(
                          //   Icons.arrow_forward_sharp,
                          //   color: Pallete.primaryColor,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
