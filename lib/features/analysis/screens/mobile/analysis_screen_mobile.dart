import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../models/shope_model.dart';

class AnalysisScreenMobile extends StatelessWidget {
  final ShopModel shop;
  const AnalysisScreenMobile({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.07,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Pallete.thirdColor,
                      radius: deviceHeight * 0.035,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('welcome',
                              style: TextStyle(color: Pallete.secondaryColor)),
                          Text(
                            shop.name,
                            style: TextStyle(
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth * 0.045),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Icon(
                  CupertinoIcons.bell_solid,
                  color: Pallete.secondaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: deviceWidth * 0.44,
                height: deviceHeight * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Pallete.thirdColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Cash In-Hand',
                        style: TextStyle(
                            color: Pallete.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 0.03)),
                    Text('₹ 32400.00',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 0.05)),
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.44,
                height: deviceHeight * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Pallete.thirdColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Stock Value',
                      style: TextStyle(
                          color: Pallete.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: deviceWidth * 0.03),
                    ),
                    Text('₹ 63000.00',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 0.05))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceHeight * 0.025,
          ),
          Container(
            width: deviceWidth * 0.93,
            height: deviceHeight * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Pallete.thirdColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Expense',
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: deviceWidth * 0.05),
                ),
                Row(
                  children: [
                    Text('₹ 30800.00',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: deviceWidth * 0.05)),
                    SizedBox(
                      width: deviceWidth * 0.03,
                    ),
                    Icon(
                      CupertinoIcons.right_chevron,
                      color: Pallete.secondaryColor,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.025,
          ),
          DataTable(columnSpacing: deviceWidth * 0.4, columns: [
            DataColumn(
              label: Text(
                'Need',
                style: TextStyle(color: Pallete.secondaryColor),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: TextStyle(color: Pallete.secondaryColor),
              ),
            ),
          ], rows: [
            DataRow(cells: [
              DataCell(Text(
                "Rent",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
              DataCell(Text(
                "₹30000.00",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Petrol",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
              DataCell(Text(
                "₹500.00",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Transport",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
              DataCell(Text(
                "₹300.00",
                style: TextStyle(color: Pallete.secondaryColor),
              )),
            ]),
          ]),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Routemaster.of(context).push('/analyse/addExpense');
              },
              child: Container(
                  height: deviceHeight * 0.07,
                  // width: deviceWidth * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFD9D9D9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Icon(
                        Icons.add_circle_outline_sharp,
                        color: Pallete.secondaryColor,
                        size: deviceWidth * 0.04,
                      )),
                      SizedBox(width: deviceWidth * 0.001),
                      Text(
                        'Add Expense ',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.04,
                            color: Pallete.secondaryColor),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
