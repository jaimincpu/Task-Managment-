import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'login_page.dart';


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
  String? Username,user;

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
          'User': 'Employ',

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

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SignUp",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Username
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Username',
                            hintText: 'Enter your username',
                          ),
                          validator: (input) =>
                              input!.isEmpty ? 'Please enter your username' : null,
                          onSaved: (input) => Username = input,
                        ),
                      ),
                      

                      // Name
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Name',
                            hintText: 'Enter your name',
                          ),
                          validator: (input) =>
                              input!.isEmpty ? 'Please enter your name' : null,
                          onSaved: (input) => name = input,
                        ),
                      ),
                  
                      // Email
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                          ),
                          validator: (input) => !input!.contains('@')
                              ? 'Please enter a valid email'
                              : null,
                          onSaved: (input) => email = input,
                        ),
                      ),
                  
                      // Phone number
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Phone No',
                            hintText: 'Enter your phone number',
                          ),
                          validator: (input) => input!.isEmpty
                              ? 'Please enter your phone number and should be an min 10 number'
                              : null,
                          onSaved: (input) => phoneNo = input,
                        ),
                      ),
                  
                      // Password
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                          validator: (input) => input!.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                          onSaved: (input) => password = input,
                          obscureText: true,
                        ),
                      ),
                  
                      // Confirm Password
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Confirm Password',
                            hintText: 'Enter your password again',
                          ),
                          validator: (input) =>
                              input == password ? 'Passwords do not match' : null,
                          obscureText: true,
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: ElevatedButton(
                                  child: Text('Back'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: ElevatedButton(
                                  child: Text('Register'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent
                                  ),
                                  onPressed: () {
                                           _register();
                                            Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder: (context) => LoginPage()),
                                            );
                                          },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
