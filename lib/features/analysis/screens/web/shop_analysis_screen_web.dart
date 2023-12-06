
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

///for rent,petrol texts
final Color textColor = Color.fromRGBO(78, 36, 106, 1);
final textSize = deviceWidth * 0.015;
final textWeight = FontWeight.normal;

class ExpenseItem {
  final String title;
  final int amount;

  ExpenseItem(this.title, this.amount);
}

class Shop_Analysis_screen_web extends StatelessWidget {
  final List<ExpenseItem> expenses = [
    ExpenseItem('Rent', 8000),
    ExpenseItem('Petrol', 5000),
    ExpenseItem('Transport', 500),
  ];
  Shop_Analysis_screen_web({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: deviceHeight * 0.9,
            height: deviceWidth * 0.35,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.09),
                  child: Column(
                    children: [
                      Container(
                        width: deviceHeight * 0.6,
                        height: deviceWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Pallete.containerColor,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top: deviceHeight*0.05),
                              child: Text('Cash In-Hand',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: textColor,
                                      fontSize: textSize

                                  )),
                            ),
                            Spacer(),
                            Padding(
                              padding:  EdgeInsets.only(bottom:deviceHeight*0.03 ),
                              child: Text('\u{20B9}${5000}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: textColor,
                                      fontSize: textSize

                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight*0.08),
                      Container(
                        width: deviceHeight * 0.6,
                        height: deviceWidth * 0.08,
                        decoration: BoxDecoration(
                          color: Pallete.containerColor,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(top: deviceHeight*0.05),
                              child: Text('Stock Value',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: textColor,
                                      fontSize: textSize

                                  )),
                            ),
                            Spacer(),
                            Padding(
                              padding:  EdgeInsets.only(bottom:deviceHeight*0.03),
                              child: Text('\u{20B9}${3080000}',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: textColor,
                                      fontSize: textSize

                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // SizedBox(
          //   width: deviceHeight * 0.1,
          // ),
          SizedBox(
            width: deviceWidth * 0.35,
            height: deviceHeight * 0.7,
            child: Padding(
              padding:  EdgeInsets.only(top: deviceHeight*0.025),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: deviceHeight * 0.6,
                    height: deviceWidth * 0.08,
                    decoration: BoxDecoration(
                      color: Pallete.containerColor,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: deviceWidth*0.03),
                          child: Text('Expenses',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: textColor,
                                  fontSize: textSize

                              )),
                        ),

                        Padding(
                          padding:  EdgeInsets.only(right:deviceWidth*0.03),
                          child: Text('\u{20B9}${3080000}',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: textColor,
                                  fontSize: textSize

                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight*0.03,),
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: deviceHeight*0.02),
                      child: Container(
                        // color: Colors.yellow,
                        width: deviceHeight * 0.6,
                        height: deviceWidth * 0.20,
                        child: ListView.builder(
                          itemCount: expenses.length * 2 - 1,
                          itemBuilder: (context, index) {
                            if (index.isOdd) {
                              return Divider(
                                color: Colors.black,
                                thickness: 1,
                              );
                            } else {
                              final itemIndex = index ~/ 2;
                              final item = expenses[itemIndex];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: deviceWidth*0.015),
                                child: Row(
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: textSize,
                                          color: textColor,
                                          fontWeight: textWeight),
                                    ),
                                    Spacer(),
                                    Text(
                                      '\u{20B9}${item.amount.toString()}',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: textSize,
                                          color: textColor,
                                          fontWeight: textWeight),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Routemaster.of(context).push('/homescreen/analysis/addExpense');
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(deviceWidth*0.015)),
                    minimumSize: Size(deviceWidth*0.25, deviceHeight*0.075)
                ),
                child: Row(
                  children: [
                    Icon(CupertinoIcons.plus_circle,color: Pallete.primaryColor),
                    Text("Add Expense"),
                  ],
                )
            ),
          ],
        )
      ],
    );
  }
}