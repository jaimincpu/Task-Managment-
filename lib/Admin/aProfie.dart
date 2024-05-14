
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/login/login_page.dart';

class AProfile extends StatefulWidget {
  const AProfile({Key? key}) : super(key: key);

  @override
  State<AProfile> createState() => _AProfileState();
}

class _AProfileState extends State<AProfile> {
  late User? _user;
  late Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      // Retrieve user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        _userData = userData.data()!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user != null
          ? ListView(
              children: [
                Center(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                )
                              ],
                              shape: BoxShape.circle,
                             image: DecorationImage(
      fit: BoxFit.cover,
      image: NetworkImage(
        'https://www.hdwallpapers.in/download/waterfalls_pouring_on_river_between_green_trees_plants_bushes_hd_nature-HD.jpg',
      ),
      onError: (exception, stackTrace) {
        print('Image loading failed');
        // You can return a placeholder image or handle the error in another way
      },
    ),

                              ),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Username: ${_userData['Username']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Name: ${_userData['name']}'),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Email: ${_user!.email}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Phone No: ${_userData['phoneNo']}'),
                              ),
                            
                                Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                               onPressed: () async {
                       await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
                           },
                          child: Text('Logout'),
                        ),
                      ),
                            ],
                          ),
                        ),
                      ],
                      
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
