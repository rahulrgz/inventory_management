import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../core/utils.dart';
import '../../../../models/plans_model.dart';
import '../../../../models/shope_model.dart';
import '../../controller/addstore_controller.dart';

class PlansubscriptionMobile extends ConsumerStatefulWidget {
  final String sid;

  const PlansubscriptionMobile({super.key, required this.sid});

  @override
  ConsumerState<PlansubscriptionMobile> createState() =>
      _PlansubscriptionMobileState();
}

class _PlansubscriptionMobileState
    extends ConsumerState<PlansubscriptionMobile> {
  int _selectedIndex = -1;
  PlanModel? selectedPlan;
  // late Razorpay _razorpay;
  // bool isPaymentComplete = false;
  //
  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   // Payment was successful
  //   setState(() {
  //     isPaymentComplete = true;
  //   });
  //   print('Payment Successful: ${response.paymentId}');
  // }
  //
  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Payment failed
  //   print('Payment Error: ${response.message}');
  // }
  //
  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // External wallet selected
  //   print('External Wallet: ${response.walletName}');
  // }
  //
  // void openRazorpayPayment() {
  //   var options = {
  //     'key': 'rzp_test_GqBW8xGvT6hpIi', // Replace with your Razorpay API Key
  //     'amount': 100, // Amount in paise (10000 paise = ₹100)
  //     'name': 'kpirshad',
  //     'description': 'test payment ',
  //     'prefill': {
  //       'contact': '7592072890', // Customer phone number
  //       'email': 'kpirshad51712@gmail.com', // Customer email address
  //     },
  //     'external': {
  //       'wallets': ['gpay'] // External wallets supported (optional)
  //     }
  //   };
  //
  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     print('Error occurred while opening Razorpay: $e');
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _razorpay.clear();
  //   super.dispose();
  // }
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _razorpay = Razorpay();
  //
  //   // Define your Razorpay API Key ID
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }

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
          contentTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              color: Pallete.primaryColor,
              fontSize: deviceWidth * 0.045),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Pallete.secondaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.08)),
          actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
          content: SizedBox(
            height: deviceHeight * 0.09,
            width: deviceWidth * 0.3,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Proceed To Purchase your Plan'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.primaryColor)),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(addStoreControllerProvider.notifier)
                    .addSub(context: context, shop: shopModel);

                Routemaster.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Proceed',
                style: TextStyle(
                    fontSize: deviceWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Pallete.secondaryColor),
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Pallete.secondaryColor,
            size: deviceWidth * 0.07,
          ),
        ),
        title: Text(
          'Select Subscription',
          style: TextStyle(
            color: Pallete.secondaryColor,
            fontSize: deviceWidth * 0.05,
          ),
        ),
      ),
      body: ref.watch(getUserShopWebProvider(widget.sid)).when(
            data: (data) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     if (!isPaymentComplete) {
                        //       openRazorpayPayment();
                        //     } else {
                        //       // Payment is already complete, handle accordingly
                        //       print('Payment already completed!');
                        //     }
                        //   },
                        //   child: Text("razorpay",
                        //       style: TextStyle(
                        //           fontSize: deviceWidth * 0.04,
                        //           color: Pallete.secondaryColor)),
                        // ),
                        // Icon(
                        //   Icons.payment,
                        //   color: Pallete.secondaryColor,
                        //   size: deviceWidth * 0.035,
                        // ),
                        SizedBox(
                          width: deviceWidth * 0.09,
                        ),
                        GestureDetector(
                          onTap: () {
                            Routemaster.of(context).push('/store/homescreen/');
                          },
                          child: Text("Skip",
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.04,
                                  color: Pallete.secondaryColor)),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right,
                          color: Pallete.secondaryColor,
                          size: deviceWidth * 0.035,
                        )
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.65,
                      child: ref.watch(plansProvider).when(
                            data: (data) => ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  PlanModel plan = data[index];

                                  bool isSelected = index == _selectedIndex;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                        selectedPlan = plan;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.all(deviceWidth * 0.025),
                                      child: Container(
                                        height: deviceHeight * 0.13,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Pallete.secondaryColor
                                              : Pallete.primaryColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Pallete.containerColor,
                                              offset: Offset(
                                                -1.0,
                                                2.0,
                                              ),
                                              blurRadius: 1.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(
                                              deviceWidth * 0.04),
                                          border: Border.all(
                                              color: Pallete.thirdColor),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: deviceHeight * 0.13,
                                                width: deviceWidth * 0.04,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    plan.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            deviceWidth * 0.05,
                                                        color: isSelected
                                                            ? Pallete
                                                                .primaryColor
                                                            : Pallete
                                                                .secondaryColor),
                                                  ),
                                                  Text(
                                                    'Validity: ${plan.duration.toString()} Months',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize:
                                                            deviceWidth * 0.04,
                                                        color: isSelected
                                                            ? Pallete
                                                                .primaryColor
                                                            : Pallete
                                                                .secondaryColor),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              SizedBox(
                                                height: deviceHeight * 0.13,
                                                width: deviceWidth * 0.24,
                                                child: Center(
                                                  child: Text(
                                                    '₹ ${plan.price}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            deviceWidth * 0.048,
                                                        color: isSelected
                                                            ? Pallete
                                                                .primaryColor
                                                            : Pallete
                                                                .secondaryColor),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => Loader(),
                          ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.95,
                      height: deviceHeight * 0.073,
                      child: Consumer(
                        builder: (ctxt, ref, child) => ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.035),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (selectedPlan == null) {
                              showSnackBar(context, 'Please select a plan');
                            } else {
                              makePayment(
                                  context: context,
                                  ref: ref,
                                  planModel: selectedPlan!,
                                  shop: data);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Make Payment",
                                style: TextStyle(fontSize: deviceWidth * 0.045),
                              ),
                              SizedBox(
                                width: deviceWidth * 0.01,
                              ),
                              Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.white,
                                size: deviceWidth * 0.05,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => Loader(),
          ),
    );
  }
}

class SelectedItemNotifier extends ChangeNotifier {
  int _selectedItemIndex = -1;

  int get selectedItemIndex => _selectedItemIndex;

  void setSelectedItemIndex(int index) {
    _selectedItemIndex = index;
    notifyListeners();
  }
}
