import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Admin/AdminPanel.dart';
import 'package:flutter_application_1/Home_page/HomePanel.dart';

import 'Forget_psw.dart';
import 'SignUP.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Login")),
        backgroundColor: Colors.blue,
      ),
      body: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

Future<void> checkUserRole(UserCredential userCredential, BuildContext context) async {
  DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    if (data['User'] == 'Employ') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeDash()));
    } else if (data['User'] == 'Admin') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
    }
  } else {
    print('User does not exist');
  }
}


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: 'Email',
                    hintText: 'Enter your Email',

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: 'password',
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => forgetpsw(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forget password',
                      style: TextStyle(fontSize: 14),

                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          child: Text('LogIN'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent
                          ),
                          onPressed: () async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (userCredential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful'),
          ),
        );
        checkUserRole(userCredential, context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
},

                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: ElevatedButton(
                          child: Text('SignUp'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
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
    );
  }
}
