import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_slider/source/presentation/pages/introduction_slider.dart';
import 'package:introduction_slider/source/presentation/widgets/buttons.dart';
import 'package:introduction_slider/source/presentation/widgets/dot_indicator.dart';
import 'package:introduction_slider/source/presentation/widgets/introduction_slider_item.dart';

import 'package:location/location.dart' as loc;
import 'package:moveasyuserapp/auth/login_page.dart';
import 'package:moveasyuserapp/button.dart';
import 'package:moveasyuserapp/contactus.dart';
import 'package:moveasyuserapp/dashboardscreen.dart';
import 'package:moveasyuserapp/drawer.dart';
import 'package:moveasyuserapp/faircalculatorscreen.dart';
import 'package:moveasyuserapp/flutter_flow/index.dart';

import 'package:moveasyuserapp/mymap.dart';
import 'package:moveasyuserapp/navbarscreen.dart';
import 'package:moveasyuserapp/onboardscreen.dart';
import 'package:moveasyuserapp/paymentscreen.dart';
import 'package:moveasyuserapp/profile_page.dart';
import 'package:moveasyuserapp/service/auth_service.dart';
import 'package:moveasyuserapp/service/database_service.dart';
import 'package:moveasyuserapp/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'helper/helper_function.dart';
import 'package:moveasyuserapp/news/all/provider/newsprovider.dart';
import 'package:moveasyuserapp/news/contry/provider/cprovider.dart';
import 'package:moveasyuserapp/news/health/provider/hprovider.dart';
import 'package:moveasyuserapp/news/buisness/provider/bprovider.dart';
import 'package:moveasyuserapp/news/utils/tabbar.dart';
import 'package:moveasyuserapp/news/all/view/Newspage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => NewsProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CountryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => HelthProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => BusinessProvider(),
      ),
    ],
    child: ScreenUtilInit(
      designSize: const Size(360, 800),
      child: MaterialApp(
        // routes: {
        //   '/': (context) => TabBaar(),
        //   'H': (context) => Home_Page(),
        // },
        home: Builder(builder: (context) {
          return AnimatedSplashScreen(
            splash: Container(
                // color: Colors.red,
                height: 400,
                width: 400,
                child: Column(children: <Widget>[
                  Container(
                    // color: Colors.yellow,
                    height: 600,
                    width: 600,
                    child: Image.asset(
                      'assets/images/movelogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // SizedBox(
                  //   height: 19,
                  // ),
                  // Text(
                  //   'Where Memories Matter',
                  //   style: TextStyle(
                  //       color: Color.fromRGBO(0, 0, 0, 1),
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 16),
                  // )
                ])),
            splashIconSize: 800,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white,
            duration: 500,
            nextScreen: IntroductionSlider(
              items: [
                IntroductionSliderItem(
                  // backgroundImageDecoration: BackgroundImageDecoration(
                  //     image: AssetImage("assets/splashbackground.png")),
                  logo: Container(
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Builder(builder: (context) {
                              return TextButton(
                                  onPressed: () {
                                    nextScreen(context, LoginPage());
                                  },
                                  child: Text(
                                    "Skip",
                                    style: TextStyle(
                                        color: Color.fromRGBO(79, 79, 79, 1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ));
                            }),
                          ],
                        ),
                        Container(
                          // color: Colors.red,
                          height: 386,
                          width: 386,
                          child: Image.asset("assets/images/mapmove.png"),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 34,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 319,
                                  child: Text(
                                    "One Stop solution for all your wait",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(39, 39, 39, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 243,
                                  child: Text(
                                    "Hangout, Share special moments,\nmake memories.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromRGBO(39, 39, 39, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                  // title: Text("Title 1"),
                  // subtitle: Text("Hello"),
                  backgroundColor: Colors.white,
                ),

                IntroductionSliderItem(
                  // backgroundImageDecoration: BackgroundImageDecoration(
                  //     image: AssetImage("assets/splashbackground.png")),
                  logo: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                nextScreen(context, LoginPage());
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Color.fromRGBO(79, 79, 79, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      Container(
                        // color: Colors.red,
                        height: 386,
                        width: 386,
                        child: Image.asset("assets/images/11.png"),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 34,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 319,
                                child: Text(
                                  "Now no can disturb your chat!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      fontSize: 16.7,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 243,
                                child: Text(
                                  "Hangout, Share special moments,\nmake memories.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                  // title: Text("Title 1"),
                  // subtitle: Text("Hello"),
                  backgroundColor: Colors.white,
                ),
                IntroductionSliderItem(
                  // backgroundImageDecoration: BackgroundImageDecoration(
                  //     image: AssetImage("assets/splashbackground.png")),
                  logo: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                nextScreen(context, LoginPage());
                              },
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Color.fromRGBO(79, 79, 79, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      Container(
                        // color: Colors.red,
                        height: 386,
                        width: 386,
                        child: Image.asset("assets/images/intr.png"),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 34,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: 319,
                                child: Text(
                                  "Find your special moments easily!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      fontSize: 16.7,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 243,
                                child: Text(
                                  "Hangout, Share special moments,\nmake memories.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromRGBO(39, 39, 39, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                  // title: Text("Title 1"),
                  // subtitle: Text("Hello"),
                  backgroundColor: Colors.white,
                ),
                // IntroductionSliderItem(
                //   logo: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Container(
                //         // color: Colors.red,
                //         height: 386,
                //         width: 386,
                //         child: Image.asset("assets/Messagespana2.png"),
                //       ),
                //       Row(
                //         children: [
                //           SizedBox(
                //             width: 34,
                //           ),
                //           Column(
                //             children: [
                //               SizedBox(
                //                 width: 319,
                //                 child: Text(
                //                   "Now no can disturb your chat!",
                //                   maxLines: 1,
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                       color: Color.fromRGBO(39, 39, 39, 1),
                //                       fontSize: 16.7,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //               SizedBox(
                //                 height: 20,
                //               ),
                //               SizedBox(
                //                 width: 243,
                //                 child: Text(
                //                   "Lorem Ipsum is simply dummy text of the printing ",
                //                   textAlign: TextAlign.start,
                //                   style: TextStyle(
                //                       color: Color.fromRGBO(39, 39, 39, 1),
                //                       fontSize: 10,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 100,
                //       ),
                //     ],
                //   ),
                //   // title: Text("Title 1"),
                //   // subtitle: Text("Hello"),
                //   backgroundColor: Colors.white,
                // ),
                // IntroductionSliderItem(
                //   logo: Column(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Container(
                //         // color: Colors.red,
                //         height: 386,
                //         width: 386,
                //         child: Image.asset("assets/Messagespana3.png"),
                //       ),
                //       Row(
                //         children: [
                //           SizedBox(
                //             width: 34,
                //           ),
                //           Column(
                //             children: [
                //               SizedBox(
                //                 width: 319,
                //                 child: Text(
                //                   "Find your special moments easily!",
                //                   maxLines: 1,
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                       color: Color.fromRGBO(39, 39, 39, 1),
                //                       fontSize: 16.7,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //               SizedBox(
                //                 height: 20,
                //               ),
                //               SizedBox(
                //                 width: 243,
                //                 child: Text(
                //                   "Lorem Ipsum is simply dummy text of the printing and typesetting industr",
                //                   textAlign: TextAlign.center,
                //                   style: TextStyle(
                //                       color: Color.fromRGBO(39, 39, 39, 1),
                //                       fontSize: 10,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 100,
                //       ),
                //     ],
                //   ),
                //   // title: Text("Title 1"),
                //   // subtitle: Text("Hello"),
                //   backgroundColor: Colors.white,
                // ),

                // IntroductionSliderItem(
                //   logo: FlutterLogo(),
                //   title: Text("Title 2"),
                //   backgroundColor: Colors.white,
                // ),
                // IntroductionSliderItem(
                //   logo: FlutterLogo(),
                //   title: Text("Title 3"),
                //   backgroundColor: Colors.white,
                // ),
              ],
              done: Done(
                child: Icon(
                  Icons.done,
                  color: Colors.black,
                ),
                home: OnboardScreen(),
              ),
              next: Next(
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              ),
              back: Back(
                  child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
              dotIndicator: DotIndicator(
                selectedColor: Colors.black,
                unselectedColor: Color.fromRGBO(214, 204, 204, 1),
              ),
            ),
          );
        }),
        debugShowCheckedModeBanner: false,
      ),
    ),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(222, 95, 39, 60),
            elevation: 0,
            title: const Text(
              "MOVEASY",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),

          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          drawer: MyDrawer(),
          // appBar: AppBar(
          //   title: Text('live location tracker'),
          // ),
          // drawer: Drawer(
          //     child: ListView(
          //   padding: const EdgeInsets.symmetric(vertical: 50),
          //   children: <Widget>[
          //     Icon(
          //       Icons.account_circle,
          //       size: 150,
          //       color: Colors.grey[700],
          //     ),
          //     const SizedBox(
          //       height: 15,
          //     ),
          //     Text(
          //       userName,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     const Divider(
          //       height: 2,
          //     ),
          //     // ListTile(
          //     //   onTap: () {
          //     //     nextScreen(context, MyApp());
          //     //   },
          //     //   contentPadding:
          //     //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //     //   leading: const Icon(Icons.group),
          //     //   title: const Text(
          //     //     "Groups",
          //     //     style: TextStyle(color: Colors.black),
          //     //   ),
          //     // ),
          //     ListTile(
          //       onTap: () {
          //         nextScreen(context, MyApp());
          //       },
          //       selected: true,
          //       selectedColor: Theme.of(context).primaryColor,
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.group),
          //       title: const Text(
          //         "Home Screen",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //     ListTile(
          //       onTap: () async {
          //         showDialog(
          //             barrierDismissible: false,
          //             context: context,
          //             builder: (context) {
          //               return AlertDialog(
          //                 title: const Text("Logout"),
          //                 content:
          //                     const Text("Are you sure you want to logout?"),
          //                 actions: [
          //                   IconButton(
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                     icon: const Icon(
          //                       Icons.cancel,
          //                       color: Colors.red,
          //                     ),
          //                   ),
          //                   IconButton(
          //                     onPressed: () async {
          //                       await authService.signOut();
          //                       Navigator.of(context).pushAndRemoveUntil(
          //                           MaterialPageRoute(
          //                               builder: (context) =>
          //                                   const LoginPage()),
          //                           (route) => false);
          //                     },
          //                     icon: const Icon(
          //                       Icons.done,
          //                       color: Colors.green,
          //                     ),
          //                   ),
          //                 ],
          //               );
          //             });
          //       },
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.exit_to_app),
          //       title: const Text(
          //         "Logout",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     )
          //   ],
          // )),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/up.jpg"), fit: BoxFit.fill),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // MyButton(
                //     onPressed: () {
                //       _getLocation();
                //     },
                //     text: "add Location"),
                // MyButton(
                //     onPressed: () {
                //       _listenLocation();
                //     },
                //     text: "start tracking"),
                // MyButton(
                //     onPressed: () {
                //       _stopListening();
                //     },
                //     text: "stop tracking"),

                // TextButton(
                //     onPressed: () {
                //       nextScreenReplace(
                //           context,
                //           ProfilePage(
                //             userName: userName,
                //             email: email,
                //           ));
                //     },
                //     child: Text('about page')),
                // Text('data'),
                // TextButton(
                //     onPressed: () {
                //       _listenLocation();
                //     },
                //     child: Text('enable live location')),
                // TextButton(
                //     onPressed: () {
                //       _stopListening();
                //     },
                //     child: Text('stop live location')),
                Container(
                  color: Colors.white,
                  height: 180,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('location')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            // return Container(
                            //   height: 100,
                            //   width: 100,
                            //   color: Colors.white,
                            // );
                            return ListTile(
                              title: Text(snapshot.data!.docs[index]['name']
                                  .toString()),
                              subtitle: Row(
                                children: [
                                  Text(snapshot.data!.docs[index]['latitude']
                                      .toString()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(snapshot.data!.docs[index]['longitude']
                                      .toString()),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: MyMap(
                                        snapshot.data!.docs[index].id,
                                        40.32,
                                        "Ghaziabad",
                                        "Meerut",
                                        "UP 14 BT 9043"),
                                    withNavBar:
                                        false, // OPTIONAL VALUE. True by default.
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => MyMap(
                                  //         snapshot.data!.docs[index].id)));
                                },
                              ),
                            );
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
