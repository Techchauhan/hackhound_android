import 'package:banking/Home/BottomNavigation.dart';
import 'package:banking/screen/Home/HomePage.dart';
import 'package:banking/screen/Home/StartingHomePage.dart';
import 'package:banking/screen/OnboardinScreen/onboardingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          // If no user is logged in, navigate to the login page
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>OnboardingScreen()
          ));
        } else {
          // If a user is logged in, navigate to the home page
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),



            SizedBox(height: 20,),


            SizedBox(height: 49,),
            // Add your splash screen content here
           const Text("InRal", style: TextStyle(color: Colors.red, fontSize: 90, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
            SizedBox(height: 49,),

            const CircularProgressIndicator(),
            SizedBox(height: 200,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Made By PulseZest',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20,),
                Image.asset('assets/images/logo.png',
                  height: 20,
                  width: 20,
                ),
              ],
            ),

          // You can add a loading indicator

          ],
        ),
      ),
    );
  }
}