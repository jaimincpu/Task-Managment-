import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase/firebase_options.dart';
import 'package:flutter_application_1/login/login_page.dart';
import 'package:flutter_application_1/screen/splashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Flutter fire',
      home:SplashScreen(
         child: LoginPage(),
      )
    );
  }
}
