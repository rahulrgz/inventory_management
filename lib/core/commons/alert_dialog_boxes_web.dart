import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_management_shop/core/constants/asset_constants/asset_constants.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import '../theme/pallete.dart';

void addItemBox({
  required BuildContext context,
  required TextEditingController itemName,
  required TextEditingController itemQty,
  required TextEditingController purchasePrice,
  required TextEditingController salePrice,
  required Function() addProduct,
}) {
  showDialog(
      context: context,
      builder: (context) {
        String dropdownValueTab = 'Num';

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(deviceWidth * 0.015)),
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Pallete.secondaryColor,
              fontSize: deviceWidth * 0.015),
          titlePadding: EdgeInsets.only(
              top: deviceHeight * 0.035, left: deviceWidth * 0.165),
          actionsPadding: EdgeInsets.only(
              bottom: deviceHeight * 0.035, right: deviceWidth * 0.015),
          title: const Text('Add Item'),
          content: SizedBox(
            height: deviceHeight * 0.4,
            width: deviceWidth * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.065,
                      width: deviceWidth * 0.3,
                      child: TextFormField(
                        maxLength: 25,
                        controller: itemName,
                        decoration: InputDecoration(
                          labelText: 'Item Name',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.065,
                      width: deviceWidth * 0.135,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 4,
                        controller: itemQty,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.02,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.067,
                      width: deviceWidth * 0.135,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(deviceHeight * 0.03),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.03),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor),
                              borderRadius:
                                  BorderRadius.circular(deviceHeight * 0.03),
                            ),
                            label: const Text(
                              ' Unit',
                              style: TextStyle(color: Pallete.secondaryColor),
                            )),
                        dropdownColor: Pallete.primaryColor,
                        value: dropdownValueTab,
                        onChanged: (newValue) {},
                        items: <String>['Num', 'KG', 'G', 'Ltr', 'Mtr']
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: deviceHeight * 0.025),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.065,
                      width: deviceWidth * 0.3,
                      child: TextFormField(
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: purchasePrice,
                        decoration: InputDecoration(
                          labelText: 'Purchase Price',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.04,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.065,
                      width: deviceWidth * 0.3,
                      child: TextFormField(
                        maxLength: 6,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: salePrice,
                        decoration: InputDecoration(
                          labelText: 'Sale Price',
                          labelStyle:
                              const TextStyle(color: Pallete.secondaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              borderSide: const BorderSide(
                                  color: Pallete.secondaryColor)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Routemaster.of(context).pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.125, deviceHeight * 0.08),
                backgroundColor: Pallete.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: deviceWidth * 0.0125,
                    color: Pallete.secondaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: addProduct,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(deviceWidth * 0.125, deviceHeight * 0.08),
                backgroundColor: Pallete.secondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                    side: const BorderSide(color: Pallete.secondaryColor)),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                    fontSize: deviceWidth * 0.0125,
                    color: Pallete.primaryColor),
              ),
            ),
          ],
        );
      });
}

void deleteConfirmBox(
    {required BuildContext context, required Function() onDelete}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Pallete.primaryColor,
          fontSize: deviceWidth * 0.015),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Pallete.secondaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
      actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
      content: SizedBox(
        height: deviceHeight * 0.15,
        width: deviceWidth * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete?',
              style: TextStyle(fontSize: deviceWidth * 0.06),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Routemaster.of(context).pop(),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.06),
            backgroundColor: Pallete.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                side: const BorderSide(color: Pallete.primaryColor)),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
                fontSize: deviceWidth * 0.03,
                fontWeight: FontWeight.bold,
                color: Pallete.primaryColor),
          ),
        ),
        ElevatedButton(
          onPressed: onDelete,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.06),
            backgroundColor: Pallete.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                side: const BorderSide(color: Pallete.secondaryColor)),
          ),
          child: Text(
            'Delete',
            style: TextStyle(
                fontSize: deviceWidth * 0.03,
                fontWeight: FontWeight.bold,
                color: Pallete.secondaryColor),
          ),
        ),
      ],
    ),
  );
}

void deleteConfirmBoxMobile(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
            Text('Are you sure you want to delete?'),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
            backgroundColor: Pallete.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                side: const BorderSide(color: Pallete.secondaryColor)),
          ),
          child: Text(
            'Delete',
            style: TextStyle(
                fontSize: deviceWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Pallete.secondaryColor),
          ),
        ),
      ],
    ),
  );
}

void planNotifierBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Pallete.primaryColor,
          fontSize: deviceWidth * 0.015),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: Pallete.secondaryColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(deviceWidth * 0.02)),
      actionsPadding: EdgeInsets.only(bottom: deviceHeight * 0.05),
      content: SizedBox(
        height: deviceHeight * 0.15,
        width: deviceWidth * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: deviceHeight * 0.1,
              width: deviceWidth * 0.2,
              child: Column(
                children: [
                  Text('Purchase a plan to access all'),
                  Text(' features !')
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Routemaster.of(context).pop(),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(deviceWidth * 0.11, deviceHeight * 0.06),
            backgroundColor: Pallete.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                side: const BorderSide(color: Pallete.primaryColor)),
          ),
          child: Text(
            'Go Back',
            style: TextStyle(
                fontSize: deviceWidth * 0.0125,
                fontWeight: FontWeight.bold,
                color: Pallete.primaryColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(deviceWidth * 0.11, deviceHeight * 0.06),
            backgroundColor: Pallete.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                side: const BorderSide(color: Pallete.secondaryColor)),
          ),
          child: Text(
            'Purchase',
            style: TextStyle(
                fontSize: deviceWidth * 0.0125,
                fontWeight: FontWeight.bold,
                color: Pallete.secondaryColor),
          ),
        ),
      ],
    ),
  );
}

void addSupplierOrCustomer(BuildContext context, String name) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.015)),
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Pallete.secondaryColor,
                fontSize: deviceWidth * 0.015),
            titlePadding: EdgeInsets.only(
                top: deviceHeight * 0.035, left: deviceWidth * 0.145),
            actionsPadding: EdgeInsets.only(
                bottom: deviceHeight * 0.035, right: deviceWidth * 0.015),
            title: Text(name),
            content: SizedBox(
              height: deviceHeight * 0.4,
              width: deviceWidth * 0.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.065,
                        width: deviceWidth * 0.3,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Name',
                            labelStyle:
                                const TextStyle(color: Pallete.secondaryColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: deviceHeight * 0.065,
                    width: deviceWidth * 0.3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Number',
                        labelStyle:
                            const TextStyle(color: Pallete.secondaryColor),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.01),
                            borderSide: const BorderSide(
                                color: Pallete.secondaryColor)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.01),
                            borderSide: const BorderSide(
                                color: Pallete.secondaryColor)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(deviceWidth * 0.01),
                            borderSide: const BorderSide(
                                color: Pallete.secondaryColor)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.15,
                        width: deviceWidth * 0.165,
                        child: TextFormField(
                          maxLines: 30,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Address',
                            labelStyle:
                                const TextStyle(color: Pallete.secondaryColor),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth * 0.01),
                                borderSide: const BorderSide(
                                    color: Pallete.secondaryColor)),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: deviceHeight * 0.15,
                          width: deviceWidth * 0.1,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(deviceWidth * 0.01),
                              border:
                                  Border.all(color: Pallete.secondaryColor)),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Routemaster.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceWidth * 0.125, deviceHeight * 0.08),
                  backgroundColor: Pallete.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                      side: const BorderSide(color: Pallete.secondaryColor)),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      fontSize: deviceWidth * 0.0125,
                      color: Pallete.secondaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceWidth * 0.125, deviceHeight * 0.08),
                  backgroundColor: Pallete.secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(deviceHeight * 0.02),
                      side: const BorderSide(color: Pallete.secondaryColor)),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: deviceWidth * 0.0125,
                      color: Pallete.primaryColor),
                ),
              ),
            ],
          ));
}

workOnProgressAlertDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              height: deviceHeight * 0.4,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Pallete.secondaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(AssetConstants.workProgress,
                      width: deviceWidth * 0.3, height: deviceHeight * 0.3),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
