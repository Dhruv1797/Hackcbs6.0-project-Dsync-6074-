import 'package:flutter/material.dart';

import '../all/view/Newspage.dart';
import '../buisness/view/bnewsPage.dart';
import '../contry/view/cnewspage.dart';
import '../health/view/hnewspage.dart';

class TabBaar extends StatefulWidget {
  const TabBaar({Key? key}) : super(key: key);

  @override
  State<TabBaar> createState() => _TabBaarState();
}

class _TabBaarState extends State<TabBaar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("NEWSPAPER"),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: "TOP NEWS",
                ),
                Tab(
                  text: "COUNTRY",
                ),
                Tab(
                  text: "HEALTH",
                ),
                Tab(
                  text: "BUSINESS",
                ),
              ],
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                color: Color(0xff5e6164),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Likes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_border_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Bookmarks",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              )
            ],
          ),
          backgroundColor: Color(0xff2b2b2c),
          body: TabBarView(
            children: [
              Home_Page(),
              CountryPage(),
              HealthPage(),
              BusinessPage(),
            ],
          ),
        ),
      ),
    );
  }
}
