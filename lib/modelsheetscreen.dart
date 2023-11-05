import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moveasyuserapp/mymap.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ModelSheetScreen extends StatelessWidget {
  final double fairprice;
  final String finalplacename;
  final String initialplacename;
  const ModelSheetScreen(
      {Key? key,
      required this.fairprice,
      required this.finalplacename,
      required this.initialplacename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -15,
          child: Container(
            width: 60,
            height: 7,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
          ),
        ),
        Column(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            height: 270,
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
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
                        title: Row(
                          children: [
                            Container(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                    "assets/images/bus iconnn.png")),
                            Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: Text(snapshot.data!.docs[index]['name']
                                  .toString()),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${initialplacename} to ${finalplacename}",
                              style: TextStyle(
                                  fontSize: 6,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Row(
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
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.directions),
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: MyMap(
                                  snapshot.data!.docs[index].id,
                                  fairprice,
                                  initialplacename,
                                  finalplacename,
                                  snapshot.data!.docs[index]['name']
                                      .toString()),
                              withNavBar:
                                  false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) =>
                            //         MyMap(snapshot.data!.docs[index].id)));
                          },
                        ),
                      );
                    });
              },
            ),
          ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/email.png',
          //   textLabel: 'Sign in with email',
          //   backgroundColor: Colors.white,
          //   elevation: 5.0,
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // const Center(
          //   child: Text(
          //     'OR',
          //     style: TextStyle(fontSize: 18),
          //   ),
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/google.png',
          //   textLabel: 'Sign in with Google',
          //   backgroundColor: Colors.grey.shade300,
          //   elevation: 0.0,
          // ),
          const SizedBox(
            height: 14,
          ),
          // SignInButton(
          //   onTap: () {},
          //   iconPath: 'assets/logos/facebook.png',
          //   textLabel: 'Sign in with Facebook',
          //   backgroundColor: Colors.blue.shade300,
          //   elevation: 0.0,
          // ),
        ])
      ],
    );
  }
}
