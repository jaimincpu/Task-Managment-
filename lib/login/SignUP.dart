import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? email, password, name, phoneNo;
  String? Username;

  // Function to handle registration
  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Use the email and password from the state variables
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: email!, password: password!);
        // After the user is created, store the additional details in Firestore
        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'phoneNo': phoneNo,
          'Username': Username,
        });
          Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.lightBlue,
          child: Column(
            children: [
              Text(
                "SignUp",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Column(
                  children: [
                    // Username
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Username',
                        hintText: 'Enter your username',
                      ),
                      validator: (input) =>
                          input!.isEmpty ? 'Please enter your username' : null,
                      onSaved: (input) => Username = input,
                    ),

                    // Name
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter your name',
                      ),
                      validator: (input) =>
                          input!.isEmpty ? 'Please enter your name' : null,
                      onSaved: (input) => name = input,
                    ),

                    // Email
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      validator: (input) => !input!.contains('@')
                          ? 'Please enter a valid email'
                          : null,
                      onSaved: (input) => email = input,
                    ),

                    // Phone number
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Phone No',
                        hintText: 'Enter your phone number',
                      ),
                      validator: (input) => input!.isEmpty
                          ? 'Please enter your phone number and should be an min 10 number'
                          : null,
                      onSaved: (input) => phoneNo = input,
                    ),

                    // Password
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                      validator: (input) => input!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                      onSaved: (input) => password = input,
                      obscureText: true,
                    ),

                    // Confirm Password
                    TextFormField(
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Confirm Password',
                        hintText: 'Enter your password again',
                      ),
                      validator: (input) =>
                          input == password ? 'Passwords do not match' : null,
                      obscureText: true,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('Back'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: Text('Register'),
                          onPressed: _register,
                        ),
                      ],
                    ),
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
