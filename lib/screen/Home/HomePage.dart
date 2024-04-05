import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double savingAccountBalance = 5000.0;
  double loanAccountBalance = 20000.0;
  bool isSavingBalanceVisible = false;
  bool isLoanBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAccountCard("Saving Account", savingAccountBalance, isSavingBalanceVisible, () {
                    setState(() {
                      isSavingBalanceVisible = !isSavingBalanceVisible;
                    });
                  }),
                  SizedBox(width: 10),
                  _buildAccountCard("Loan Account", loanAccountBalance, isLoanBalanceVisible, () {
                    setState(() {
                      isLoanBalanceVisible = !isLoanBalanceVisible;
                    });
                  }),
                ],
              ),
            ),
            SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentOption('assets/icons/upi-png.png', 'UPI ', () {}),
                    SizedBox(width: 10),
                    _buildPaymentOption('assets/icons/wallet.png', 'Wallet', () {}),
                    SizedBox(width: 10),
                    _buildPaymentOption('assets/icons/atm-card.png', 'Credit Card', () {}),
                    SizedBox(width: 10),
                    _buildPaymentOption('assets/icons/fund.png', 'Fund ', () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(String title, double balance, bool isVisible, VoidCallback onTap) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  isVisible
                      ? Text(
                    "\₹ $balance",
                    style: TextStyle(fontSize: 16),
                  )
                      : Text(
                    "****",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(isVisible ? Icons.visibility_off : Icons.remove_red_eye),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String imagePath, String title, Function() onTap) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imagePath, height: 30, width: 30),
                SizedBox(height: 5),
                Text(title, style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

