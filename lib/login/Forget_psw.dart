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
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('link has been set check your inbox'),
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Enter your registered email address here to get a password reset link on your email"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
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
