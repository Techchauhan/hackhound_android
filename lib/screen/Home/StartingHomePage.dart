import 'package:banking/Login/login.dart';
import 'package:banking/openAccount/CreateAccountPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StartingHomePage extends StatefulWidget {
  const StartingHomePage({super.key});

  @override
  State<StartingHomePage> createState() => _StartingHomePageState();
}

class _StartingHomePageState extends State<StartingHomePage> {

  final List<String> images = [
    'image1.jpg',
    'image2.jpg',
    'image3.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Add your study-related content here

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
                      SizedBox(height: 10,),

                      const Text(
                        'Welcome to InRal Bank ',
                        style: TextStyle(
                          fontSize: 26.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      }, child: Text("Proceed to Login")),
                      SizedBox(height: 10,),
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAccountPage()));
                      }, child: Text("Open Account"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
