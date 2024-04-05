import 'package:flutter/material.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  List<String> offers = [
    "Get 10% cashback on all purchases using our credit card.",
    "Avail a personal loan at 0% interest for the first 6 months.",
    "Earn double reward points on every transaction with our debit card.",
    "Special discount on home loan interest rates for a limited period.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(offers[index]),
            leading: Icon(Icons.star),
          );
        },
      ),
    );
  }
}
