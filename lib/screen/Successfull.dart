import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class SuccessfullScreen extends StatefulWidget {
  const SuccessfullScreen({super.key});

  @override
  State<SuccessfullScreen> createState() => _SuccessfullScreenState();
}

class _SuccessfullScreenState extends State<SuccessfullScreen> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset("assets/json/verify.json"),
          ),
          const Text("Your Data has been Sent Successfully. "),
          const Text("Our Bank will call you to Confirm the Details.")
        ],
      ),
    );
  }
}
