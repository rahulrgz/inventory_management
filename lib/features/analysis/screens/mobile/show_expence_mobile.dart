import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';

class ShowExpenceMobile extends StatefulWidget {
  final String encode;
  const ShowExpenceMobile({super.key, required this.encode});

  @override
  State<ShowExpenceMobile> createState() => _ShowExpenceMobileState();
}

class _ShowExpenceMobileState extends State<ShowExpenceMobile> {
  DateTime? _selectedfromDate;
  DateTime? _selectedtoDate;

  ///Date picker from
  void _pickDateDialogfrom() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedfromDate = pickedDate;
      });
    });
  }

  ///date picker to
  void _pickDateDialogto() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedtoDate = pickedDate;
      });
    });
  }

  decode() {
    Map<String, dynamic> map = jsonDecode(Uri.decodeComponent(widget.encode));
    ShopModel shop = ShopModel(
        uid: map['uid'],
        category: map['category'],
        name: map['name'],
        shopId: map['shopId'],
        subscriptionId: map['subscriptionId'],
        createdTime: DateTime.parse(map['createdTime']),
        shopProfile: map['shopProfile'],
        deleted: map['deleted'],
        setSearch: List<String>.from(map['setSearch']),
        accepted: map['accepted'],
        blocked: map['blocked'],
        reason: map['reason'],
        expirationDate: DateTime.now());
    return shop;
  }

  pushEncode(String uid, String sid, BuildContext context) {
    Map<String, dynamic> map = {'sid': sid, 'uid': uid};
    String idEncode = jsonEncode(map);
    Routemaster.of(context).push(
        '/store/homescreen/$sid/Purchase/${widget.encode}/${Uri.encodeComponent(idEncode)}');
  }

  @override
  Widget build(BuildContext context) {
    ShopModel shop = decode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Routemaster.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.left_chevron),
          color: Pallete.secondaryColor,
        ),
        title: const Text(
          // shop.name,
          'shope name',
          style: TextStyle(
            color: Pallete.secondaryColor,
            // fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.insert_page_break_outlined,
                color: Pallete.secondaryColor,
              ))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: deviceHeight * 0.01,
          ),
          SizedBox(
            width: deviceWidth,
            height: deviceHeight * 0.1,
            child: Padding(
              padding: EdgeInsets.only(left: deviceWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: deviceWidth * 0.35,
                      height: deviceHeight * 0.07,
                      color: Pallete.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Date From :"),
                          SizedBox(
                            height: deviceHeight * 0.0015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(_selectedfromDate == null
                                  ? 'Choose Date'
                                  : '${DateFormat.yMMMd().format(_selectedfromDate!)}'),
                              InkWell(
                                  onTap: () {
                                    _pickDateDialogfrom();
                                  },
                                  child: const Icon(Icons.keyboard_arrow_down))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: deviceWidth * 0.35,
                      height: deviceHeight * 0.06,
                      color: Pallete.primaryColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Date to :"),
                          SizedBox(
                            height: deviceHeight * 0.0015,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(_selectedtoDate == null
                                  ? 'Choose Date'
                                  : DateFormat.yMMMd()
                                      .format(_selectedtoDate!)),
                              InkWell(
                                  onTap: () {
                                    _pickDateDialogto();
                                  },
                                  child: const Icon(Icons.keyboard_arrow_down))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list_outlined)),
                ],
              ),
            ),
          ),
          // Container(height:deviceHeight*0.6712,child: AllPurchaseScreenMobile(shop: shop)),
          Padding(
            padding: EdgeInsets.only(
                left: deviceWidth * 0.05,
                right: deviceWidth * 0.05,
                bottom: deviceHeight * 0.03),
            child: InkWell(
              onTap: () {
                pushEncode(shop.uid, shop.shopId, context);
              },
              child: Container(
                  height: deviceHeight * 0.07,
                  // width: deviceWidth * 0.11,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Pallete.secondaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Icon(
                        Icons.add_circle_outline_sharp,
                        color: Pallete.primaryColor,
                        size: deviceWidth * 0.04,
                      )),
                      SizedBox(width: deviceWidth * 0.01),
                      Text(
                        'Add Purchase ',
                        style: TextStyle(
                            fontSize: deviceWidth * 0.04,
                            color: Pallete.primaryColor),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
