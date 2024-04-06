import 'dart:io';
import 'package:banking/screen/Successfull.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String? _selectedAccountType;
  File? _aadharCardPhoto;
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  String? _accountNumber;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController(); // New field
  final TextEditingController _addressController = TextEditingController(); // New field
  bool _isCreatingAccount = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _numberController.dispose(); // Dispose number controller
    _addressController.dispose(); // Dispose address controller
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _aadharCardPhoto = File(pickedFile.path);
      }
    });
  }

  Future<void> _createAccount() async {
    if (_isCreatingAccount ||
        _aadharCardPhoto == null ||
        _selectedAccountType == null ||
        _fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedDateOfBirth == null ||
        _numberController.text.isEmpty || // New field validation
        _selectedGender == null || // New field validation
        _addressController.text.isEmpty) { // New field validation
      return; // Prevent account creation if necessary information is missing
    }

    setState(() {
      _isCreatingAccount = true;
    });

    try {
      // Splitting full name to get the first name and last name
      List<String> nameParts = _fullNameController.text.split(" ");
      String firstName = nameParts[0];
      // Assuming that the last part of the name is the last name
      String lastName = nameParts.last;

      // Extracting year from the selected date of birth
      int dobYear = _selectedDateOfBirth!.year;

      // Generating password by concatenating first name, last name, and birth year
      String password = '$firstName@$dobYear';

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: password,
      );

      // Generate an account number (You can use any logic here)
      _accountNumber = 'AC-${userCredential.user!.uid.substring(0, 6).toUpperCase()}';

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'dateOfBirth': _selectedDateOfBirth,
        'accountType': _selectedAccountType,
        'accountNumber': _accountNumber,
        'number': _numberController,
        'savingBalance': "0",
        'cashPoints': "0",
        'number': _numberController.text.trim(), // Store number field
        'gender': _selectedGender, // Store gender field
        'address': _addressController.text.trim(), // Store address field
        // Add more fields as needed
      });

      // Upload Aadhar card photo to Firebase Storage
      String aadharCardPhotoUrl = await _uploadAadharCardPhoto(userCredential.user!.uid);

      // Update user data with Aadhar card photo URL
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
        'aadharCardPhotoUrl': aadharCardPhotoUrl,
      });

      // Clear form fields and photo after successful account creation
      _fullNameController.clear();
      _emailController.clear();
      _numberController.clear(); // Clear number field
      _addressController.clear(); // Clear address field
      setState(() {
        _selectedAccountType = null;
        _aadharCardPhoto = null;
        _selectedDateOfBirth = null;
        _isCreatingAccount = false;
      });

      // Navigate to the successful screen after account creation
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SuccessfullScreen()));

      // Optionally, navigate to another screen after account creation
      // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
    } catch (error) {
      // Handle account creation errors
      print("Error creating account: $error");
      setState(() {
        _isCreatingAccount = false;
      });
      // Optionally, show an error message to the user
    }
  }

  Future<String> _uploadAadharCardPhoto(String userId) async {
    String fileName = 'aadhar_card_$userId.jpg';
    try {
      // Upload file to Firebase Storage
      await FirebaseStorage.instance.ref('aadhar_cards').child(fileName).putFile(_aadharCardPhoto!);
      // Get download URL
      String downloadURL = await FirebaseStorage.instance.ref('aadhar_cards').child(fileName).getDownloadURL();
      return downloadURL;
    } catch (error) {
      // Handle file upload errors
      print("Error uploading Aadhar card photo: $error");
      throw error; // Rethrow the error to handle it in the caller function
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Bank Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create Bank Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null && pickedDate != _selectedDateOfBirth) {
                    setState(() {
                      _selectedDateOfBirth = pickedDate;
                    });
                  }
                },
                child: Text(
                  _selectedDateOfBirth != null
                      ? 'Date of Birth: ${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                      : 'Select Date of Birth',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Male'),
                    value: 'Male',
                  ),
                  DropdownMenuItem(
                    child: Text('Female'),
                    value: 'Female',
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedAccountType,
                onChanged: (value) {
                  setState(() {
                    _selectedAccountType = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Saving Account'),
                    value: 'Saving Account',
                  ),
                  DropdownMenuItem(
                    child: Text('Loan Account'),
                    value: 'Loan Account',
                  ),
                  DropdownMenuItem(
                    child: Text('Other Account'),
                    value: 'Other Account',
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getImage(ImageSource.camera); // Open camera
                },
                child: Text('Upload Aadhar Card Photo from Camera'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _getImage(ImageSource.gallery); // Open gallery
                },
                child: Text('Upload Aadhar Card Photo from Gallery'),
              ),
              SizedBox(height: 20),
              _aadharCardPhoto != null ? Image.file(_aadharCardPhoto!) : Container(),
              SizedBox(height: 20),
              _isCreatingAccount
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _createAccount,
                child: Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
