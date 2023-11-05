import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveasyuserapp/main.dart';
import 'package:moveasyuserapp/modelsheetscreen.dart';
import 'package:moveasyuserapp/searchpage.dart';
import 'package:moveasyuserapp/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class BusMapScreen extends StatefulWidget {
  final double userlat;
  final double userlong;
  const BusMapScreen(
      {super.key, required this.userlat, required this.userlong});

  @override
  State<BusMapScreen> createState() => _BusMapScreenState();
}

class _BusMapScreenState extends State<BusMapScreen> {
  void showdownSheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(30),
      )),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.9,
          minChildSize: 0.32,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: ModelSheetScreen(
                fairprice: 40.27,
                finalplacename: "ANAND VIHAR",
                initialplacename: "ARGAN GARG",
              ),
            );
          }),
    );
  }

  BitmapDescriptor markericon = BitmapDescriptor.defaultMarker;

  void addCustomIcon() async {
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(size: Size(10, 10)), "assets/images/car2.png")
    //     .then((icon) {
    //   setState(() {
    //     markericon = icon;
    //   });
    // });
    final Uint8List customMarker = await getBytesFromAsset(
        path: "assets/images/bus icon.jpg", //paste the custom image path
        width: 130 // size of custom image as marker
        );

    setState(() {
      markericon = BitmapDescriptor.fromBytes(customMarker);
    });
  }

  void initState() {
    addCustomIcon();
    super.initState();
  }

  final Completer<GoogleMapController> controller = Completer();

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Position> getcurrentlocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> markers = <Marker>[
      Marker(
          markerId: MarkerId("1"),
          position: LatLng(widget.userlat, widget.userlong),
          infoWindow: InfoWindow(title: "My Location")),
      Marker(
          icon: markericon,
          markerId: MarkerId("2"),
          position: LatLng(28.633857967123006, 77.45211215560698),
          infoWindow: InfoWindow(title: "BUS 1")),
      Marker(
          icon: markericon,
          markerId: MarkerId("3"),
          position: LatLng(28.631859096266, 77.44275661059794),
          infoWindow: InfoWindow(title: "Bus 2")),
      Marker(
          onTap: () {
            // showdownSheet(context);
          },
          icon: markericon,
          markerId: MarkerId("4"),
          position: LatLng(28.637679820848703, 77.43400188037003),
          infoWindow: InfoWindow(title: "Bus 3")),
      Marker(
          onTap: () {
            // showdownSheet(context);
          },
          icon: markericon,
          markerId: MarkerId("5"),
          position: LatLng(28.751829, 77.48975),
          infoWindow: InfoWindow(title: "Bus 4")),
      Marker(
          onTap: () {
            // showdownSheet(context);
          },
          icon: markericon,
          markerId: MarkerId("6"),
          position: LatLng(28.637339449312563, 77.44631060224492),
          infoWindow: InfoWindow(title: "Bus 4")),
      Marker(
          onTap: () {
            // showdownSheet(context);
          },
          icon: markericon,
          markerId: MarkerId("7"),
          position: LatLng(28.75188379384639, 77.49917971007089),
          infoWindow: InfoWindow(title: "Bus 7")),
    ];
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   getcurrentlocation().then((value) async {
      //     print("my current loaction");
      //     print(value.latitude.toString() + " " + value.longitude.toString());

      //     markers.add(
      //       Marker(
      //           markerId: MarkerId("2"),
      //           position: LatLng(value.latitude, value.longitude),
      //           infoWindow: InfoWindow(title: "my current loaction")),
      //     );

      //     CameraPosition cameraPosition = CameraPosition(
      //       target: LatLng(value.latitude, value.longitude),
      //       zoom: 14,
      //     );

      //     final GoogleMapController cotrllr = await controller.future;

      //     cotrllr.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      //     setState(() {});
      //   });
      // }),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.userlat, widget.userlong), zoom: 14.47),
            markers: Set<Marker>.of(markers),
            // onMapCreated: (GoogleMapController controllers) {
            //   // controller.complete(controllers);
            // },
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                showdownSheet(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 20,
                width: 250,
              ),
            ),
          ),

          // DraggableScrollableSheet(
          //     initialChildSize: 0.05,
          //     minChildSize: 0.05,
          //     maxChildSize: 0.5,
          //     snapSizes: [0.05, 0.5],
          //     snap: true,
          //     builder: (BuildContext context, scrollController) {
          //       return Container(
          //         color: Colors.white,
          //         child: ListView.builder(
          //           padding: EdgeInsets.zero,
          //           physics: ClampingScrollPhysics(),
          //           controller: scrollController,
          //           itemCount: 1,
          //           itemBuilder: (BuildContext context, int index) {
          //             // final car = cars[index];
          //             if (index == 0) {
          //               return Padding(
          //                   padding: EdgeInsets.all(8.0),
          //                   child: Column(
          //                     children: [
          //                       SizedBox(
          //                         width: 250,
          //                         child: Divider(
          //                           height: 20,
          //                           thickness: 5,
          //                         ),
          //                       ),
          //                       // Text('Choose a tripe or swipe up for more')
          //                     ],
          //                   ));
          //             }
          //             return Card(
          //               margin: EdgeInsets.zero,
          //               elevation: 0,
          //               child: ListTile(
          //                 contentPadding: EdgeInsets.all(10),
          //                 onTap: () {
          //                   // setState(() {
          //                   //   selectedCarId = car['id'];
          //                   // });
          //                 },
          //                 // leading: Icon(Icons.car_rental),
          //                 // title: Text(car['name']),
          //                 // trailing: Text(
          //                 //   car['price'].toString(),
          //                 // ),
          //                 // selected: selectedCarId == car['id'],
          //                 selectedTileColor: Colors.grey[200],
          //               ),
          //             );
          //           },
          //         ),
          //       );
          //     })
          // Padding(
          //   padding: const EdgeInsets.only(top: 60, left: 15.0, right: 8.0),
          //   child: Container(
          //     height: 70,
          //     width: 360,
          //     child: TextField(
          //       onTap: () {
          //         nextScreen(context, SearchPage());
          //       },
          //       style: TextStyle(
          //           color: Colors.black,
          //           fontSize: 17,
          //           fontWeight: FontWeight.w400),
          //       decoration: InputDecoration(
          //           prefixIconColor: Colors.black,
          //           prefixIcon: Icon(Icons.search),
          //           // ImageIcon(AssetImage("assets/searchicon.png"), size: 15),
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(27.0),
          //           ),
          //           filled: true,
          //           hintStyle: TextStyle(
          //               color: Colors.black54,
          //               fontSize: 17,
          //               fontWeight: FontWeight.w700),
          //           hintText: "Search Destination Here",
          //           fillColor: Colors.grey),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
