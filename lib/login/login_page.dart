import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Home_page/homepage.dart';
import 'package:flutter_application_1/login/Forget_psw.dart';
import 'package:flutter_application_1/login/SignUP.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            height: screenHeight / 2,
            width: screenWidth / 2,
            color: Colors.lightBlue,
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'username',
                          hintText: 'Enter your username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
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
                      Center(
                        child: Row(
                          children: [
                            ElevatedButton(
                              child: Text('LogIN'),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  try {
                                    final user =
                                        await _auth.signInWithEmailAndPassword(
                                      email: _email,
                                      password: _password,
                                    );
                                    if (user != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Login Successful'),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => homepage(),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                }
                              },
                            ),
                            ElevatedButton(
                              child: Text('SignUp'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => forgetpsw(),
                            ),
                          );
                        },
                        child: Text(
                          'Forget password',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
