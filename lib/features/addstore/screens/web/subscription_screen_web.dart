import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/addstore/controller/addStore_controller.dart';
import 'package:inventory_management_shop/models/plans_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class SubscriptionScreenWeb extends ConsumerStatefulWidget {
  final String sid;
  const SubscriptionScreenWeb({Key? key,required this.sid}) : super(key: key);

  @override
  ConsumerState<SubscriptionScreenWeb> createState() => _SubscriptionScreenWebState();
}

class _SubscriptionScreenWebState extends ConsumerState<SubscriptionScreenWeb> {
  PlanModel? selectedPlan;
  int selected = -1;

  makePayment(
      {required BuildContext context,
        required WidgetRef ref,
        required PlanModel plan,
        required ShopModel shop}) {

    /// Calculate the expiration date based on the selected plan's duration
    final currentDate = DateTime.now();
    final expirationDate = currentDate.add(Duration(days: plan.duration * 30)); /// Assuming 30 days in a month

    ///  updated subscription and expiration date to shop model
    final shopModel = shop.copyWith(
      subscriptionId: plan.name,
      expirationDate: expirationDate
    );
    ///Save the shopModel with the updated information to Firebase
    ref.read(addStoreControllerProvider.notifier).addSub(context: context, shop: shopModel);

    Routemaster.of(context).replace('/store');
    showDialog(
      context: context,
      builder: (context1) => AlertDialog(
        content: const Text('Proceed to purchase your plan'),
        actions: [
          TextButton(
            onPressed: () {
              Routemaster.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ShopModel shopModel = shop.copyWith(subscriptionId: plan.name);
              ref
                  .read(addStoreControllerProvider.notifier)
                  .addSub(context: context, shop: shopModel);
              Routemaster.of(context).replace('/store');
            },
            child: const Text('proceed'),
          ),
        ],
      ),
    );

  }
  @override
  Widget build(BuildContext context) {

    deviceHeight= MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    void showAlert(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Proceed'),
              ),
            ],
          );
        },
      );
    }
    return Scaffold(
      body:  ref.watch(getUserShopWebProvider(widget.sid)).when(data:(data) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: deviceHeight*0.03),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: ()=>Routemaster.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    // minimumSize: Size(deviceWidth*0.02, deviceHeight*0.06),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(deviceHeight*0.02),
                          bottomRight: Radius.circular(deviceHeight*0.02),
                        )
                    ),
                  ),
                  child:  Center(child: Icon(
                    Icons.arrow_back_rounded,color: Pallete.primaryColor,size: deviceHeight*0.03,)),
                ),
                SizedBox(width: deviceWidth*0.4,),
                Text("Select Subscription",
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth*.02,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight*0.8,),
              SizedBox(
                width: deviceWidth*0.6,
                height: deviceHeight*0.9,
                child: Consumer(
                    builder: (context,ref,child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: deviceWidth*0.55,
                            height: deviceHeight*0.75,
                            child: ref.watch(plansProvider).when(
                              data: (data) => GridView.builder(
                                itemCount: data.length,
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 200,
                                    maxCrossAxisExtent: 450,
                                    childAspectRatio: 3/1.5,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                                itemBuilder: (context,index) {
                                  PlanModel plan=data[index];
                                  return Center(
                                    child:  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected = index;
                                          selectedPlan =plan;
                                        });
                                      },
                                      child: Container(
                                        height: deviceHeight*0.21,
                                        width: deviceWidth*0.26,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white54.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(
                                              color: selected==index
                                                  ? Colors.red
                                                  :Pallete.secondaryColor),
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.all(deviceWidth*0.015),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: deviceWidth*0.015,),
                                                  Text('${plan.name}\nMembership',
                                                    style: TextStyle(
                                                        color: Pallete.secondaryColor,
                                                        fontSize: deviceWidth*0.0145,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: deviceWidth*0.015,),
                                                  Text('Validity : ${plan.duration} Month',
                                                    style: const TextStyle(
                                                        color: Pallete.secondaryColor
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: deviceHeight*0.015,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text("\₹ ${plan.price}.0",
                                                    style: TextStyle(
                                                        fontSize: deviceWidth*0.015,
                                                        fontWeight: FontWeight.bold,
                                                        color: Pallete.secondaryColor
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              error: (error, stackTrace) => ErrorText(error: error.toString()),
                              loading: () => const Loader(),),
                          ),
                        ],
                      );
                    }
                ),
              ),
              SizedBox(width: deviceWidth*0.03,),
              SizedBox(
                height: deviceHeight*0.9,
                width: deviceWidth*0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: deviceHeight*0.05,),
                    ElevatedButton(
                      onPressed: ()=>Routemaster.of(context).push('/store'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(deviceWidth*0.13, deviceHeight*0.09),
                        backgroundColor: Pallete.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceHeight*0.02),
                            side: const BorderSide(color: Pallete.secondaryColor)
                        ),
                      ),
                      child:  Text('Skip',
                        style: TextStyle(
                            fontSize: deviceWidth*0.011,
                            color: Pallete.secondaryColor
                        ),
                      ),
                    ),
                    SizedBox(height: deviceHeight*0.02,),
                    ElevatedButton(
                      onPressed: (){
                        if (selectedPlan==null) {
                          showAlert("Please choose a plan");
                        } else {
                          makePayment(
                              context: context,
                              ref: ref,
                              plan:selectedPlan! ,
                              shop: data);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(deviceWidth*0.13, deviceHeight*0.09),
                        maximumSize: Size(deviceWidth*0.13, deviceHeight*0.09),
                        backgroundColor: Pallete.secondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceHeight*0.02),
                            side: const BorderSide(color: Pallete.secondaryColor)
                        ),
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Payments',
                            style: TextStyle(
                                fontSize: deviceWidth*0.011,
                                color: Pallete.primaryColor
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios,size: deviceWidth*0.011,color: Pallete.primaryColor,)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ), error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),),
    );
  }
}
