import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final String uid;
  bool isButtonPressed = false; 

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid;
    getUserData();
  }

  void getUserData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("task").doc(firebaseUser!.uid).get().then((value){
      print(value.data());
    });
  }

  void updateTaskStatus(String status) {
    FirebaseFirestore.instance.collection('task').doc(uid).update({'statstask': status});
     setState(() {
      isButtonPressed = true; // Set the state variable to true when the button is pressed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Assignment'))),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('task').doc(uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: <Widget>[
                Text("Task: ${data['task']}"),
                if (!isButtonPressed) // Only show the buttons if they haven't been pressed
            Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    updateTaskStatus("Approved");
                  },
                  child: Text("Approve"),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateTaskStatus("Deny");
                  },
                  child: Text("Deny"),
                ),
              ],
            ),
              ]
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}
