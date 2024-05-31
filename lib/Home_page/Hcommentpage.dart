import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Hcommentpage extends StatefulWidget {
  final String docId;
  final String userId;
  final String taskName;

  Hcommentpage({
    required this.docId,
    required this.userId,
    required this.taskName,
  });

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<Hcommentpage> {
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
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        Username =
            userDoc['Username'] ?? 'Anonymous'; // Ensure this is 'Username'
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),  backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 8, 82, 221), // Border color
              width: 3, // Border width
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Task: ${widget.taskName}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      commentData['timestamp'] != null
                                          ? (commentData['timestamp']
                                                  as Timestamp)
                                              .toDate()
                                              .toString()
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
                                  var replyData =
                                      reply.data() as Map<String, dynamic>;
                                  return Padding(
                                    padding: EdgeInsets.only(left: 32.0),
                                    child: ListTile(
                                      title: Text(
                                          replyData['Username'] ?? 'Anonymous'),
                                      subtitle: Text(
                                          replyData['reply'] ?? 'No Reply'),
                                      trailing: Text(
                                        replyData['timestamp'] != null
                                            ? (replyData['timestamp']
                                                    as Timestamp)
                                                .toDate()
                                                .toString()
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
      ),
    );
  }
}
