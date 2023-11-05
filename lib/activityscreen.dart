import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;
    double appbarheight = 45;

    double devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Activity",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 30,
              ),
              Text("Upcomming",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(color: Colors.black87)),
                  height: 120,
                  width: devicewidth * 0.85,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You Have no upcomming",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  Text(
                                    "trips",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Reserve your Trip",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Icon(Icons.bus_alert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 18),
                child: Text("Past",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ),

              Container(
                height: deviceheight * 0.51,
                // color: Colors.red,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PastCards(
                        devicewidth: devicewidth,
                        locationtext: "AUTOMATIVE\nMECHATRONICS CENTRE",
                        timetext: "5 jan  3:59 PM",
                        statustext: "\$66.82  Cancelled",
                      ),
                      PastCards(
                        devicewidth: devicewidth,
                        locationtext: "KIET\nGROUP OF INSTITUTIONS",
                        timetext: "4 jan  6:59 PM",
                        statustext: "\$66.82  Completed",
                      ),
                      PastCards(
                        devicewidth: devicewidth,
                        locationtext: "PURANA BUSADDA         ",
                        timetext: "10 jan  1:60 PM",
                        statustext: "\$66.82  Cancelled",
                      ),
                      PastCards(
                        devicewidth: devicewidth,
                        locationtext: "ABES Engineering College",
                        timetext: "11 jan  7:59 PM",
                        statustext: "\$66.82  Completed",
                      ),
                      PastCards(
                        devicewidth: devicewidth,
                        locationtext:
                            "JSS Academy\nof Technical Education       ",
                        timetext: "5 jan  3:59 PM",
                        statustext: "\$66.82  Completed",
                      ),
                      // PastCards(
                      //   devicewidth: devicewidth,
                      //   locationtext: "KIET\nGROUP OF INSTITUTIONS",
                      //   timetext: "5 jan  3:59 PM",
                      //   statustext: "\$66.82  Completed",
                      // ),
                      // PastCards(
                      //   devicewidth: devicewidth,
                      //   locationtext: "KIET\nGROUP OF INSTITUTIONS",
                      //   timetext: "5 jan  3:59 PM",
                      //   statustext: "\$66.82  Completed",
                      // ),
                      // PastCards(
                      //   devicewidth: devicewidth,
                      //   locationtext: "KIET\nGROUP OF INSTITUTIONS",
                      //   timetext: "5 jan  3:59 PM",
                      //   statustext: "\$66.82  Completed",
                      // ),
                      // PastCards(
                      //   devicewidth: devicewidth,
                      //   locationtext: "KIET\nGROUP OF INSTITUTIONS",
                      //   timetext: "5 jan  3:59 PM",
                      //   statustext: "\$66.82  Completed",
                      // ),
                      // PastCards(
                      //   devicewidth: devicewidth,
                      //   locationtext: "KIET\nGROUP OF INSTITUTIONS",
                      //   timetext: "5 jan  3:59 PM",
                      //   statustext: "\$66.82  Completed",
                      // ),
                    ],
                  ),
                ),
              )

              // PastCards(devicewidth: devicewidth),
              // PastCards(devicewidth: devicewidth),
            ],
          ),
        ),
      ),
    );
  }
}

class PastCards extends StatelessWidget {
  final String locationtext;
  final String timetext;
  final String statustext;
  const PastCards({
    super.key,
    required this.devicewidth,
    required this.locationtext,
    required this.timetext,
    required this.statustext,
  });

  final double devicewidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: Colors.black87)),
        height: 133,
        width: devicewidth * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationtext,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                        // Text(
                        //   "MECHATRONICS CENTRE",
                        //   style: TextStyle(
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w900,
                        //       color: Colors.black),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timetext,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                statustext,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Icon(Icons.bus_alert),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
