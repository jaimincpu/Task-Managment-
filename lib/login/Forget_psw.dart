import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgetpsw extends StatefulWidget {
  const forgetpsw({Key? key}) : super(key: key);

  @override
  State<forgetpsw> createState() => _forgetpswState();
}

class _forgetpswState extends State<forgetpsw> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> pswreset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
                "Enter your registered email address here to set a password reset link"),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 10),
            MaterialButton(
              onPressed: pswreset,
              child: Text("Reset Password"),
              color: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}
