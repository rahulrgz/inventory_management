import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_management_shop/core/commons/loader.dart';
import 'package:inventory_management_shop/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
import '../../../../core/global_variables/global_variables.dart';
import '../../../../core/theme/pallete.dart';
import '../../../../models/shope_model.dart';
import '../../../addstore/controller/addStore_controller.dart';
import '../../../expense/screens/tab/expense_screen_tab.dart';
import '../../../report/screens/tab/report_screen_tab.dart';
import '../../../shopprofile/screens/tab/profile_screen_tab.dart';
import '../../../stocks/screens/tab/stock_screentab.dart';
import 'home_screen_tab.dart';

class SideBarTab extends ConsumerStatefulWidget {
  final String sid;
  const SideBarTab({super.key, required this.sid});

  @override
  ConsumerState<SideBarTab> createState() => _SideBarTabState();
}

class _SideBarTabState extends ConsumerState<SideBarTab> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();
  Future<void> getuser(WidgetRef ref, String uid, String sid) async {
    ShopModel getshop = await ref
        .read(addStoreControllerProvider.notifier)
        .getCurrentShop(sid, uid)
        .first;
    shope = getshop;
    setState(() {});
  }

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  ShopModel? shope;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (shope == null) {
      getuser(ref, user!.uid, widget.sid);
    }
    return shope == null
        ? const Loader()
        : SafeArea(
            child: Scaffold(
              body: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SideMenu(
                      controller: sideMenu,
                      style: SideMenuStyle(
                        // showTooltip: false,
                        displayMode: SideMenuDisplayMode.open,
                        hoverColor: Pallete.secondaryColor,
                        selectedHoverColor: Pallete.secondaryColor,
                        selectedColor: Pallete.secondaryColor,
                        selectedTitleTextStyle:
                            const TextStyle(color: Pallete.primaryColor),
                        selectedIconColor: Pallete.primaryColor,
                      ),
                      title: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Routemaster.of(context)
                                  .push('/store/userprofile');
                            },
                            child: SizedBox(
                              height: deviceHeight * 0.12,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: deviceHeight * 0.02,
                                  ),
                                  shope!.shopProfile.isEmpty
                                      ? CircleAvatar(
                                          radius: deviceHeight * 0.04,
                                          backgroundImage: const AssetImage(
                                              'assets/images/defaultStoreImage-web.png'),
                                          backgroundColor: Colors.white,
                                        )
                                      : CircleAvatar(
                                          radius: deviceHeight * 0.04,
                                          backgroundImage:
                                              NetworkImage(shope!.shopProfile),
                                        ),
                                  SizedBox(
                                    width: deviceHeight * 0.01,
                                  ),
                                  SizedBox(
                                    height: deviceHeight * 0.065,
                                    // color: Colors.red,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Welcome,',
                                          style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontSize: deviceHeight * 0.02),
                                        ),
                                        Text(
                                          shope!.name,
                                          style: TextStyle(
                                              color: Pallete.secondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: deviceHeight * 0.028),
                                        ),
                                        SizedBox(
                                          width: deviceHeight * 0.01,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      footer: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Powered By",
                            style: GoogleFonts.dancingScript(
                              textStyle: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: deviceWidth * 0.015),
                            ),
                          ),
                          Text(
                            "First logic meta lab",
                            style: GoogleFonts.barlowCondensed(
                              textStyle: TextStyle(
                                  color: Pallete.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: deviceWidth * 0.02),
                            ),
                          ),
                          SizedBox(
                            height: deviceHeight * 0.05,
                          ),
                        ],
                      ),
                      items: [
                        SideMenuItem(
                          title: 'Dashboard',
                          onTap: (index, _) {
                            sideMenu.changePage(index);
                          },
                          icon: const Icon(Icons.home),
                        ),
                        SideMenuItem(
                          title: 'Reports',
                          onTap: (index, _) {
                            sideMenu.changePage(index);
                          },
                          icon: const Icon(Icons.edit_note_rounded),
                        ),
                        SideMenuItem(
                          title: 'Stock',
                          onTap: (index, _) {
                            sideMenu.changePage(index);
                          },
                          icon: const Icon(Icons.analytics_outlined),
                        ),
                        SideMenuItem(
                          title: 'Expense',
                          onTap: (index, _) {
                            sideMenu.changePage(index);
                          },
                          icon:
                              const Icon(Icons.account_balance_wallet_outlined),
                        ),
                        SideMenuItem(
                          title: 'Profile',
                          onTap: (index, _) {
                            sideMenu.changePage(index);
                          },
                          icon: const Icon(Icons.person_2_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      children: [
                        HomeScreenTab(shop: shope!),
                        ReportScreenTab(shop: shope!),
                        StockScreenTab(shop: shope!),
                        ExpenseScreenTab(shop: shope!),
                        ShopProfileScreenTab(shop: shope!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
