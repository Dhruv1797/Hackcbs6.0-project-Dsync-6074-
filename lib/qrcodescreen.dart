import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  final String tokendata;

  const QRCodeScreen({super.key, required this.tokendata});
  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String token = ''; // Variable to store the received token

  final String? useruid = FirebaseAuth.instance.currentUser!.uid;
  final String? useremail = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();
    fetchTokenAndStoreInFirestore();

    // Fetch the token when the widget is initialized
    // fetchToken();
  }

  Future<void> fetchTokenAndStoreInFirestore() async {
    // Store the token in Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userData = await userDoc.get();

      await userDoc.update({
        'tokens': [], // Initialize 'tokens' as an empty list
      });

      // Check if the user document exists
      if (userData.exists) {
        final userTokens = userData['tokens'] as List<dynamic>;
        userTokens.add(widget.tokendata);

        // Update the 'tokens' field with the new array
        await userDoc.update({
          'token': userTokens,
        });
      }
    }
  }

  // Future<void> fetchToken() async {
  //   final apiUrl = Uri.parse(
  //       'https://qrserver.com/v1/create-qr-code/?data=${widget.tokendata}');
  //   try {
  //     final response = await http.get(apiUrl);

  //     if (response.statusCode == 200) {
  //       // Parse the response to extract the token
  //       setState(() {
  //         token = response.body;
  //       });
  //     } else {
  //       // Handle error
  //       print('Failed to fetch token: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Handle network or other errors
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print(useremail);
    print(useruid);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('QR Code Generated'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: QrImageView(
                data: widget.tokendata, // Use the received token here
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),

            SizedBox(height: 20),

            // GestureDetector(
            //     onTap: () async {
            //       await fetchTokenAndStoreInFirestore();
            //     },
            //     child: Text("data"))

            // Show a loading indicator while fetching the token
          ],
        ),
      ),
    );
  }
}
