// /Mobile

import 'package:flutter/material.dart';
import 'package:inventory_management_shop/features/Customers/screens/mobile/customer_screen_mobile.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/add_store_screen_mobile.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/no_store_screen_mobile.dart';
import 'package:inventory_management_shop/features/addstore/screens/mobile/subscription_screen_mobile.dart';
import 'package:inventory_management_shop/features/auth/screens/mobile/login_screen_mobile.dart';
import 'package:inventory_management_shop/features/auth/screens/mobile/welcome_screen_mobile.dart';
import 'package:inventory_management_shop/features/purchase/screens/mobile/enter_purchaes_screen.dart';
import 'package:inventory_management_shop/features/purchase/screens/mobile/purchaseParty_screen_Mobile.dart';
import 'package:inventory_management_shop/features/purchase/screens/mobile/purchaseReturnMobile.dart';
import 'package:inventory_management_shop/features/sales/screens/mobile/sales_screen_mobile.dart';
import 'package:inventory_management_shop/features/sales/screens/mobile/salesparty_screen_mobile.dart';
import 'package:routemaster/routemaster.dart';
import 'features/auth/screens/mobile/splash_screen.dart';
import 'features/expense/screens/mobile/add_expense_mobile.dart';
import 'features/home/screens/mobile/home_screen_mobile.dart';
import 'features/purchase/screens/mobile/enter_PurchaseReturnMobile.dart';
import 'features/purchase/screens/mobile/purchaseReturnPartyMobile.dart';
import 'features/purchase/screens/mobile/purchase_screen_mobile.dart';
import 'features/sales/screens/mobile/enterSale_return_Mobile.dart';
import 'features/sales/screens/mobile/enterSales_screen_Mobile.dart';
import 'features/sales/screens/mobile/salesReturnPartyMobile.dart';
import 'features/sales/screens/mobile/sales_return_mobile.dart';
import 'features/shopprofile/screens/mobile/shopprofilemobile.dart';
import 'features/supplier/screen/mobile/supplier_screen_mobile.dart';
import 'features/userProfile/screens/mobile/edituserprofilemobile.dart';

final route = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SplashScreenMobile()),
  '/signUp': (_) => const MaterialPage(child: LoginScreenMobile()),
  '/welcome': (_) => const MaterialPage(child: WelcomeScreenMobile()),
  '/store': (_) => const MaterialPage(child: NoStoreScreenMobile()),
  '/store/edit': (_) => const MaterialPage(child: EditUserMobile()),
  '/store/addstore': (_) => const MaterialPage(child: AddstoreMobile()),
  '/store/:planSub': (route) => MaterialPage(
          child: PlansubscriptionMobile(
        sid: route.pathParameters['planSub']!,
      )),
  '/store/addstore/plansubscription/homescreen': (_) =>
      const MaterialPage(child: AddstoreMobile()),
  '/store/homescreen/:sid': (route) => MaterialPage(
          child: BottomNavigationMobile(
        sid: route.pathParameters['sid']!,
      )),
  '/store/homescreen/:sid/Sales/:shop': (route) => MaterialPage(
          child: SalesScreenMobile(
        encode: route.pathParameters['shop']!,
      )),
  '/store/homescreen/:sid/Sales/:shop/details/:salesParty': (route) =>
      MaterialPage(
          child: SalesPartyScreenMobile(
        sales: route.pathParameters['salesParty']!,
      )),
  '/store/homescreen/:sid/Sales/:shop/:shopSale': (route) => MaterialPage(
          child: EnterSalesMobile(
        encode: route.pathParameters['shopSale']!,
      )),
  '/store/homescreen/:sid/Purchase/:shop/:shopPurch': (route) => MaterialPage(
          child: EnterPurchaseScreenMobile(
        encode: route.pathParameters['shopPurch']!,
      )),
  '/store/homescreen/:sid/Supplier/:shop': (route) => MaterialPage(
          child: SupplireScreenMobile(
        encode: route.pathParameters['shop']!,
      )),
  '/store/homescreen/:sid/Customer/:shop': (route) => MaterialPage(
          child: CustomerScreenMobile(
        encode: route.pathParameters['shop']!,
      )),

  '/store/homescreen/:sid/Purchase/:shop': (route) => MaterialPage(
          child: PurchaseScreenMobile(
        encode: route.pathParameters['shop']!,
      )),
  '/store/homescreen/:sid/Purchase/:shop/details/:shopPurch': (route) =>
      MaterialPage(
          child: PurchasePartyScreenMobile(
        encode: route.pathParameters['shopPurch']!,
      )),
//salesreturn features
  '/store/homescreen/:sid/SalesReturn/:shop': (route) => MaterialPage(
          child: SalesReturnMobile(
        encode: route.pathParameters['shop']!,
        name: '',
      )),

  '/store/homescreen/:sid/SalesReturn/:shop/srp/:srParty': (route) =>
      MaterialPage(
          child: SalesReturnPartyScreenMobile(
        encode: route.pathParameters['srParty']!,
      )),

  '/store/homescreen/:sid/SalesReturn/:shop/:addSaleReturn': (route) =>
      MaterialPage(
          child: AddSaleReturnMobile(
        encode: route.pathParameters['addSaleReturn']!,
      )),

  //purchase return
  '/store/homescreen/:sid/PurchaseReturn/:shop': (route) => MaterialPage(
          child: PurchaseReturnScreenMobile(
        encode: route.pathParameters['shop']!,
      )),
  '/store/homescreen/:sid/PurchaseReturn/:shop/:addPurchaseReturn': (route) =>
      MaterialPage(
          child: AddPurchaseReturnMobile(
        encode: route.pathParameters['addPurchaseReturn']!,
      )),

  '/store/homescreen/:sid/PurchaseReturn/:shop/prp/:prParty': (route) =>
      MaterialPage(
          child: PurchaseReturnPartyMobile(
        encode: route.pathParameters['prParty']!,
      )),

  //analys add analyse
  '/analyse/addExpense': (_) => const MaterialPage(child: AddExpenseMobile()),
  '/store/homescreen/:sid/editShop': (route) => MaterialPage(
          child: ShopProfileEditMobile(
        sid: route.pathParameters['sid']!,
      )),

  // '/storelistscreen': (_) => MaterialPage(child: StoreListScreenMobile(data: [],)),
  // '/addstore/plansubscription': (route) =>  MaterialPage(child: SubscriptionScreenMobile()),
  // '/mod-tools/:name':(routeData) =>  MaterialPage(child: ModToolsScreen(name: routeData.pathParameters['name']!,)),
  // '/edit-community/:name':(routeData) =>  MaterialPage(child: EditCommunityScreen(name: routeData.pathParameters['name']!,)),
});
