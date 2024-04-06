import 'package:banking/screen/Home/StartingHomePage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
 late SharedPreferences _prefs;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _showOnboarding = _prefs.getBool('showOnboarding') ?? true;
    });
  }

  void _disableOnboarding() {
    _prefs.setBool('showOnboarding', false);
    setState(() {
      _showOnboarding = false;
    });
  }

  Widget _buildOnboarding() {
    return Scaffold(
      body: PageView(
        children: [
          _buildPage(
            '',
            'Service Available in rural and remote areas',
            'assets/json/woman.json',
          ),
          _buildPage(
            '',
            'Easy to use for Everyone.',
            'assets/json/uncle.json',
          ),
          _buildPage(
            '',
            'Easy to use Payment Gateway',
            'assets/json/card.json',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _disableOnboarding,
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
           Lottie.asset(imagePath),
          SizedBox(height: 16.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showOnboarding ? _buildOnboarding() : StartingHomePage();
  }
}
