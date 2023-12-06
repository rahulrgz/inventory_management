import 'package:flutter/material.dart';
import 'package:inventory_management_shop/core/global_variables/global_variables.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/widgets/single_store_tile.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../models/shope_model.dart';

class StoreListScreenMobile extends StatelessWidget {
  List<ShopModel> data;
  StoreListScreenMobile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Your Stores",
          style: TextStyle(
              fontSize: deviceHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: Pallete.secondaryColor),
        ),
        SizedBox(
          height: deviceHeight * 0.01,
        ),
        Padding(
          padding: EdgeInsets.only(
              left: deviceWidth * 0.03, right: deviceWidth * 0.03),
          child: SizedBox(
            height: deviceHeight * 0.6,
            width: deviceWidth,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var shop = data[index];
                return Padding(
                  padding: EdgeInsets.all(deviceWidth * 0.02),
                  child: SingleStoreTile(shop: shop),
                );
              },
            ),
          ),
        ),
        SizedBox(
          height: deviceHeight * 0.065,
          width: deviceWidth * 0.8,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(deviceWidth * 0.03)))),
              onPressed: () {
                Routemaster.of(context).push('/store/addstore');
              },
              child: Text('ADD STORE')),
        ),
      ],
    );
  }
}
