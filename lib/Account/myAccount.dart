import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late User? _user;
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();
      setState(() {
        _userData = userData.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
      ),
      body: _user != null
          ? ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Name'),
            subtitle: Text(_userData['fullName'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text(_user!.email ?? 'N/A'),
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text(_userData['number'] ?? 'N/A'),
          ),
          ListTile(
            title: Text('Address'),
            subtitle: Text(_userData['address'] ?? 'N/A'),
          ),
          // Add more user details as needed
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


