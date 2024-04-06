import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CashPoints extends StatefulWidget {
  const CashPoints({Key? key}) : super(key: key);

  @override
  State<CashPoints> createState() => _CashPointsState();
}

class _CashPointsState extends State<CashPoints> {
  late Future<double> cashPointsFuture; // Future to fetch cash points

  @override
  void initState() {
    super.initState();
    cashPointsFuture = fetchCashPoints(); // Initialize the cash points future
  }

  Future<double> fetchCashPoints() async {
    // Get current user's ID
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch user data from Firestore
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();

    // Retrieve and return cash points from user data
    double cashPoints = double.parse(userSnapshot['cashPoints'].toString()); // Parse cash points to double
    return cashPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<double>(
          future: cashPointsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Cash Points',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '${snapshot.data}', // Display the fetched cash points value
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Try again Later");
                      // Implement action to redeem cash points
                    },
                    child: Text('Redeem Cash Points'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
