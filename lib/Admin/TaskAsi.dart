// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// Widget iconShow(String? statstask) {
//   if (statstask == "Approved") {
//     return Icon(
//       Icons.check_circle_rounded,
//       color: Color.fromARGB(255, 0, 255, 102),
//     );
//   } else if (statstask == "Deny") {
//     return Icon(
//       Icons.cancel,
//       color: Color.fromARGB(255, 182, 9, 9),
//     );
//   } else if(statstask == "Completed"){
//    return Icon(
//       Icons.verified,
//       color: Color.fromARGB(255, 9, 101, 182),
//     );
//   } else {
//   return Container(); // Return an empty container if status is not "Approve" or "Deny"
//   }
// }

// class TAskAsi extends StatefulWidget {
//   const TAskAsi({Key? key}) : super(key: key);

//   @override
//   State<TAskAsi> createState() => _TAskAsiState();
// }

// class _TAskAsiState extends State<TAskAsi> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("List of task"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: TaskList(),
//     );
//   }
// }

// class TaskList extends StatefulWidget {
//   const TaskList({Key? key}) : super(key: key);

//   @override
//   State<TaskList> createState() => _TaskListState();
// }

// class _TaskListState extends State<TaskList> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('task').snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         return ListView.builder(
//           itemCount: snapshot.data!.docs.length,
//           itemBuilder: (context, index) {
//             DocumentSnapshot document = snapshot.data!.docs[index];
//             final userData = document.data() as Map<String, dynamic>;

//             // Check if the name, task, and status fields exist in the document
//             if (userData.containsKey('name') &&
//                 userData.containsKey('task') &&
//                 userData.containsKey('statstask')) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => TaskPopUpPage(
//                         docId: document.id,
//                       ), // Pass the document ID to PopUpPage
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: EdgeInsets.all(8.0),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.grey,
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "name: ${userData['name']}",
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               "task: ${userData['task']}",
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: iconShow(userData['statstask']), // Use the iconShow function here
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               return Container(); // Return an empty container if the name, task, or status field does not exist
//             }
//           },
//         );
//       },
//     );
//   }
// }

// class TaskPopUpPage extends StatefulWidget {
//   final String docId;
//   const TaskPopUpPage({Key? key, required this.docId}) : super(key: key);

//   @override
//   _TaskPopUpPageState createState() => _TaskPopUpPageState();
// }

// class _TaskPopUpPageState extends State<TaskPopUpPage> {
//   final _controller = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     DocumentSnapshot document =
//         await _firestore.collection('task').doc(widget.docId).get();
//     setState(() {
//       _controller.text = document['task'];
//     });
//   }

//   Future<void> updateData() async {
//     if (_formKey.currentState!.validate()) {
//       await _firestore.collection('task').doc(widget.docId).update({
//         'task': _controller.text,
//         'statstask': 'Approved',
//       });
//     }
//   }

//   Future<void> deleteField() async {
//     await _firestore.collection('task').doc(widget.docId).update({
//       'task': FieldValue.delete(),
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Field Deleted'),
//         ),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting field: $error'),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Update Task')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 controller: _controller,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Enter text',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter some text';
//                   }
//                   return null;
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         updateData();
//                         Navigator.pop(context);
//                       },
//                       child: Text('Update'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         deleteField();
//                         Navigator.pop(context);
//                       },
//                       child: Text('Delete'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskAsi extends StatefulWidget {
  const TaskAsi({super.key});

  @override
  State<TaskAsi> createState() => _TaskAsiState();
}

class _TaskAsiState extends State<TaskAsi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Get the current logged-in user ID
          final currentUser = FirebaseAuth.instance.currentUser;
          final currentUserId = currentUser?.uid;

          // Filter out the current logged-in user
          var users = snapshot.data!.docs
              .where((doc) => doc.id != currentUserId)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var userData = user.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(userData['name'] ?? 'Unknown'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssignmentList(userId: user.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AssignmentList extends StatelessWidget {
  final String userId;

  AssignmentList({required this.userId});

  Widget iconShow(String? statstask) {
    if (statstask == 'Hold') {
      return Icon(Icons.motion_photos_pause,
          color: Color.fromARGB(255, 216, 14, 14));
    } else if (statstask == 'processing') {
      return Icon(Icons.emoji_flags_sharp,
          color: Color.fromARGB(255, 18, 206, 62));
    } else if (statstask == 'Completed') {
      return Icon(Icons.check_box, color: Color.fromARGB(255, 9, 145, 224));
    }
    // No need for an else block
    return Icon(Icons.error_outline, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('assignments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var assignments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              var assignment = assignments[index];
              var assignmentData = assignment.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(assignmentData['taskName'] ?? 'No Task Name'),
                leading: iconShow(
                    assignmentData['statstask']), // Use leading for the icon
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TaskPopUpPage(docId: assignment.id, userId: userId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TaskPopUpPage extends StatefulWidget {
  final String docId;
  final String userId;

  TaskPopUpPage({required this.docId, required this.userId});

  @override
  _TaskPopUpPageState createState() => _TaskPopUpPageState();
}

class _TaskPopUpPageState extends State<TaskPopUpPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  String taskName = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DocumentSnapshot document = await _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('assignments')
        .doc(widget.docId)
        .get();
    setState(() {
      _controller.text = document['taskName'];
      taskName = document['taskName'];
    });
  }

  Future<void> updateData() async {
    if (_formKey.currentState!.validate()) {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('assignments')
          .doc(widget.docId)
          .update({
        'taskName': _controller.text,
      });
      Navigator.pop(context);
    }
  }

  Future<void> deleteField() async {
    await _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('assignments')
        .doc(widget.docId)
        .delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter text',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some task';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: updateData,
                      child: Text('Update'),
                    ),
                    ElevatedButton(
                      onPressed: deleteField,
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // Add a border
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional: Rounded corners
                ),
                padding: const EdgeInsets.all(8.0),
                child: CommentSection(
                  docId: widget.docId,
                  userId: widget.userId,
                  taskName: taskName,
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

// commesnt section
class CommentSection extends StatefulWidget {
  final String docId;
  final String userId;
  final String taskName;

  CommentSection({
    required this.docId,
    required this.userId,
    required this.taskName,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _commentController = TextEditingController();
  final _replyController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  User? user;
  String Username = 'Anonymous';
  String? replyingToCommentId;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserName();
  }

 Future<void> fetchUserName() async {
  if (user != null) {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
    setState(() {
      Username = userDoc['Username'] ?? 'Anonymous'; // Ensure this is 'Username'
    });
  }
}

  Future<void> addComment() async {
    if (_commentController.text.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('assignments')
          .doc(widget.docId)
          .collection('comments')
          .add({
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user!.uid,
        'Username': Username,
      });
      _commentController.clear();
    }
  }

  Future<void> addReply(String commentId) async {
    if (_replyController.text.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(widget.userId)
          .collection('assignments')
          .doc(widget.docId)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .add({
        'reply': _replyController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': user!.uid,
        'Username': Username,
      });
      _replyController.clear();
      setState(() {
        replyingToCommentId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Task: ${widget.taskName}', style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter comment',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: addComment,
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(widget.userId)
                  .collection('assignments')
                  .doc(widget.docId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var comment = comments[index];
                    var commentData = comment.data() as Map<String, dynamic>;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(commentData['Username'] ?? 'Anonymous'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(commentData['comment'] ?? 'No Comment'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    commentData['timestamp'] != null
                                        ? (commentData['timestamp'] as Timestamp).toDate().toString()
                                        : '',
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        replyingToCommentId = comment.id;
                                      });
                                    },
                                    child: Text(
                                      'Reply',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (replyingToCommentId == comment.id)
                          Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _replyController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter reply',
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: () => addReply(comment.id),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('users')
                              .doc(widget.userId)
                              .collection('assignments')
                              .doc(widget.docId)
                              .collection('comments')
                              .doc(comment.id)
                              .collection('replies')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            }

                            var replies = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: replies.length,
                              itemBuilder: (context, index) {
                                var reply = replies[index];
                                var replyData = reply.data() as Map<String, dynamic>;
                                return Padding(
                                  padding: EdgeInsets.only(left: 32.0),
                                  child: ListTile(
                                    title: Text(replyData['Username'] ?? 'Anonymous'),
                                    subtitle: Text(replyData['reply'] ?? 'No Reply'),
                                    trailing: Text(
                                      replyData['timestamp'] != null
                                          ? (replyData['timestamp'] as Timestamp).toDate().toString()
                                          : '',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
