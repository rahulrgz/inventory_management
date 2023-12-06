import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:inventory_management_shop/features/home/screens/mobile/shop_home_screen_mobile.dart';
import 'package:inventory_management_shop/models/shope_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../addstore/controller/addStore_controller.dart';
import '../../../profile/screens/shopScreenMobile.dart';
import '../../../report/screens/mobile/report_screen_mobile.dart';
import '../../../stocks/screens/mobile/addStockMobile.dart';

class BottomNavigationMobile extends ConsumerStatefulWidget {
  final String sid;
  const BottomNavigationMobile({super.key, required this.sid});

  @override
  _BottomNavigationMobileState createState() => _BottomNavigationMobileState();
}

class _BottomNavigationMobileState extends ConsumerState<BottomNavigationMobile>
    with TickerProviderStateMixin {
  ShopModel? shop;

  int _selectedIndex = 0;

  bNavItems(int index, ShopModel shop) {
    final List<Widget> widgetOptions = <Widget>[
      ShopHomeMobile(shop: shop),
      ReportScreenMobile(shop: shop),
      stockMobile(shop: shop),
      ShopProfileMobile(shop: shop),
    ];
    return widgetOptions[index];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getCurrentShop(WidgetRef ref, String sid, String uid) async {
    shop = await ref
        .read(addStoreControllerProvider.notifier)
        .getCurrentShop(sid, uid)
        .first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context1) {
    final user = ref.read(userProvider);
    if (shop == null) {
      getCurrentShop(ref, widget.sid, user!.uid);
    }
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text('do yo want to exit '),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Routemaster.of(context).pop(false);
                        Navigator.of(context).pop(false);
                      },
                      child: Text('cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Routemaster.of(context).pop(true);
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ok'))
                ],
              );
            });
        return value ?? false;
      },
      child: Scaffold(
        extendBody: true,
        body: shop == null
            ? const Center(child: Loader())
            : bNavItems(_selectedIndex, shop!),
        bottomNavigationBar: DotNavigationBar(
          marginR: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.1, vertical: deviceHeight * 0.005),
          borderRadius: deviceWidth * 0.05,
          backgroundColor: Pallete.secondaryColor,
          currentIndex: _selectedIndex,
          dotIndicatorColor: Pallete.primaryColor,
          unselectedItemColor: Colors.grey[400],
          // splashBorderRadius: 50,
          onTap: _onItemTapped,
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: deviceWidth * 0.06,
              ),
              selectedColor: Pallete.primaryColor,
            ),

            /// Likes
            DotNavigationBarItem(
              icon: Icon(
                Icons.description,
                size: deviceWidth * 0.06,
              ),
              selectedColor: Pallete.primaryColor,
            ),

            /// Search
            DotNavigationBarItem(
              icon: Icon(
                Icons.insert_chart,
                size: deviceWidth * 0.06,
              ),
              selectedColor: Pallete.primaryColor,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: deviceWidth * 0.06,
              ),
              selectedColor: Pallete.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
