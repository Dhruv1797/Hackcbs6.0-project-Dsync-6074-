import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveasyuserapp/drawer.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FairCalculatorScreen extends StatefulWidget {
  const FairCalculatorScreen({super.key});

  @override
  State<FairCalculatorScreen> createState() => _FairCalculatorScreenState();
}

class _FairCalculatorScreenState extends State<FairCalculatorScreen> {
  String finalplacename = "";
  String initialplacename = "";
  double completefareamount = 0.00;

  double? startlat;
  double? startlong;
  double? endlat;
  double? endlong;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: deviceheight,
            width: devicewidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            height: 20,
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
                                fontSize: 23.sp,
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
                  SizedBox(
                    height: 60.h,
                  ),
                  Container(
                    height: 303,
                    width: 324,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20.45),
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
                            width: 300,
                            color: Colors.black,
                          ),

                          SizedBox(
                            height: 30.h,
                          ),

                          Text(
                            completefareamount != 0.00
                                ? "Your Calculated Fare is Rs ${completefareamount}"
                                : "",
                            style: TextStyle(
                              fontFamily: "Urbanist",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),

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
                  SizedBox(
                    height: 60.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      double distance = calculateDistance(
                          startlat!, startlong!, endlat!, endlong!);

                      print(distance);

                      double fareamount = distance * 2;

                      print(fareamount);

                      setState(() {
                        completefareamount =
                            double.parse(fareamount.toStringAsFixed(2));
                      });

                      print(completefareamount);
                    },
                    child: Container(
                      height: 60,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 2,
                            blurRadius: 2.r,
                            offset: Offset(0, 4),
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
                          "Caculate Fare",
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
                  SizedBox(
                    height: 30.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        initialplacename = "";
                        finalplacename = "";
                        completefareamount = 0.00;
                      });
                    },
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
