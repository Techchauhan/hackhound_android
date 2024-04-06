import 'package:banking/CashPoints/cashPoint.dart';
import 'package:banking/Emergency/Emergency.dart';
import 'package:banking/Setting/Settign.dart';
import 'package:banking/offers/offers.dart';
import 'package:banking/screen/Home/HomePage.dart';
import 'package:banking/screen/Home/StartingHomePage.dart';
import 'package:banking/screen/Notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with WidgetsBindingObserver {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);
  final List<Widget> _tabs = [
    Offers(),
    CashPoints(),
    HomePage(),
    Emergency(),
    Setting(),
  ];

  bool _isEnglish = true; // Track the current language state

  // Define a function to toggle between English and Hindi
  void toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
    // Add logic to change app language here
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateUserStatus(true);
  }

  @override
  void dispose() {
    updateUserStatus(false);
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateUserStatus(bool isOnline) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .update({'isOnline': isOnline});

        if (!isOnline) {
          Timestamp lastSeenTime = Timestamp.now();
          await FirebaseFirestore.instance
              .collection('students')
              .doc(user.uid)
              .update({'lastSeen': lastSeenTime});
        }
      }
    } catch (e) {
      print('Error updating user status: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        updateUserStatus(false);
        break;
      case AppLifecycleState.resumed:
        updateUserStatus(true);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 80,),
              CircleAvatar(
                radius: 50,
              ),
              ListTile(
                leading: Icon(Icons.person, color:  Colors.red,),
                title: Text("My Account"),
                onTap: (){
                  Fluttertoast.showToast(msg: "My Account Open.");
                },
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.red,),
                title: Text("Points"),
                onTap: (){
                  Fluttertoast.showToast(msg: "My Account Open.");
                },
              ),
              ListTile(
                leading: Icon(Icons.compare_arrows, color: Colors.red,),
                title: Text("Transactions"),
                onTap: (){
                  Fluttertoast.showToast(msg: "My Account Open.");
                },
              ),
              ListTile(
                leading: Icon(Icons.headphones, color: Colors.red,),
                title: Text("Contact Us."),
                onTap: (){
                  Fluttertoast.showToast(msg: "My Account Open.");
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.red,),
                title: Text("Loan Status."),
                onTap: (){
                  Fluttertoast.showToast(msg: "My Account Open.");
                },
              ),
              Spacer(),
              ElevatedButton(onPressed: (){}, child: Row(
                children: [
                  Icon(Icons.logout),
                  Text("Log out")
                ],
              ))

            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          // Add IconButton for language toggle
          IconButton(
            icon: Icon(Icons.language),
            onPressed: toggleLanguage,
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            color: Colors.red,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
        ],
        title: Text(
          _isEnglish ? "InRal" : "इनरल",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 25, fontStyle: FontStyle.italic),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _tabs,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.offline_bolt),
            label: 'Offers',
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Cash Points',
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_sharp),
            label: 'Emergency',
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.indigo,
          ),
        ],
      ),
    );
  }
}
