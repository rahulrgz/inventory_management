import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';


class Shop_Home_screen_web extends StatefulWidget {
  final String shopId;
  final ShopModel shopeModel;
   const Shop_Home_screen_web({super.key,required this.shopeModel, required this.shopId,});
  @override
  State<Shop_Home_screen_web> createState() => _Shop_Home_screen_webState();
}

class _Shop_Home_screen_webState extends State<Shop_Home_screen_web> {

  // var purchasereturnicon=Transform.rotate(
  // angle: -45 * 3.141592653589793 / 180,
  // child: Icon(CupertinoIcons.cart),
  // );

  // List griedView=[
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Sales',
  //     'description':'To access sales section,\n and you can view or update \n sales reports',
  //   },
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Purchase',
  //     'description':'To access sales section,\n and you can view or update \n purchase reports',
  //   },
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Sales  Return',
  //     'description':'To access sales section,\n and you can view or update \n sales return reports',
  //   },
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Purchase  Return',
  //     'description':'To access sales section,\n and you can view or update \n purchase return reports',
  //   },
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Debet',
  //     'description':'To access sales section,\n and you can view or update \n debet reports',
  //   },
  //   {
  //     'icons':CupertinoIcons.cart,
  //     'categery':'Bad Debet',
  //     'description':'To access sales section,\n and you can view or update \n bad debet reports',
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(deviceWidth*0.015),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///listview
            // Container(
            //   height: deviceHeight * 0.2,
            //   // width: deviceWidth * 0.8,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 10,
            //     itemBuilder: (BuildContext context, int index) {
            //       return SingleChildScrollView(
            //         child: Padding(
            //           padding: const EdgeInsets.only(right: 20),
            //
            //           child: Container(
            //             height: deviceHeight * 0.4,
            //             width: deviceWidth * 0.3,
            //             decoration: BoxDecoration(
            //               color: Pallete.secondaryColor,
            //               borderRadius: BorderRadius.circular(50),
            //             ),
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   padding:  EdgeInsets.only(right:deviceWidth*0.02,top: deviceHeight*0.02),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.end,
            //                     children: [
            //                       Icon(Icons.calendar_month_outlined,color: Pallete.primaryColor)
            //                   ,   Text('20/90/2002',style: TextStyle(color: Pallete.primaryColor),)],),
            //                 ),
            //                 Expanded(
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     children: [
            //                     Icon(
            //                         CupertinoIcons.cart,
            //                         color: Colors.grey.withOpacity(0.5)
            //                         ,size: deviceWidth*0.077),
            //                       SizedBox(width: deviceWidth*0.01),
            //                     Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: [
            //                       Text('Today Sales',
            //                           style: TextStyle(
            //                               color: Pallete.primaryColor,
            //                               fontSize: deviceWidth*0.020,
            //                               fontWeight: FontWeight.bold)),
            //                       Text('\u{20B9}${'10,000'}',
            //                           style: TextStyle(
            //                               color: Pallete.primaryColor,
            //                               fontSize: deviceWidth*0.018)),
            //                     ],)
            //                   ],),
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            // ),
            SizedBox(height: deviceHeight*0.02,),
            // Container(
            //   height: deviceHeight*0.7,
            //   width: deviceWidth*0.8,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            Container(
              height: deviceHeight*0.9,
              width: deviceWidth*0.8,
              child: GridView(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 250,
                      maxCrossAxisExtent: 500,
                      childAspectRatio: 3/2,
                      crossAxisSpacing: 50,
                      mainAxisSpacing: 50),
                  children: [
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/sales'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.001,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(),
                                        Icon(
                                            CupertinoIcons.cart_badge_plus,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Sales',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Sales section,You can view or manage your sales here,',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/purchases'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.001,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(),
                                        Icon(
                                            CupertinoIcons.bag_badge_plus,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Purchase',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Purchase section,You can view or manage your purchases here,',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/salesReturn'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.015,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                            CupertinoIcons.cart_badge_minus,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Sales Return',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Sales Return section,You can view or manage your sales return here',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/purchasesReturn'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.001,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(),
                                        Icon(
                                            CupertinoIcons.bag_badge_minus,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Purchase Return',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Sales section,You can view or manage your purchase return here,',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/customers'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.001,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(),
                                        Icon(
                                            CupertinoIcons.group,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Customers',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Customers section,You can view or manage your customers here,',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()=>Routemaster.of(context).push('/store/homescreen/${widget.shopId}/suppliers'),
                      child: Container(
                        height: deviceHeight*0.3,
                        width: deviceWidth*0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Pallete.containerColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(
                                  right:deviceWidth*0.02,
                                  top: deviceHeight*0.02),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.ellipsis,
                                    color:Pallete.secondaryColor,
                                    size: deviceWidth*0.03,)
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: deviceWidth*0.02,top: deviceHeight*0.0001),
                                child: Container(
                                  height: deviceHeight*0.001,
                                  width: deviceWidth*0.2,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(),
                                        Icon(
                                            CupertinoIcons.person_2,
                                            color: Pallete.secondaryColor,
                                            size: deviceWidth*0.05),
                                        Text('Suppliers',
                                          style:TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.020,
                                              fontWeight:FontWeight.bold ) ,
                                        ),
                                        Text('To access Suppliers section,You can view or manage your suppliers here,',
                                          style: TextStyle(color: Pallete.secondaryColor,
                                              fontSize: deviceWidth*0.012
                                          ),)
                                      ]),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],

              ),
            ),
            // )
          ],
        ),
      ),
    );
  }
}
//
// Column(
// children: [
// Container(
// height: deviceHeight * 0.2,
// width: deviceWidth * 0.9,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(deviceWidth * 0.07),
// color: Colors.pink[100]),
// child: Column(
// children: [
// // SizedBox(height: deviceHeight*0.02,),
// Padding(
// padding: EdgeInsets.only(
// left: deviceWidth * 0.07,
// right: deviceWidth * 0.07,
// ),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Text('uennn',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.05,
// fontWeight: FontWeight.bold,
// )),
// SizedBox(width: deviceWidth * 0.2),
// Icon(
// Icons.calendar_month,
// color: Pallete.secondaryColor,
// size: deviceWidth * 0.05,
// ),
// Text('uennn',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.05,
// fontWeight: FontWeight.bold)),
// ],
// ),
// ),
//
// Padding(
// padding: EdgeInsets.only(
// left: deviceWidth * 0.07,
// right: deviceWidth * 0.07,
// top: deviceWidth * 0.05),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Padding(
// padding: EdgeInsets.only(right: deviceWidth * 0.2),
// child: Text('uennn',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.035,
// fontWeight: FontWeight.bold,
// )),
// ),
// SizedBox(
// height: deviceHeight * 0.02,
// ),
// Text('kxmks',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.04,
// fontWeight: FontWeight.bold,
// ))
// ],
// ),
// Container(
// width: deviceWidth * 0.001,
// height: deviceHeight * 0.08,
// color: Pallete.secondaryColor,
// ),
// Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Padding(
// padding: EdgeInsets.only(right: deviceWidth * 0.2),
// child: Text('uennn',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.035,
// fontWeight: FontWeight.bold)),
// ),
// SizedBox(
// height: deviceHeight * 0.02,
// ),
// Text('ddddddddddkxmk',
// style: TextStyle(
// color: Pallete.secondaryColor,
// fontSize: deviceWidth * 0.04,
// fontWeight: FontWeight.bold,
// )),
// ],
// )
// ],
// ),
// )
// ],
// ),
// ),
// SizedBox(
// height: deviceHeight * 0.05,
// ),
// Container(
// height: deviceHeight * 0.5,
// width: deviceWidth * 0.9,
// color: Colors.white,
// child: GridView.builder(
// physics: BouncingScrollPhysics(),
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2, // number of items in each row
// mainAxisSpacing: deviceWidth * 0.05, // spacing between rows
// crossAxisSpacing: deviceWidth * 0.05, // spacing between columns
// ),
// padding: EdgeInsets.all(8.0), // padding around the grid
// itemCount: 6, // total number of items
// itemBuilder: (context, index) {
// return Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(deviceWidth * 0.07),
// color: Colors.pink[100],
// ),
// child: Center(
// child: Column(
// children: [
// Icon(Icons.shopping_cart_outlined),
// Text(
// 'hellooo',
// style: TextStyle(fontSize: 18.0, color: Colors.white),
// ),
// ],
// ),
// ),
// );
// },
// ))
// ],
// );