import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveasyuserapp/bookmapscreen.dart';
import 'package:moveasyuserapp/bookticketscreen.dart';

import 'package:moveasyuserapp/drawer.dart';
import 'package:moveasyuserapp/faircalculatorscreen.dart';
import 'package:moveasyuserapp/liveloactionscreen.dart';
import 'package:moveasyuserapp/model/newsmodel.dart';
import 'package:moveasyuserapp/userlocation.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:url_launcher/url_launcher.dart';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int selectedPage;
  late final PageController _pageController;
  double pagedevicewidth = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Timer? _timer;

  List<Gamelist> gameimageurls = [
    Gamelist("assets/images/G20.png"),
    Gamelist("assets/images/adv2.jpeg"),
    Gamelist("assets/images/adv3.png"),
    // Gamelist("assets/2.png"),
    // Gamelist("assets/3.png"),
    // Gamelist("assets/game.png"),
    // Gamelist("assets/game.png"),
  ];

  String finalplacename = "";
  String initialplacename = "";
  double completefareamount = 0.00;

  double? startlat;
  double? startlong;
  double? endlat;
  double? endlong;

  Future<LatLng> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LatLng(location.latitude, location.longitude);
      }
      throw Exception("Location not found for the given address");
    } catch (e) {
      print("Error: $e");
      return LatLng(0, 0);
    }
  }

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    final double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );

    // Convert the distance from meters to kilometers
    final double distanceInKilometers = distanceInMeters / 1000.0;

    return distanceInKilometers;
  }

  News newsdata = News(status: "", totalResults: 0, articles: []);

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    _startAutoScroll();
    super.initState();

    getnewsdata();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    const Duration autoScrollDuration = Duration(seconds: 3);

    _timer = Timer.periodic(autoScrollDuration, (timer) {
      if (selectedPage < gameimageurls.length - 1) {
        selectedPage++;
      } else {
        selectedPage = 0;
      }
      // Animate to the next page
      _pageController.animateToPage(
        selectedPage,
        duration: Duration(milliseconds: 500), // Optional animation duration
        curve: Curves.easeInOut, // Optional animation curve
      );
    });
  }

  void _makePhoneCall() async {
    const phoneNumber =
        'tel:+9821857885'; // Replace with the phone number you want to call
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = gameimageurls.length;
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    pagedevicewidth = devicewidth;
    return Scaffold(
      backgroundColor: Colors.white60,
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: deviceheight - 60,
            width: devicewidth,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 42.h,
                  ),
                  Container(
                    width: devicewidth,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 29,
                        ),
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          child: Container(
                            height: 15.h,
                            width: 30,
                            child: Image.asset("assets/images/iconmenu.png"),
                          ),
                        ),

                        SizedBox(
                          width: 70.w,
                        ),

                        Row(
                          children: [
                            // Container(
                            //   height: 20,
                            //   width: 30,
                            //   child: Image.asset("assets/images/buslogo.png"),
                            // ),
                            Text(
                              "MOVE EASY",
                              style: TextStyle(
                                fontFamily: "Urbanist",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        // PopupMenuButton<String>(
                        //   onSelected: handleClick,
                        //   itemBuilder: (BuildContext context) {
                        //     return {'Option 1', 'Option 2'}.map((String choice) {
                        //       return PopupMenuItem<String>(
                        //         value: choice,
                        //         child: Text(choice),
                        //       );
                        //     }).toList();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: deviceheight * 0.13,
                      width: devicewidth * 0.9,
                      // color: Colors.red,
                      child: PageView.builder(
                        allowImplicitScrolling: true, pageSnapping: true,
                        // dragStartBehavior: DragStartBehavior.start,
                        scrollBehavior: ScrollBehavior(
                            androidOverscrollIndicator:
                                AndroidOverscrollIndicator.glow),

                        controller: _pageController,
                        itemBuilder: buildlistitem,

                        itemCount: gameimageurls.length,
                        onPageChanged: (page) {
                          setState(() {
                            selectedPage = page;
                          });
                        },
                        // children: List.generate(pageCount, (index) {
                        //   return Container(
                        //     child: Center(
                        //       child: Text('Page $index'),
                        //     ),
                        //   );
                        // }),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(24),
                  //   child: PageViewDotIndicator(
                  //     currentItem: selectedPage,
                  //     count: pageCount,
                  //     unselectedColor: Colors.black26,
                  //     selectedColor: Colors.black,
                  //     duration: Duration(milliseconds: 200),
                  //     boxShape: BoxShape.circle,
                  //   ),
                  // ),
                  SizedBox(
                    height: 10.56.h,
                  ),
                  Center(
                    child: Container(
                      height: 240,
                      width: 360,
                      // decoration: BoxDecoration(
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 5,
                      //       blurRadius: 7,
                      //       offset: Offset(0, 3),
                      //     ),
                      //   ],
                      // ),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20.45),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color.fromRGBO(182, 214, 204, 1),
                        //     spreadRadius: 1,
                        //     blurRadius: 1.r,
                        //   ),
                        // ],
                        // border: Border.all(
                        //   width: 1.0, // 1px border width
                        //   color:
                        //       Color.fromRGBO(182, 214, 204, 1), // Border color
                        // ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: BookticketScreen(),
                                              // screen: Userlocationscreen(),
                                              withNavBar:
                                                  false, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 2,
                                                  blurRadius: 6.r,
                                                  offset: Offset(0, 6),
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                              color: Colors
                                                  .white, // Customize the color as needed
                                            ),
                                            child: Image.asset(
                                                "assets/images/ticket1.png"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Book Ticket",
                                          style: TextStyle(
                                            fontFamily: "Urbanist",
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.grey
                                      .shade400, // Customize the divider color
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: FairCalculatorScreen(),
                                              withNavBar:
                                                  false, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 2,
                                                  blurRadius: 6.r,
                                                  offset: Offset(0, 6),
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                              color: Colors
                                                  .white, // Customize the color as needed
                                            ),
                                            child: Image.asset(
                                                "assets/images/ticket2.png"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Fair Calculator",
                                          style: TextStyle(
                                            fontFamily: "Urbanist",
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors
                                .grey.shade400, // Customize the divider color
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            const url =
                                                'https://docs.google.com/forms/d/e/1FAIpQLScOt3Pk2whTk2ahotJUm3lQ5517tDNMDbrzgvE9ZJbuS7DtOg/viewform'; // Replace with your desired URL
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 2,
                                                  blurRadius: 6.r,
                                                  offset: Offset(0, 6),
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                              color: Colors
                                                  .white, // Customize the color as needed
                                            ),
                                            child: Image.asset(
                                                "assets/images/ticket3.png"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Lost & Found",
                                          style: TextStyle(
                                            fontFamily: "Urbanist",
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  color: Colors.grey
                                      .shade400, // Customize the divider color
                                ),
                                Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: LiveLocationScreen(),
                                              withNavBar:
                                                  false, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation:
                                                  PageTransitionAnimation
                                                      .cupertino,
                                            );
                                          },
                                          child: Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 2,
                                                  blurRadius: 6.r,
                                                  offset: Offset(0, 6),
                                                ),
                                              ],
                                              shape: BoxShape.circle,
                                              color: Colors
                                                  .white, // Customize the color as needed
                                            ),
                                            child: Image.asset(
                                                "assets/images/ticket4.png"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Live Location",
                                          style: TextStyle(
                                            fontFamily: "Urbanist",
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 31.h,
                  ),

                  // Container(
                  //   height: 303,
                  //   width: 324,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Color.fromRGBO(182, 214, 204, 1),
                  //         spreadRadius: 2,
                  //         blurRadius: 6.r,
                  //         offset: Offset(0, 6),
                  //       ),
                  //     ],
                  //     border: Border.all(
                  //       color: Colors.black,
                  //       width: 1,
                  //     ),
                  //     borderRadius: BorderRadius.circular(18),
                  //   ),
                  //   child: Center(
                  //     child: Column(
                  //       children: [
                  //         SizedBox(
                  //           height: 30.h,
                  //         ),
                  //         Stack(
                  //           alignment: Alignment.center,
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 GestureDetector(
                  //                   onTap: () {},
                  //                   child: Container(
                  //                     height: 60,
                  //                     width: 240.w,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color.fromRGBO(
                  //                               182, 214, 204, 1),
                  //                           spreadRadius: 2,
                  //                           blurRadius: 6.r,
                  //                           offset: Offset(0, 6),
                  //                         ),
                  //                       ],
                  //                       // border: Border.all(
                  //                       //   color: Colors.black,
                  //                       //   width: 1,
                  //                       // ),
                  //                       borderRadius: BorderRadius.circular(10),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: EdgeInsets.only(left: 8.0),
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         children: [
                  //                           Text(
                  //                             "Depart From",
                  //                             style: TextStyle(
                  //                               fontFamily: "Urbanist",
                  //                               fontSize: 11.sp,
                  //                               fontWeight: FontWeight.w600,
                  //                               color: Colors.grey,
                  //                             ),
                  //                           ),
                  //                           SizedBox(
                  //                             height: 10.h,
                  //                           ),
                  //                           Text(
                  //                             "Select Source",
                  //                             style: TextStyle(
                  //                               fontFamily: "Urbanist",
                  //                               fontSize: 11.sp,
                  //                               fontWeight: FontWeight.w600,
                  //                               color: Colors.black,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 22.48,
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: () {},
                  //                   child: Container(
                  //                     height: 60,
                  //                     width: 240.w,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.white,
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                           color: Color.fromRGBO(
                  //                               182, 214, 204, 1),
                  //                           spreadRadius: 2,
                  //                           blurRadius: 6.r,
                  //                           offset: Offset(0, 6),
                  //                         ),
                  //                       ],
                  //                       // border: Border.all(
                  //                       //   color: Colors.black,
                  //                       //   width: 1,
                  //                       // ),
                  //                       borderRadius: BorderRadius.circular(10),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: EdgeInsets.only(left: 8.0),
                  //                       child: Column(
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         children: [
                  //                           Text(
                  //                             "Depart From",
                  //                             style: TextStyle(
                  //                               fontFamily: "Urbanist",
                  //                               fontSize: 11.sp,
                  //                               fontWeight: FontWeight.w600,
                  //                               color: Colors.grey,
                  //                             ),
                  //                           ),
                  //                           SizedBox(
                  //                             height: 10.h,
                  //                           ),
                  //                           Text(
                  //                             "Select Source",
                  //                             style: TextStyle(
                  //                               fontFamily: "Urbanist",
                  //                               fontSize: 11.sp,
                  //                               fontWeight: FontWeight.w600,
                  //                               color: Colors.black,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Image.asset("assets/images/exchange.png")
                  //           ],
                  //         ),
                  //         SizedBox(
                  //           height: 35.h,
                  //         ),
                  //         Container(
                  //           height: 50.h,
                  //           width: 250,
                  //           decoration: BoxDecoration(
                  //             color: Colors.black,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Color.fromRGBO(182, 214, 204, 1),
                  //                 spreadRadius: 2,
                  //                 blurRadius: 6.r,
                  //                 offset: Offset(0, 6),
                  //               ),
                  //             ],
                  //             // border: Border.all(
                  //             //   color: Colors.black,
                  //             //   width: 1,
                  //             // ),
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           child: Center(
                  //             child: Text(
                  //               "Book Ticket",
                  //               style: TextStyle(
                  //                 fontFamily: "Urbanist",
                  //                 fontSize: 16.sp,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: Colors.white,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Container(
                    height: 318,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.45),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(182, 214, 204, 1),
                      //     spreadRadius: 2,
                      //     blurRadius: 6.r,
                      //     offset: Offset(0, 6),
                      //   ),
                      // ],
                      // // border: Border.all(
                      // //   color: Colors.black,
                      // //   width: 1,
                      // // ),
                      // borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      String result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlaceListScreen(),
                                        ),
                                      );

                                      print(result);

                                      String placeName =
                                          result; // Replace with the place name you want to geocode
                                      LatLng coordinates =
                                          await getLocationFromAddress(
                                              placeName);
                                      if (coordinates != null) {
                                        setState(() {
                                          initialplacename = result;
                                        });

                                        startlat = coordinates.latitude;
                                        startlong = coordinates.longitude;
                                        print(
                                            "Latitude: ${coordinates.latitude}");
                                        print(
                                            "Longitude: ${coordinates.longitude}");
                                      } else {
                                        print("Location not found");
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 240.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 2.r,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                        // border: Border.all(
                                        //   color: Colors.black,
                                        //   width: 1,
                                        // ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Depart From",
                                              style: TextStyle(
                                                fontFamily: "Urbanist",
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              initialplacename == ""
                                                  ? "Select Source"
                                                  : initialplacename,
                                              style: TextStyle(
                                                fontFamily: "Urbanist",
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 22.48,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      String result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlaceListScreen(),
                                        ),
                                      );

                                      print(result);

                                      String placeName =
                                          result; // Replace with the place name you want to geocode
                                      LatLng coordinates =
                                          await getLocationFromAddress(
                                              placeName);
                                      if (coordinates != null) {
                                        setState(() {
                                          finalplacename = result;
                                        });

                                        endlat = coordinates.latitude;
                                        endlong = coordinates.longitude;
                                        print(
                                            "Latitude: ${coordinates.latitude}");
                                        print(
                                            "Longitude: ${coordinates.longitude}");
                                      } else {
                                        print("Location not found");
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 240.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 2.r,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                        // border: Border.all(
                                        //   color: Colors.black,
                                        //   width: 1,
                                        // ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Depart From",
                                              style: TextStyle(
                                                fontFamily: "Urbanist",
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              finalplacename == ""
                                                  ? "Select Destination"
                                                  : finalplacename,
                                              style: TextStyle(
                                                fontFamily: "Urbanist",
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    String tempplace = initialplacename;

                                    initialplacename = finalplacename;
                                    finalplacename = tempplace;

                                    double templat = startlat!;
                                    double templong = startlong!;
                                    startlat = endlat;
                                    endlat = templat;

                                    startlong = endlong!;
                                    endlong = templong;
                                  });
                                },
                                child: Container(
                                    height: 40,
                                    // color: Colors.red,
                                    child: Image.asset(
                                        "assets/images/exchange.png")),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),

                          Container(
                            height: 1,
                            width: 270,
                            color: Colors.black,
                          ),

                          SizedBox(
                            height: 10.h,
                          ),

                          GestureDetector(
                            onTap: () async {
                              double distance = await calculateDistance(
                                  startlat!, startlong!, endlat!, endlong!);

                              print(distance);

                              double fareamount = distance * 2;

                              print("the fair amount is the " +
                                  fareamount.toString());

                              setState(() {
                                completefareamount =
                                    double.parse(fareamount.toStringAsFixed(2));
                              });

                              print(completefareamount);

                              print(completefareamount);

                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: BookmapScreen(
                                  startlat: startlat!,
                                  startlong: startlong!,
                                  endlat: endlat!,
                                  endlong: endlong!,
                                  fairprice: completefareamount,
                                  initialname: initialplacename,
                                  finalname: finalplacename,
                                ),
                                // screen: Userlocationscreen(),
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 1,
                                    blurRadius: 2.r,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  "Book Ticket",
                                  style: TextStyle(
                                    fontFamily: "Urbanist",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Text(
                          //   completefareamount != 0.00
                          //       ? "Your Calculated Fare is Rs ${completefareamount}"
                          //       : "",
                          //   style: TextStyle(
                          //     fontFamily: "Urbanist",
                          //     fontSize: 16.sp,
                          //     fontWeight: FontWeight.w600,
                          //     color: Colors.black,
                          //   ),
                          // ),

                          // Container(
                          //   height: 50.h,
                          //   width: 250,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Color.fromRGBO(182, 214, 204, 1),
                          //         spreadRadius: 2,
                          //         blurRadius: 6.r,
                          //         offset: Offset(0, 6),
                          //       ),
                          //     ],
                          //     // border: Border.all(
                          //     //   color: Colors.black,
                          //     //   width: 1,
                          //     // ),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       "Book Ticket",
                          //       style: TextStyle(
                          //         fontFamily: "Urbanist",
                          //         fontSize: 16.sp,
                          //         fontWeight: FontWeight.w600,
                          //         color: Colors.white,
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40.w,
                      ),
                      Text(
                        "News",
                        style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 10.h,
                  ),

                  Container(
                    height: 350,
                    width: 360,
                    child:

                        // Assuming you have a list of articles in your News model
                        // You can customize this part based on your data structure
                        FutureBuilder(
                            future: getnewsdata(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 30,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              spreadRadius: 2,
                                              blurRadius: 2.r,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                          // border: Border.all(
                                          //   color: Colors.black,
                                          //   width: 1,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 250,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Container(
                                                // color: Colors.red,
                                                height: 120.h,
                                                child: InstaImageViewer(
                                                  disableSwipeToDismiss: true,
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fitWidth,
                                                    imageUrl: newsdata
                                                        .articles[index]
                                                        .urlToImage!,
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                            // color: Colors.red,
                                                            height: 251.h,
                                                            width: 354.w,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      38,
                                                                      90,
                                                                      232,
                                                                      1),
                                                            ))),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fadeOutDuration:
                                                        const Duration(
                                                            seconds: 1),
                                                    fadeInDuration:
                                                        const Duration(
                                                            seconds: 3),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(
                                                height: 10.h,
                                              ),

                                              Container(
                                                height: 40,
                                                child: Text(
                                                  newsdata
                                                      .articles[index].title,
                                                  style: TextStyle(
                                                    fontFamily: "Urbanist",
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),

                                              Container(
                                                height: 120,
                                                child: SingleChildScrollView(
                                                  child: Text(
                                                    newsdata.articles[index]
                                                        .content,
                                                    style: TextStyle(
                                                      fontFamily: "Urbanist",
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // ListTile(
                                              //   title: Text(newsdata.articles[index].content),
                                              //   subtitle:
                                              //       Text(newsdata.articles[index].title),
                                              //   // Add more widgets to display other information about the article
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                  ),

                  SizedBox(
                    height: 40.h,
                  ),

                  Container(
                    height: 150,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.45),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30.w,
                            ),
                            Text(
                              "Contact us",
                              style: TextStyle(
                                fontFamily: "Urbanist",
                                fontSize: 23.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 35.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                _makePhoneCall();
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.w,
                                child: Image.asset("assets/images/phone.png"),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "DSYNC",
                                  style: TextStyle(
                                    fontFamily: "Urbanist",
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "9821857885",
                                  style: TextStyle(
                                    fontFamily: "Urbanist",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 40.h,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                        GestureDetector(
                            onTap: () async {
                              const url =
                                  'https://www.facebook.com/login/l'; // Replace with your desired URL
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Image.asset("assets/images/facebook.png")),
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                        Container(
                          color: Colors.grey.shade400,
                          height: 60.h,
                          width: 1,
                        ),
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                        GestureDetector(
                            onTap: () async {
                              const url =
                                  'https://twitter.com/home'; // Replace with your desired URL
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Image.asset("assets/images/twitter.png")),
                        // SizedBox(
                        //   width: 27.w,
                        // ),
                        Container(
                          color: Colors.grey.shade400,
                          height: 60.h,
                          width: 1,
                        ),
                        // SizedBox(
                        //   width: 26.w,
                        // ),
                        GestureDetector(
                            onTap: () async {
                              const url =
                                  'https://www.instagram.com/'; // Replace with your desired URL
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Image.asset("assets/images/instagram.png")),
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                        Container(
                          color: Colors.grey.shade400,
                          height: 60.h,
                          width: 1,
                        ),
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                        GestureDetector(
                            onTap: () async {
                              const url =
                                  'https://www.linkedin.com/feed/'; // Replace with your desired URL
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Image.asset(
                              "assets/images/linkdin.png",
                            )),
                        // SizedBox(
                        //   width: 15.w,
                        // ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 340.w,
                        child: Text(
                          "Disclaimer* The information provided in MOVEASY App i.e. bus timings, runtime, bus stop facilities etc. is indicative and subject to change. Commuters are advised to plan their journey in advance as actual journey time may vary as per the prevailing conditions. MOVEASY will not be liable for any direct or indirect loss (of any nature whatsoever) arising from the information contained in this app.",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Urbanist",
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<News> getnewsdata() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=tesla&from=2023-10-04&sortBy=publishedAt&apiKey=92006f1c2bb1459c8240c92d567a50fa'));
    // Uri.parse('https://easyed-backend.onrender.com/api/teacher/${uid}'));
    var data = jsonDecode(response.body.toString());

    // print(data.toString());

    if (response.statusCode == 200) {
      newsdata = News.fromJson(data);
      // sampleteachers. = dat;

      // teacherslist.add(sampleteachers);

      // print(sampleteachers.toString());
      // for (Map<String, dynamic> index in data) {
      //   sampleteachers.add(Teacher.fromJson(index));
      // }
      return newsdata;
    } else {
      return newsdata;
    }
  }

  Widget buildlistitem(BuildContext context, int index) {
    Gamelist gamewidget = gameimageurls[index];
    // return SizedBox(
    //   width: MediaQuery.of(context).size.width - 20,
    //   height: 300,
    //   child: Container(
    //     // key: itemKey,
    //     // color: Colors.red,
    //     height: 30,
    //     width: MediaQuery.of(context).size.width - 20,
    //     child: Column(
    //       children: [
    //         // Container(
    //         //   height: 2,
    //         //   width: 108,
    //         //   color: Colors.black,
    //         // ),
    //         Container(
    //           height: 30,
    //         ),
    //         Row(
    //           children: [
    //             // Container(
    //             //   height: 52,
    //             //   width: 7,
    //             //   color: Colors.black,
    //             // ),
    //             Container(
    //               height: 10,
    //               width: 22,
    //             ),
    //             Container(
    //               // color: Colors.red,
    //               width: MediaQuery.of(context).size.width - 80,
    //               height: 40,
    //               child: FittedBox(
    //                 fit: BoxFit.fitWidth,
    //                 child: Text(
    //                   textwidget.imageurl,
    //                   style: TextStyle(
    //                     color: Color.fromRGBO(136, 75, 197, 3),
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           height: 20,
    //         ),
    //         // Row(
    //         //   children: [
    //         //     SizedBox(
    //         //       width: 25,
    //         //     ),
    //         //     Container(
    //         //       height: 2,
    //         //       width: 108,
    //         //       color: Colors.black,
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     ),
    //   ),
    // );

    // return Container(
    //   height: 50,
    //   color: Colors.yellow,
    //   width: 50,
    // );

    return Column(
      children: [
        Container(
          height: 100.h,
          width: pagedevicewidth,
          child: Transform.scale(
            scale: index == selectedPage ? 1 : 0.9,
            child: Container(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    gamewidget.imageurl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Gamelist {
  final String imageurl;

  Gamelist(this.imageurl);
}

class Place {
  final String name;

  Place(this.name);
}

class PlaceListScreen extends StatelessWidget {
  final List<Place> places = [
    Place('ANAND VIHAR'),
    Place('AZADPUR'),
    Place('ADARSH NAGAR'),
    Place('ARJAN GARH'),
    Place('ARTHALA'),
    Place('BAHADURGARH CITY'),
    Place('ASHOK PARK MAIN'),
    Place('ARTHALA'),
    Place('AKSHARDHAM'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Place List'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(places[index].name),
              onTap: () {
                Navigator.pop(context, places[index].name);
              },
            ),
          );
        },
      ),
    );
  }
}
