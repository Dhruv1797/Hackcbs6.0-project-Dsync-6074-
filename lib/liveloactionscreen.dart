import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moveasyuserapp/searchpage.dart';
import 'package:moveasyuserapp/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  final Completer<GoogleMapController> controller = Completer();
  double? userlat;
  double? userlong;

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

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final List<Marker> markers = <Marker>[
    // Marker(
    //     markerId: MarkerId("1"),
    //     position: LatLng(28.669155, 77.453758),
    //     infoWindow: InfoWindow(title: "Hello")),
    // Marker(
    //     markerId: MarkerId("1"),
    //     position: LatLng(28.669155, 77.453758),
    //     infoWindow: InfoWindow(title: "Hello")),
  ];
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: 50,
        child: FloatingActionButton(
          child: Icon(
            Icons.location_on,
            color: Colors.black,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          onPressed: () {
            getcurrentlocation().then(
              (value) async {
                print("my current loaction");
                print(value.latitude.toString() +
                    " " +
                    value.longitude.toString());

                userlat = value.latitude;
                userlong = value.longitude;

                markers.add(
                  Marker(
                      markerId: MarkerId("2"),
                      position: LatLng(value.latitude, value.longitude),
                      infoWindow: InfoWindow(title: "my current loaction")),
                );

                markers.add(
                  Marker(
                      icon: markericon,
                      markerId: MarkerId("31"),
                      position: LatLng(28.75183473109767, 77.49921748763565),
                      infoWindow: InfoWindow(title: "BUS 1")),
                );

                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 14,
                );

                final GoogleMapController cotrllr = await controller.future;

                cotrllr.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition));

                setState(() {});
              },
            );
          },
          // backgroundColor: Colors.white,
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: CameraPosition(
                target: LatLng(28.669155, 77.453758), zoom: 14.47),
            markers: Set<Marker>.of(markers),
            onMapCreated: (GoogleMapController controllers) {
              controller.complete(controllers);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 15.0, right: 8.0),
            child: Container(
              height: 70,
              width: 360,
              child: TextField(
                onTap: () {
                  nextScreen(
                      context,
                      SearchPage(
                        userlat: userlat!,
                        userlong: userlong!,
                      ));
                },
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
          )
        ],
      ),
    );
  }
}
