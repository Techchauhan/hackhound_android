import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CashPointIncrease extends StatelessWidget {
  final String cashPoints;

  CashPointIncrease(this.cashPoints);

  Future<double> fetchCashPoints() async {
    // Get current user's ID
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch user data from Firestore
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();

    // Retrieve and return cash points from user data
    double cashPoints = userSnapshot['cashPoints'] ?? 0.0;
    return cashPoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<double>(
          future: fetchCashPoints(),
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
                    'Payment Successful!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cash Points increased: ${snapshot.data}',
                    style: TextStyle(fontSize: 18),
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
