import 'package:banking/Home/BottomNavigation.dart';
import 'package:banking/paymnet/cashPointIncress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpiPayments extends StatefulWidget {
  const UpiPayments({Key? key}) : super(key: key);

  @override
  State<UpiPayments> createState() => _UpiPaymentsState();
}

class _UpiPaymentsState extends State<UpiPayments> {
  String? selectedUpiType;
  TextEditingController upiIdController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<void> makePayment() async {
    String upiId = upiIdController.text;
    String upiType = selectedUpiType ?? '';
    double amount = double.tryParse(amountController.text) ?? 0.0;

    // Fetch current user's data from Firestore
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // Replace with your logic to get current user ID
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    String gender = userSnapshot['gender'];

    // Update cashPoints based on gender
    if (gender == 'female') {
      double cashPointsIncrement = amount * 0.005; // 0.5% of the sent amount
      double currentCashPoints = userSnapshot['cashPoints']?.toDouble() ?? 0.0;
      double newCashPoints = currentCashPoints + cashPointsIncrement;

      // Update cashPoints in Firestore
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'cashPoints': newCashPoints,
      });

      // Navigate to success message screen
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CashPointIncrease(newCashPoints.toString())));

      Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: upiIdController,
                    decoration: InputDecoration(
                      labelText: 'Enter UPI ID',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                DropdownButton<String>(
                  value: selectedUpiType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedUpiType = newValue;
                    });
                  },
                  items: <String>[
                    '@ybl',
                    '@sbi',
                    // Add more UPI types here
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Select UPI Type'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                makePayment();
              },
              child: const Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
