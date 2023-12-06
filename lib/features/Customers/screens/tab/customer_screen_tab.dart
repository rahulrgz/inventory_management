import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/utils.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/error.dart';
import '../../../../core/commons/loader.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/customer_model.dart';
import '../../controller/customer_controller.dart';

class CustomersScreenTab extends ConsumerStatefulWidget {
  final String encode;
  const CustomersScreenTab({super.key, required this.encode});
  @override
  ConsumerState<CustomersScreenTab> createState() => _CustomersScreenTabState();
}

class _CustomersScreenTabState extends ConsumerState<CustomersScreenTab> {
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhone = TextEditingController();
  // TextEditingController customerAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  addCustomer(WidgetRef ref, BuildContext context) {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    String shopId = map['shopId'];
    if (_formKey.currentState!.validate()) {
      CustomerModel customerModel = CustomerModel(
        customerName: customerName.text.trim(),
        phoneNumber: customerPhone.text.trim(),
        shopId: [shopId],
        setSearch: [],
        saleId: [],
        createdTime: DateTime.now(),
        deleted: false,
        // customerProfile: '',
      );
      ref.watch(customerControllerProvider.notifier).addCustomers(
            context: context,
            customerModel: customerModel,
            // profileFile: null,
            // androidFile: profileFile
          );
    }
  }

  // File? profileFile;
  //
  // void selectProfileImage() async {
  //   final res = await pickImage();
  //   if (res != null) {
  //     setState(() {
  //       profileFile = File(res.files.first.path!);
  //     });
  //   }
  // }

  deleteCustomer(
      WidgetRef ref, CustomerModel customerModel, BuildContext context) {
    customerModel = customerModel.copyWith(deleted: true);
    ref
        .read(customerControllerProvider.notifier)
        .deleteCustomer(customerModel, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Routemaster.of(context).pop('/store/homescreen/:shop');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.secondaryColor,
            )),
        title: const Text(
          'CUSTOMER',
          style: TextStyle(color: Pallete.secondaryColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Row(
          children: [
            SizedBox(
              height: deviceHeight,
              width: deviceWidth * 0.5,
              child: Consumer(builder: (context, ref, child) {
                Map<String, dynamic> map =
                    jsonDecode(Uri.decodeComponent(widget.encode));
                String shopId = map['shopId'];
                var customer = ref.watch(getCustomerProvider(shopId));
                return customer.when(
                  data: (data) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: deviceHeight * 0.05,
                          right: deviceHeight * 0.05),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          CustomerModel customer = data[index];
                          return Padding(
                            padding: EdgeInsets.all(deviceHeight * 0.02),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        spreadRadius: 1,
                                        offset: Offset(4, 4))
                                  ],
                                  color: Pallete.thirdColor,
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02)),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceHeight * 0.03)),
                                title: Text(
                                  customer.customerName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: deviceHeight * 0.028,
                                      color: Pallete.secondaryColor),
                                ),
                                subtitle: Text(customer.phoneNumber,
                                    style: TextStyle(
                                        color: Pallete.secondaryColor,
                                        fontSize: deviceHeight * 0.024)),
                                // trailing: IconButton(
                                //     onPressed: () {
                                //       deleteCustomer(ref, customer, context);
                                //     },
                                //     icon: const Icon(
                                //       Icons.delete_outline_outlined,
                                //       color: Pallete.secondaryColor,
                                //     )),
                                onTap: () {},
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
              }),
            ),
            SizedBox(
              height: deviceHeight,
              width: deviceWidth * 0.5,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.07,
                      child: Center(
                          child: Text(
                        'ADD CUSTOMER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Pallete.secondaryColor,
                            fontSize: deviceHeight * 0.038),
                      )),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     selectProfileImage();
                    //   },
                    //   child: CircleAvatar(
                    //     radius: deviceHeight * 0.1,
                    //     child: profileFile != null
                    //         ? CircleAvatar(
                    //             radius: deviceHeight * 0.1,
                    //             backgroundImage: FileImage(profileFile!),
                    //           )
                    //         : Center(
                    //             child: Icon(
                    //               Icons.add_photo_alternate_outlined,
                    //               size: deviceHeight * 0.05,
                    //               color: Pallete.blackColor,
                    //             ),
                    //           ),
                    //   ),
                    // ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Customer name can't be empty !!";
                          } else {
                            return null;
                          }
                        },
                        controller: customerName,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            label: const Text(
                              '  Enter Name',
                              style: TextStyle(color: Pallete.secondaryColor),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.035,
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Customer Phone Number can't be empty !!";
                          } else if (value.length < 10) {
                            return "Enter a valid Phone Number";
                          }
                          return null;
                        },
                        controller: customerPhone,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            label: const Text(
                              '  Enter Phone Number',
                              style: TextStyle(color: Pallete.secondaryColor),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    // SizedBox(
                    //   height: deviceHeight * 0.15,
                    //   width: deviceWidth * 0.4,
                    //   child: TextFormField(
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return "Customer Address can't be empty !!";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     controller: customerAddress,
                    //     maxLines: 30,
                    //     decoration: InputDecoration(
                    //       alignLabelWithHint: true,
                    //       labelText: 'Address',
                    //       labelStyle:
                    //           const TextStyle(color: Pallete.secondaryColor),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(deviceWidth * 0.01),
                    //           borderSide: const BorderSide(
                    //               color: Pallete.secondaryColor)),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(deviceWidth * 0.01),
                    //           borderSide: const BorderSide(
                    //               color: Pallete.secondaryColor)),
                    //       border: OutlineInputBorder(
                    //           borderRadius:
                    //               BorderRadius.circular(deviceWidth * 0.01),
                    //           borderSide: const BorderSide(
                    //               color: Pallete.secondaryColor)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: deviceHeight * 0.03,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (customerName.text.trim().isEmpty) {
                            showSnackBar(context, 'please enter the details ');
                          } else {
                            addCustomer(ref, context);
                          }
                        }
                        customerName.clear();
                        customerPhone.clear();
                        // customerAddress.clear();
                        // setState(() {
                        //   profileFile = null;
                        // });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(deviceWidth * 0.3, deviceHeight * 0.09),
                        backgroundColor: Pallete.secondaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(deviceHeight * 0.02),
                            side: const BorderSide(
                                color: Pallete.secondaryColor)),
                      ),
                      child: Text(
                        'Add Customer',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.0125,
                            color: Pallete.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
