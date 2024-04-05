import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CashPoints extends StatefulWidget {
  const CashPoints({Key? key}) : super(key: key);

  @override
  State<CashPoints> createState() => _CashPointsState();
}

class _CashPointsState extends State<CashPoints> {
  int earnedCashPoints = 500; // Example earned cash points value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Cash Points',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '$earnedCashPoints', // Display the earned cash points value
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
        ),
      ),
    );
  }
}
