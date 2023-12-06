import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/error.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:inventory_management_shop/features/Customers/controller/customer_controller.dart';
import 'package:inventory_management_shop/models/customer_model.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

class Customer_Screen_Web extends ConsumerStatefulWidget {
  final String shopId;
  Customer_Screen_Web({super.key, required this.shopId});

  @override
  ConsumerState<Customer_Screen_Web> createState() =>
      _Customer_Screen_WebState();
}

class _Customer_Screen_WebState extends ConsumerState<Customer_Screen_Web> {
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  deleteAlertDialog(BuildContext context, cust) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Pallete.secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Delete', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure?',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'No',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            TextButton(
              onPressed: () {
                deleteCustomer(ref, cust, context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Yes',
                style:
                    TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        );
      },
    );
  }

  addCustomer(WidgetRef ref, BuildContext context) {
    // Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    // String shopId = map['shopId'];
    if (_formKey.currentState!.validate()) {
      CustomerModel customerModel = CustomerModel(
        customerName: customerName.text.trim(),
        phoneNumber: customerPhone.text.trim(),
        shopId: [widget.shopId],
        setSearch: [],
        saleId: [],
        createdTime: DateTime.now(),
        deleted: false,
      );
      ref.watch(customerControllerProvider.notifier).addCustomers(
            context: context,
            customerModel: customerModel,
          );
      customerPhone.clear();
      customerName.clear();
    }
  }

  deleteCustomer(
      WidgetRef ref, CustomerModel customerModel, BuildContext context) {
    customerModel = customerModel.copyWith(deleted: true);
    ref
        .read(customerControllerProvider.notifier)
        .deleteCustomer(customerModel, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(customerControllerProvider);
    return isLoading
        ? const Loader()
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: deviceHeight * 0.03),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => Routemaster.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.secondaryColor,
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
                        SizedBox(
                          width: deviceWidth * 0.4,
                        ),
                        Text(
                          "Customers",
                          style: TextStyle(
                              color: Pallete.secondaryColor,
                              fontSize: deviceWidth * .02,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.03, top: deviceHeight * 0.08),
                      child: SizedBox(
                        // color: Colors.red,
                        height: deviceHeight * 0.85,
                        width: deviceWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: deviceHeight * 0.85,
                              width: deviceWidth * 0.6,
                              child: Consumer(builder: (context, ref, child) {
                                // Map<String, dynamic> map = jsonDecode(
                                //     Uri.decodeComponent(widget.encode));
                                // String shopId = map['shopId'];
                                var customer = ref
                                    .watch(getCustomerProvider(widget.shopId));
                                return customer.when(
                                  data: (data) {
                                    return data.isEmpty
                                        ? Center(
                                            child: Column(
                                            children: [
                                              SizedBox(
                                                  height: deviceHeight * 0.5,
                                                  width: deviceWidth * 0.5,
                                                  child: Lottie.asset(
                                                      AssetConstants.noSmiley)),
                                              Text(
                                                "Oops! No Customers Yet...",
                                                style: TextStyle(
                                                    fontSize:
                                                        deviceWidth * 0.015,
                                                    color:
                                                        Pallete.secondaryColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ))
                                        : GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        2, // Number of columns you want in the grid
                                                    crossAxisSpacing: deviceWidth *
                                                        0.02, // Spacing between columns
                                                    mainAxisSpacing: deviceWidth *
                                                        0.02, // Spacing between rows
                                                    childAspectRatio: 3 / 4,
                                                    mainAxisExtent: 100),
                                            itemCount: data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              CustomerModel cust = data[index];
                                              return Container(
                                                height: deviceHeight * 0.1,
                                                width: deviceWidth * 0.2,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    width: deviceWidth * 0.001,
                                                    color:
                                                        Pallete.secondaryColor,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.02),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left:
                                                            deviceWidth * 0.005,
                                                        top: deviceHeight *
                                                            0.033,
                                                      ),
                                                      child: Container(
                                                        height:
                                                            deviceHeight * 0.1,
                                                        width:
                                                            deviceWidth * 0.19,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              cust.customerName,
                                                              style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.011,
                                                              ),
                                                            ),
                                                            Text(
                                                              cust.phoneNumber,
                                                              style: TextStyle(
                                                                color: Pallete
                                                                    .secondaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    deviceWidth *
                                                                        0.009,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    // SizedBox(width: deviceWidth * 0.02),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: deviceWidth *
                                                              0.015,
                                                          top: deviceHeight *
                                                              0.033,
                                                          right: deviceWidth *
                                                              0.001),
                                                      child: Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              deleteAlertDialog(
                                                                  context,
                                                                  cust);
                                                              // deleteCustomer(ref, cust, context);
                                                            },
                                                            child: const Icon(
                                                                Icons.delete,
                                                                color: Pallete
                                                                    .secondaryColor),
                                                          ),
                                                          Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: Pallete
                                                                  .secondaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  deviceWidth *
                                                                      0.009,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(error: error.toString()),
                                  loading: () => const Loader(),
                                );
                              }),
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              thickness: 1,
                              indent: deviceHeight * 0.02,
                              endIndent: deviceHeight * 0.02,
                            ),
                            SizedBox(
                              height: deviceHeight * 0.85,
                              child: Form(
                                key: _formKey1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: deviceWidth * 0.3,
                                      height: deviceHeight * 0.3,
                                      child: Lottie.asset(
                                          AssetConstants.supplierLottie),
                                    ),
                                    SizedBox(
                                      height: deviceHeight * 0.10,
                                      width: deviceWidth * 0.2,
                                      child: TextFormField(
                                        maxLength: 25,
                                        controller: customerName,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Name',
                                          labelStyle: const TextStyle(
                                              color: Pallete.secondaryColor),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter custmor name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceHeight * 0.02,
                                    ),
                                    SizedBox(
                                      height: deviceHeight * 0.10,
                                      width: deviceWidth * 0.2,
                                      child: TextFormField(
                                        maxLines: 10,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: customerPhone,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Number',
                                          labelStyle: const TextStyle(
                                              color: Pallete.secondaryColor),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      deviceWidth * 0.01),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Pallete.secondaryColor)),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter phone number';
                                          }
                                          final isNumeric = int.tryParse(value);
                                          if (isNumeric == null ||
                                              value.length != 10) {
                                            return 'Phone number must be exactly 10 digits';
                                          }
                                          return null;
                                        },
                                        maxLength: 10,
                                      ),
                                    ),
                                    SizedBox(
                                      height: deviceHeight * 0.02,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (_formKey1.currentState!
                                            .validate()) {
                                          if (customerName.text
                                                  .trim()
                                                  .isEmpty ||
                                              customerPhone.text
                                                  .trim()
                                                  .isEmpty) {
                                            showSnackBar(context,
                                                'please fill all the field');
                                          } else {
                                            await addCustomer(ref, context);
                                            customerPhone.clear();
                                            customerName.clear();
                                            // customerName.clear();
                                            // customerPhone.clear();
                                          }
                                        }
                                      },
                                      child: Container(
                                          height: deviceHeight * 0.07,
                                          width: deviceWidth * 0.13,
                                          decoration: BoxDecoration(
                                            color: Pallete.secondaryColor,
                                            border: Border.all(
                                              color: Pallete.primaryColor,
                                              // Border color
                                              width: deviceWidth * 0.001,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Add Customer',
                                                style: TextStyle(
                                                    fontSize:
                                                        deviceWidth * 0.011,
                                                    color:
                                                        Pallete.primaryColor),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
