import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:moveasyuserapp/model/tokenmodel.dart';
import 'package:moveasyuserapp/qrcodescreen.dart';
import 'package:moveasyuserapp/widgets/widgets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class MyMap extends StatefulWidget {
  final double fairprice;
  final String user_id;
  final String initalname;
  final String finalname;
  final String busname;
  MyMap(
    this.user_id,
    this.fairprice,
    this.initalname,
    this.finalname,
    this.busname,
  );

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  AccessToken acesstoken = AccessToken(accessToken: "");
  final _razorpay = Razorpay();
  final String? useremail = FirebaseAuth.instance.currentUser!.email;
  bool loadingQr = false;

  void _initializeRazorpay() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _startPayment() async {
    var options = {
      'key': 'rzp_test_2OQh5hsxIDa0Gp',
      'amount': widget.fairprice *
          100, // Amount in smallest currency unit (e.g., 1000 = 10.00 INR)
      'name': 'MOVEEASY',
      'description': 'Payment for your service',
      'prefill': {
        'contact': '9084773324',
        'email': 'dhruvrastogi1797@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<AccessToken> createAccessToken() async {
    final url =
        Uri.parse('https://moveasy.md2125cse1047.repl.co/create-token/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "email": useremail,
          },
        ), // You can include any data you need to send here
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return AccessToken.fromJson(jsonResponse);
      } else {
        // Handle error here, e.g., throw an exception or return a default AccessToken
        throw Exception('Failed to create access token');
      }
    } catch (e) {
      // Handle network or other errors here
      throw Exception('Failed to create access token: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment success: ${response.paymentId}  ${response.orderId} ');

    setState(() {
      loadingQr = true;
    });
    final accessToken = await createAccessToken();
    print('Access Token: ${accessToken.accessToken}');
    setState(() {
      loadingQr = false;
    });

    nextScreen(context, QRCodeScreen(tokendata: accessToken.accessToken));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  @override
  void initState() {
    super.initState();

    // Call _initializeRazorpay function to set up event listeners
    _initializeRazorpay();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return loadingQr
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      height: deviceheight * 0.772,
                      child: GoogleMap(
                        buildingsEnabled: true,
                        indoorViewEnabled: true,
                        zoomControlsEnabled: true,
                        mapToolbarEnabled: true,
                        compassEnabled: true,
                        mapType: MapType.terrain,
                        markers: {
                          Marker(
                            infoWindow: InfoWindow(
                              title: "UP 14 BT",
                              anchor: const Offset(0.5, 0.0),
                              // snippet: "Hii there",
                            ),
                            position: LatLng(
                              snapshot.data!.docs.singleWhere((element) =>
                                  element.id == widget.user_id)['latitude'],
                              snapshot.data!.docs.singleWhere((element) =>
                                  element.id == widget.user_id)['longitude'],
                            ),
                            markerId: MarkerId('id'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRose),
                          ),
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                              snapshot.data!.docs.singleWhere((element) =>
                                  element.id == widget.user_id)['latitude'],
                              snapshot.data!.docs.singleWhere((element) =>
                                  element.id == widget.user_id)['longitude'],
                            ),
                            zoom: 14.47),
                        onMapCreated: (GoogleMapController controller) async {
                          setState(() {
                            _controller = controller;
                            _added = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      // color: Colors.red,
                      height: deviceheight * 0.225,
                      width: devicewidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          new BoxShadow(
                            blurRadius: 3.0,
                          ),
                        ],
                        // borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: 25,
                          // ),
                          Row(
                            children: [
                              // SizedBox(
                              //   width: 130,
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  Container(
                                    height: 100,
                                    width: devicewidth,
                                    color: Colors.black,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Container(
                                              height: 80,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          28)),
                                              child: Image.asset(
                                                "assets/images/upbus.png",
                                                // fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  // color: Colors.red,
                                                  width: 120,
                                                  height: 50,
                                                  child: Text(
                                                    widget.busname,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 25,
                                                    width: 25,
                                                    child: Image.asset(
                                                      "assets/images/route.png",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Container(
                                                      width: 80,
                                                      height: 55,
                                                      child: Text(
                                                        "${widget.initalname} to ${widget.finalname}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Text(
                                    //   widget.busname,
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w800,
                                    //       fontSize: 30),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          // Container(
                                          //   height: 25,
                                          //   width: 25,
                                          //   child: Image.asset(
                                          //       "assets/images/route.png"),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 180,
                                              height: 55,
                                              child: Text(
                                                "Pay For the Ticket Here !",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(15.0),
                                    //   child: Text("data data data data"),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(15.0),
                                    //   child: Text("data data data data"),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(15.0),
                                    //   child: Text("data data data data"),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(15.0),
                                    //   child: Text("data data data data"),
                                    // ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _startPayment();
                                  },
                                  child: Container(
                                    height: 60.h,
                                    width: 120.w,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius:
                                          BorderRadius.circular(100.45),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 2,
                                          blurRadius: 2.r,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                      border: Border.all(
                                        width: 1.0, // 1px border width
                                        color: Color.fromRGBO(
                                            182, 214, 204, 1), // Border color
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            widget.fairprice.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "0.2% extra charges",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
}
