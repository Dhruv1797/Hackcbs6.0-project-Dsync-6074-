import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moveasyuserapp/activityscreen.dart';
import 'package:moveasyuserapp/dashboardscreen.dart';
import 'package:moveasyuserapp/flutter_flow/index.dart';
import 'package:moveasyuserapp/news/utils/tabbar.dart';
import 'package:moveasyuserapp/userlocation.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:moveasyuserapp/main.dart';

// import 'package:sapp/Pages/notificationscreen.dart';

// import 'package:sapp/Pages/studentscreen.dart';

class BottomNavigationwidget extends StatefulWidget {
  const BottomNavigationwidget({super.key});

  @override
  State<BottomNavigationwidget> createState() => _BottomNavigationwidgetState();
}

class _BottomNavigationwidgetState extends State<BottomNavigationwidget> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

//Screens for each nav items.
  List<Widget> _NavScreens() {
    return [
      DashboardScreen(),
      ActivityScreen(),
      // MyApp(),
      // MyApp(),

      Userlocationscreen(),
      // TabBaar(),
      Profile1Widget()
      // MyApp(),

      // MyApp(),
      // NOtificationScreen(),
      // Page3(),
      // Page4(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/images/home.png")),
        // title: ("Home"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/images/activity.png")),
        // title: ("Home"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.white,
      ),
      // PersistentBottomNavBarItem(
      //   icon: ImageIcon(AssetImage("assets/images/female.png")),
      //   // title: ("OFFERS"),
      //   activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
      //   inactiveColorPrimary: Colors.black,
      // ),
      // PersistentBottomNavBarItem(
      //   icon: ImageIcon(AssetImage("assets/images/female.png")),
      //   // title: ("OFFERS"),
      //   activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
      //   inactiveColorPrimary: Colors.black,
      // ),
      PersistentBottomNavBarItem(
        // title: "Home",

        icon: ImageIcon(AssetImage("assets/images/pin.png")),
        // title: ("Help"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage("assets/images/user.png")),
        // title: ("ProfileScreen"),
        activeColorPrimary: Color.fromRGBO(255, 255, 255, 1),
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        navBarHeight: 55,
        context,
        controller: _controller,
        screens: _NavScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.black,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style14,
      ),
    );
  }
}
