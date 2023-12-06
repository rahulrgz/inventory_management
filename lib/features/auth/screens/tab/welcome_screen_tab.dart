import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/constants/asset_constants/asset_constants.dart';
import '../../../../core/global_variables/global_variables.dart';

class WelcomeScreenTab extends StatelessWidget {
  const WelcomeScreenTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MicroSort',
          style: TextStyle(
              color: Pallete.secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
      ),
      body: Row(
        children: [
          SizedBox(
            width: deviceWidth * 0.55,
            child: Lottie.asset(
              AssetConstants.welcomeLottieTab,
              height: deviceHeight * 0.5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: deviceWidth * 0.15, right: deviceWidth * 0.01),
                child: Container(
                  width: deviceWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(deviceWidth * 0.05),
                        topRight: Radius.circular(deviceWidth * 0.05)),
                    color: Pallete.secondaryColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(deviceWidth * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "\nWelcome To MicroSort",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Pallete.primaryColor,
                              fontSize: deviceWidth * 0.02),
                        ),
                        Text(
                          "\nMicroSort is a set of tools and processes used to track goods across the supply chain, from ordering items from suppliers and vendors to delivering products to end consumers. By tracking inventory across the supply chain, companies can monitor trends and identify areas for improvement.",
                          style: TextStyle(
                              color: Pallete.primaryColor,
                              fontSize: deviceWidth * 0.012),
                        ),
                        SizedBox(
                          height: deviceWidth * 0.03,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () => Routemaster.of(context)
                                .replace('/welcome/login'),
                            child: Container(
                              width: deviceWidth * 0.2,
                              height: deviceHeight * 0.1,
                              decoration: BoxDecoration(
                                border: Border.all(color: Pallete.primaryColor),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(deviceWidth * 0.02)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'CONTINUE ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Pallete.primaryColor,
                                          fontSize: deviceWidth * 0.017),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Pallete.primaryColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
