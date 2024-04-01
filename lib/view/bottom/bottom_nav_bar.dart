import 'package:wingo/generated/assets.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:wingo/utils/utils.dart';
import 'package:wingo/view/account/account_screen.dart';
import 'package:wingo/view/home/home_screen.dart';
import 'package:wingo/view/promotion/promotion_screen.dart';
import 'package:wingo/view/wallet/recharge_screen.dart';
import 'package:wingo/view/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widget/bottom_widget.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, this.initialIndex = 0});
  // const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _lastSelected = 0;

  final List<Widget> _tabs = [
    const HomeScreen(),
    // const ActivityScreen(),
    const PromotionScreen(),
    const RechargeScreen(),
    // const WalletScreen(),
    const AccountScreen(),
  ];

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = index;
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        setState(() {
          _lastSelected = args;
        });
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_lastSelected > 0) {
      setState(() {
        _lastSelected = 0;
      });
      return false;
    } else {
      return await Utils.showExitConfirmation(context) ??
          false; // Return false if the dialog is dismissed
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _tabs[_lastSelected],
        bottomNavigationBar: FabBottomNavBar(
          color: Colors.black,
          selectedColor: Colors.red,
          notchedShape: const CircularNotchedRectangle(),
          onTabSelected: _selectedTab,
          backgroundColor: Colors.white,
          items: [
            FabBottomNavBarItem(
                imageData: _lastSelected == 0
                    ? Assets.iconsHomeColor
                    : Assets.iconsHome,
                text: 'Home'),
            // FabBottomNavBarItem(
            //   imageData: _lastSelected == 1 ? Assets.iconsActivityColor : Assets.iconsActivity,
            //   text: 'Invite',
            // ),
            FabBottomNavBarItem(
              imageData: _lastSelected == 1
                  ?Assets.iconsIconperson
                  : Assets.iconsIconpersoncolor,
              text: 'Invite',
            ),

            FabBottomNavBarItem(
              imageData: _lastSelected == 2
                  ? Assets.iconsWalletColor
                  : Assets.iconsWallet,
              text: 'Recharge',
            ),
            FabBottomNavBarItem(
              imageData: _lastSelected == 3
                  ? Assets.iconsAccountColor
                  : Assets.iconsAccount,
              text: 'My',
            ),
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   shape: const StadiumBorder(),
        //   onPressed: () {
        //       setState(() {
        //         _selectedTab(2);
        //         selectedIndex=2;
        //       });
        //   },
        //   elevation: 0,
        //   // child: Image.asset(Assets.iconsPromotion,fit: BoxFit.cover,height: 100)
        // ),
      ),
    );
  }
}

class FeedbackProvider {
  static void navigateTohome(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.bottomNavBar, arguments: 0);
  }

  // static void navigateToActivity(BuildContext context) {
  //   Navigator.pushNamed(context, RoutesName.bottomNavBar,arguments: 1);
  // }

  static void navigateToPromotion(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.bottomNavBar, arguments: 1);
  }

  static void navigateToWallet(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.bottomNavBar, arguments: 2);
  }

  static void navigateToAccount(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.bottomNavBar, arguments: 3);
  }
}
