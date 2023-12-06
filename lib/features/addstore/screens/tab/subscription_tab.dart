import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/addstore/controller/addstore_controller.dart';
import 'package:inventory_management_shop/models/plans_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class SubscriptionTab extends ConsumerStatefulWidget {
  final String sid;
  const SubscriptionTab({super.key, required this.sid});

  @override
  ConsumerState<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends ConsumerState<SubscriptionTab> {
  int selected = -1;
  PlanModel? selectedPlan;
  String? planId;

  makePayment({
    required BuildContext context,
    required WidgetRef ref,
    required PlanModel planModel,
    required ShopModel shop,
  }) {
    final currentDate = DateTime.now();
    final expirationDate =
        currentDate.add(Duration(days: selectedPlan!.duration * 30));

    /// Assuming 30 days in a month

    ///  updated subscription and expiration date to shop model
    final shopModel = shop.copyWith(
        subscriptionId: selectedPlan!.name, expirationDate: expirationDate);

    ///Save the shopModel with the updated information to Firebase
    showDialog(
      context: context,
      builder: (context1) => AlertDialog(
          content: const Text('Proceed to purchase your plan'),
          actions: [
            TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Routemaster.of(context).pop();
                  ref
                      .read(addStoreControllerProvider.notifier)
                      .addSub(context: context, shop: shopModel);
                },
                child: const Text('proceed'))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Routemaster.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Pallete.secondaryColor,
              )),
          title: const Center(
            child: Text("Select Subscription",
                style: TextStyle(
                  color: Pallete.secondaryColor,
                )),
          ),
          toolbarHeight: deviceHeight * 0.1,
          backgroundColor: Pallete.primaryColor,
          elevation: 0,
        ),
        body: ref.watch(getUserShopWebProvider(widget.sid)).when(
              data: (data) => Row(
                children: [
                  SizedBox(
                    width: deviceWidth * 0.1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.8,
                        width: deviceWidth * 0.65,
                        child: ref.watch(plansProvider).when(
                              data: (data) => GridView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  PlanModel plan = data[index];
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                          selectedPlan = plan;
                                        });
                                      },
                                      child: selected == index
                                          ? Container(
                                              height: deviceHeight * 0.3,
                                              width: deviceWidth * 0.35,
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 3,
                                                        spreadRadius: 1,
                                                        offset: Offset(4, 4))
                                                  ],
                                                  color: Pallete.secondaryColor,
                                                  border: Border.all(
                                                      color:
                                                          Pallete.primaryColor,
                                                      width:
                                                          deviceHeight * 0.003),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceHeight * 0.03)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        plan.name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                deviceWidth *
                                                                    0.024,
                                                            color: Pallete
                                                                .primaryColor),
                                                      ),
                                                      Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.006),
                                                      ),
                                                      Text(
                                                        " Validity: ${plan.duration} months",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.028,
                                                            color: Pallete
                                                                .primaryColor),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            deviceHeight * 0.05,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: deviceHeight *
                                                                0.15),
                                                        child: Text(
                                                            "₹ ${plan.price.toString()}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.025,
                                                                color: Pallete
                                                                    .primaryColor)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              height: deviceHeight * 0.3,
                                              width: deviceWidth * 0.35,
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 3,
                                                        spreadRadius: 1,
                                                        offset: Offset(4, 4))
                                                  ],
                                                  color: Pallete.thirdColor,
                                                  border: Border.all(
                                                      color: Colors.transparent,
                                                      width:
                                                          deviceHeight * 0.003),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          deviceHeight * 0.03)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        plan.name,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize:
                                                                deviceWidth *
                                                                    0.024,
                                                            color: Pallete
                                                                .secondaryColor),
                                                      ),
                                                      Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.006),
                                                      ),
                                                      Text(
                                                        " Validity: ${plan.duration} months",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize:
                                                                deviceHeight *
                                                                    0.028,
                                                            color: Pallete
                                                                .secondaryColor),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            deviceHeight * 0.05,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top: deviceHeight *
                                                                0.15),
                                                        child: Text(
                                                            "₹ ${plan.price.toString()}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.025,
                                                                color: Pallete
                                                                    .secondaryColor)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ));
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2,
                                  crossAxisSpacing: deviceHeight * 0.06,
                                  mainAxisSpacing: deviceHeight * 0.06,
                                ),
                              ),
                              error: (error, stackTrace) {
                                return ErrorText(error: error.toString());
                              },
                              loading: () => const Loader(),
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: deviceWidth * 0.05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Routemaster.of(context).pop(),
                        child: Container(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Pallete.secondaryColor, width: 1),
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.03),
                          ),
                          child: Center(
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceHeight * 0.027),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.06,
                      ),
                      InkWell(
                        onTap: () {
                          if (selectedPlan == null) {
                            showSnackBar(context, 'Select a plan');
                          } else {
                            makePayment(
                                context: context,
                                ref: ref,
                                planModel: selectedPlan!,
                                shop: data);
                          }
                        },
                        child: Container(
                          height: deviceHeight * 0.1,
                          width: deviceWidth * 0.15,
                          decoration: BoxDecoration(
                            color: Pallete.secondaryColor,
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.03),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Payment ",
                                style: TextStyle(
                                    color: Pallete.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceHeight * 0.025),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Pallete.primaryColor,
                                size: deviceHeight * 0.023,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: deviceWidth * 0.03,
                      ),
                    ],
                  ),
                ],
              ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
