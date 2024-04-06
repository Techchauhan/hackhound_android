import 'package:flutter/material.dart';

class TransactionDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Date:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('April 5, 2024'), // Replace with actual transaction date

            SizedBox(height: 16.0),

            Text(
              'Transaction Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Deposit'), // Replace with actual transaction type

            SizedBox(height: 16.0),

            Text(
              'Amount:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('\$500.00'), // Replace with actual transaction amount

            SizedBox(height: 16.0),

            Text(
              'Transaction Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Completed'), // Replace with actual transaction status

            SizedBox(height: 16.0),

            Text(
              'Transaction ID:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('ABC123XYZ'), // Replace with actual transaction ID

            SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: () {
                // Add functionality to navigate back or perform other actions
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TransactionDetailsPage(),
  ));
}
