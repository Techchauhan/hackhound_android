import 'package:banking/paymnet/UpiPaymnet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String savingAccountBalance = "0.0";
  String loanAccountBalance = "0.0";
  bool isSavingBalanceVisible = false;
  bool isLoanBalanceVisible = false;


  final List<String> images = [
    'image1.jpg',
    'image2.jpg',
    'image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Call a function to retrieve the user's balances when the page initializes
    retrieveBalances();
  }

  Future<void> retrieveBalances() async {
    // Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        print(uid);
        // Retrieve the user document from Firestore
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        // Get the balances from the user document
        String savingBalance = userDoc['savingBalance'] ?? 0.0;
        print(savingBalance);
        String loanBalance = userDoc['loanBalance'] ?? 0.0;
        // Update the state with the retrieved balances
        setState(() {
          savingAccountBalance = savingBalance.toString();
          loanAccountBalance = loanBalance.toString();
        });
      } catch (error) {
        print('Error retrieving balances: $error');
      }
    }
  }

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
                  _buildAccountCard("Loan Account", loanAccountBalance.toString(), isLoanBalanceVisible, () {
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
                    _buildPaymentOption('assets/icons/upi-png.png', 'UPI ', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UpiPayments()));
                    }),
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
            SizedBox(height: 100,),
            CarouselSlider(
              items: images.map((image) {
                return Container(
                  margin: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/images/$image',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(String title, String balance, bool isVisible, VoidCallback onTap) {
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
