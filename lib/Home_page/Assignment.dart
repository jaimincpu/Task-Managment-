// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Assignment extends StatefulWidget {
//   const Assignment({Key? key}) : super(key: key);

//   @override
//   _AssignmentState createState() => _AssignmentState();
// }

// class _AssignmentState extends State<Assignment> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String _uid;
//   bool _isButtonPressed = false;

//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }

//   Future<void> _getUserData() async {
//     final User? user = _auth.currentUser;
//     _uid = user!.uid;
//   }

//   Future<void> _updateTaskStatus(String status) async {
//     await FirebaseFirestore.instance
//         .collection('task')
//         .doc(_uid)
//         .update({'statstask': status});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Assignment',
//           style: TextStyle(color: Colors.white),
//           textAlign: TextAlign.center,
//         ),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream:
//             FirebaseFirestore.instance.collection('task').doc(_uid).snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Text("Something went wrong");
//           }

//           if (snapshot.hasData && !snapshot.data!.exists) {
//             return Text("Document does not exist");
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           if (data['task'] == null) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(15.0),
//                     padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: const Color.fromARGB(255, 2, 31, 83)),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text("Task: not yet given wait for it",
//                         style: TextStyle(fontSize: 20)),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.all(15.0),
//                     padding: const EdgeInsets.all(3.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: const Color.fromARGB(255, 2, 31, 83)),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text("Task: ${data['task']}",
//                         style: TextStyle(fontSize: 20)),
//                   ),
//                   _getButtons(data),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _getButtons(Map<String, dynamic> data) {
//     if (data['statstask'] == null)
//     // || data['statstask'].isEmpty)
//     {
//       return Row(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               _updateTaskStatus("Approved");
//             },
//             child: Text("Approved"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _updateTaskStatus("Deny");
//             },
//             child: Text("Deny"),
//           ),
//           // ElevatedButton(
//           //   onPressed: () {
//           //     _updateTaskStatus("Completed");
//           //   },
//           //   child: Text("Completed"),
//           // ),
//         ],
//       );
//     } else if (data['statstask'] == 'Approved') {
//       return ElevatedButton(
//         onPressed: () {
//           _updateTaskStatus("Completed");
//         },
//         child: Text("Completed"),
//       );
//     } else {
//       return Container(); // No buttons are displayed for any other status
//     }
//   }
// }
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Hcommentpage.dart';

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final User? user = _auth.currentUser;
    setState(() {
      _uid = user?.uid;
    });
  }

  Future<void> _updateTaskStatus(String assignmentId, String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('assignments')
        .doc(assignmentId)
        .update({'statstask': status});
  }

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Assignment'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assignment',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_uid)
            .collection('assignments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text("No assignments found");
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final assignment = snapshot.data!.docs[index];
              final data = assignment.data() as Map<String, dynamic>;
              final assignmentId = assignment.id;
              return Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 2, 31, 83)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "Task: ${data['taskName']}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  _getButtons(data, assignmentId),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _getButtons(Map<String, dynamic> data, String assignmentId) {
    if (data['statstask'] == 'Completed') {
      return Container();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                _updateTaskStatus(assignmentId, "Hold");
              },
              child: Text("Hold"),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                _updateTaskStatus(assignmentId, "processing");
              },
              child: Text("processing"),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                _updateTaskStatus(assignmentId, "Completed");
              },
              child: Text("completed"),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Hcommentpage(
                      docId: assignmentId,
                      userId: _uid!,
                      taskName: data['taskName'],
                    ),
                  ),
                );
              },
              child: Text('Comment'),
            ),
          ),
        ],
      );
    }
  }
}
