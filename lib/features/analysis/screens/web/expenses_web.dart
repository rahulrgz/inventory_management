import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/features/analysis/screens/web/shop_analysis_screen_web.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/commons/alert_dialog_boxes_web.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';

///for table style
class StyledTableCell extends StatelessWidget {
  final String? text;
  final Color textColor;
  StyledTableCell({
    this.text,
    this.textColor = Pallete.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent, // Set the cell background color
          border: Border.all(
            color: Colors.transparent, // Set the cell border color to red
            width: deviceWidth * 0.001,
          ),
          borderRadius:
          BorderRadius.circular(8.0), // Make the cell border rounded
        ),
        child: Text(
          text!,
          style: TextStyle(
            color: textColor, // Set the text color to yellow
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// List<bool> _isSelected = [true, false];

class Expence_web extends StatefulWidget {
  const Expence_web({super.key});

  @override
  State<Expence_web> createState() => _Expence_webState();
}

class _Expence_webState extends State<Expence_web> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: deviceHeight * 0.03),
              child: Row(children: [
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
                  " Expense ",
                  style: TextStyle(
                      color: Pallete.secondaryColor,
                      fontSize: deviceWidth * .02,
                      fontWeight: FontWeight.bold),
                ),
              ]),
            ),
            SizedBox(height: deviceHeight * 0.08),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.06),
              child: Container(
                // color: Colors.red,
                height: deviceHeight * 1,
                width: deviceWidth * 0.8,
                child: Column(
                    children: [
                  Container(
                    height: deviceHeight*0.12,
                    width: deviceWidth * 0.8,
                    // color: Colors.yellow,
                    child: Row(
                      children: [
                        SizedBox(width: deviceWidth*0.06),
                        Container(
                          height: deviceHeight * 0.07,
                          width: deviceWidth * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Pallete.secondaryColor,
                              width: deviceWidth*0.001,
                            ),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(16.0),
                              border: InputBorder.none,
                              labelText: 'Expense Category',
                              labelStyle: TextStyle(color: Pallete.secondaryColor)
                            ),
                            style: TextStyle(
                              color:Pallete.secondaryColor, // Text color
                            ),
                          ),
                        ),
                        SizedBox(width: deviceWidth*0.12),
                        Container(
                            height: deviceHeight * 0.07,
                            width: deviceWidth * 0.1,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0), // Set border radius
                  border: Border.all(
                    color: Pallete.secondaryColor,
                    width: deviceWidth*0.001,
                  ),
                ),
                          child: Row(
                            children: [
                              SizedBox(width: deviceWidth*0.01,),
                              Text('Expense No.'),
                              Expanded(child: Text('200')),
                            ],
                          ),
                        ),
                        SizedBox(width: deviceWidth*0.02),
                        Container(
                            height: deviceHeight * 0.07,
                            width: deviceWidth * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Pallete.secondaryColor,
                                width: deviceWidth*0.001,
                              ),
                            ),
                          child:  Row(
                            children: [
                              SizedBox(width: deviceWidth*0.01,),
                              Text('Date :'),
                              Text('20/09/2002'),
                              Expanded(child: Icon(Icons.arrow_drop_down))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: deviceHeight * 0.001),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: deviceWidth * 0.06, top: deviceHeight * 0.05),
                        child: Text('Billed Items',
                            style: TextStyle(
                                color: Pallete.secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: deviceWidth * 0.01)),
                      ),
                    ],
                  ),
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.06, right: deviceWidth * 0.09),
                      child: Table(
                        border: TableBorder.all(
                          color: Pallete
                              .secondaryColor, // Set the table border color to red
                          width: deviceWidth * 0.001,
                          style: BorderStyle.solid,
                          borderRadius: BorderRadius.circular(
                              8.0), // Make the border rounded
                        ),
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              StyledTableCell(
                                text: 'Item Name',
                                textColor: textColor,
                              ),
                              StyledTableCell(
                                  text: 'Qty', textColor: textColor),
                              StyledTableCell(
                                  text: 'Price', textColor: textColor),
                              StyledTableCell(
                                  text: 'Amount', textColor: textColor),
                              StyledTableCell(
                                  text: 'Delete', textColor: textColor),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              StyledTableCell(
                                  text: 'salman', textColor: textColor),
                              StyledTableCell(text: '2', textColor: textColor),
                              StyledTableCell(
                                  text: '250', textColor: textColor),
                              StyledTableCell(
                                  text: '200', textColor: textColor),
                              StyledTableCell(
                                  text: 'Delete', textColor: Colors.red),
                            ],
                          ),
                          // Add more rows with 4 cells as needed
                        ],
                      ),
                    ),
                  ]),
                  SizedBox(height: deviceHeight * 0.02),
                  InkWell(
                    onTap: () {
                      // addItemBox(context);
                    },
                    child: Container(
                        height: deviceHeight * 0.07,
                        width: deviceWidth * 0.20,
                        decoration: BoxDecoration(
                          color: Pallete.containerColor,
                          border: Border.all(
                            color: Pallete.secondaryColor, // Border color
                            width: deviceWidth * 0.001,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Icon(
                                  Icons.add_circle_outline_sharp,
                                  color: Pallete.secondaryColor,
                                  size: deviceWidth * 0.011,
                                )),
                            SizedBox(width: deviceWidth * 0.001),
                            Text(
                              'Add Item',
                              style: TextStyle(
                                  fontSize: deviceWidth * 0.011,
                                  color: Pallete.secondaryColor),
                            )
                          ],
                        )),
                  ),
                  SizedBox(height: deviceHeight * 0.03),
                  Column(
                    children: [
                      SizedBox(height: deviceHeight * 0.01),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: deviceWidth * 0.08,
                                  right: deviceWidth * .1),
                              child: Container(
                                color: Pallete.containerColor,
                                height: deviceHeight * 0.07,
                                width: deviceWidth * 0.8,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: deviceHeight * 0.02),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.02),
                                            child: Text('Total Amount',
                                                style: TextStyle(
                                                    color:
                                                    Pallete.secondaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                    deviceWidth * 0.013)),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: deviceWidth * 0.02),
                                            child: Text('\u{20B9} ${25423}',
                                                style: TextStyle(
                                                    color:
                                                    Pallete.secondaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                    deviceWidth * 0.013)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: deviceWidth * 0.09),
                            child: Text('Payment Type :',
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          // Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: deviceWidth * 0.002),
                            child: Text('Cash',
                                style: TextStyle(
                                    color: Pallete.secondaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Container(
                            height: deviceHeight * 0.2,
                            width: deviceWidth * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Pallete.secondaryColor,
                                width: deviceWidth*0.001,
                              ),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(16.0),
                                  border: InputBorder.none,
                                  labelText: 'Description',
                                  labelStyle: TextStyle(color: Pallete.secondaryColor,
                                  fontSize: deviceWidth*0.012)
                              ),
                              style: TextStyle(
                                color:Pallete.secondaryColor, // Text color
                              ),
                            ),
                          ),
                          SizedBox(width: deviceWidth*0.05),
                          Container(
                            height: deviceHeight * 0.2,
                            width: deviceWidth * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Pallete.secondaryColor,
                                width: deviceWidth*0.001,
                              ),
                            ),
                            child: Icon(Icons.image_outlined,
                            color: Pallete.containerColor,
                            size: deviceWidth*0.04,)
                          ),
                        ],
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                  Container(
                      height: deviceHeight * 0.07,
                      width: deviceWidth * 0.20,
                      decoration: BoxDecoration(
                        color: Pallete.secondaryColor,
                        border: Border.all(
                          color: Pallete.primaryColor, // Border color
                          width: deviceWidth * 0.001,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save',
                            style: TextStyle(
                                fontSize: deviceWidth * 0.011,
                                color: Pallete.primaryColor),
                          )
                        ],
                      )),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
