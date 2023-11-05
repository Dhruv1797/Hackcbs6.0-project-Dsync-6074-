import 'package:flutter/material.dart';
import 'package:moveasyuserapp/busmapscreen.dart';
import 'package:moveasyuserapp/widgets/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SearchPage extends StatefulWidget {
  final double userlat;
  final double userlong;

  const SearchPage({super.key, required this.userlat, required this.userlong});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 60, left: 15.0, right: 8.0),
          child: Container(
            height: 70,
            width: 360,
            child: TextField(
              autofocus: true,
              // onTap: () {
              //   nextScreen(context, SearchPage());
              // },
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  prefixIconColor: Colors.black,
                  prefixIcon: Icon(Icons.search),
                  // ImageIcon(AssetImage("assets/searchicon.png"), size: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(27.0),
                  ),
                  filled: true,
                  hintStyle: TextStyle(
                      color: Colors.black54,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                  hintText: "Search Destination Here",
                  fillColor: Colors.white),
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: deviceheight * 0.77,
              // color: Colors.red,
              child: ListView(
                children: [
                  CityCard(
                    cityname: "Ghaziabad",
                    ontap: () {
                      // nextScreen(
                      //     context,
                      //     BusMapScreen(
                      // userlat: widget.userlat,
                      // userlong: widget.userlong,

                      //     ));

                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: BusMapScreen(
                          userlat: widget.userlat,
                          userlong: widget.userlong,
                        ),
                        withNavBar: true, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                  CityCard(
                    cityname: "Muradnagar",
                    ontap: () {},
                  ),
                  // CityCard(
                  //   cityname: "Ghaziabad",
                  //   ontap: () {},
                  // ),
                  CityCard(
                    cityname: "NH-24",
                    ontap: () {},
                  ),
                  // CityCard(
                  //   cityname: "Ghaziabad",
                  //   ontap: () {},
                  // ),

                  // CityCard(),
                  // CityCard(),
                  // CityCard(),
                  // CityCard(),
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }
}

class CityCard extends StatelessWidget {
  final String cityname;
  final VoidCallback ontap;
  const CityCard({
    super.key,
    required this.cityname,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // boxShadow: [
            //   new BoxShadow(
            //     color: Colors.black,
            //     blurRadius: 3.0,
            //   ),
            // ],
            // borderRadius: BorderRadius.circular(20.0),
          ),
          height: 40,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.location_on),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cityname,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
