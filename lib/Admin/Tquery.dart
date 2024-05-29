// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';

// // class Tquery extends StatefulWidget {
// //   const Tquery({super.key});

// //   @override
// //   State<Tquery> createState() => _TqueryState();
// // }

// // class _TqueryState extends State<Tquery> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Query List'),
// //         backgroundColor: Colors.deepPurple,
// //       ),
// //       body: QueryList(),
// //     );
// //   }
// // }

// // class QueryList extends StatefulWidget {
// //   @override
// //   _QueryListState createState() => _QueryListState();
// // }

// // class _QueryListState extends State<QueryList>
// //     with SingleTickerProviderStateMixin {
// //   late AnimationController _controller;
// //   late Animation<Offset> _animation;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller =
// //         AnimationController(duration: const Duration(seconds: 1), vsync: this);
// //     _animation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
// //         .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
// //     _controller.forward();
// //   }

// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder(
// //       stream: FirebaseFirestore.instance
// //           .collection('task')
// //           .where('query', isNotEqualTo: null)
// //           // .orderBy('updateCounter', descending: false)
// //           .snapshots(),
// //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
// //         if (snapshot.hasError) {
// //           return Center(
// //             child: Text('Error: ${snapshot.error}'),
// //           );
// //         }

// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return Center(
// //             child: CircularProgressIndicator(),
// //           );
// //         }

// //         final users = snapshot.data!.docs;

// //         return ListView.builder(
// //           itemCount: users.length,
// //           itemBuilder: (context, index) {
// //             final userDoc = users[index];
// //             final userData = userDoc.data() as Map<String, dynamic>;

// //             return Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: InkWell(
// //                 onTap: () {
// //                   Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                   builder: (context) => queryPopUpPage(docId: userDoc.id),
// //                    ),
// //                  );
// //                 },
// //                 child: SlideTransition(
// //                   position: _animation,
// //                   child: Container(
// //                     decoration: BoxDecoration(
// //                       border: Border(
// //                         bottom: BorderSide(width: 1, color: Colors.grey),
// //                       ),
// //                     ),
// //                     padding: EdgeInsets.symmetric(vertical: 8.0),
// //                     child: ListTile(
// //                       title: Text(userData['name'] ?? 'Unknown'),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// // class queryPopUpPage extends StatefulWidget {
// //   final String docId;

// //   const queryPopUpPage({Key? key, required this.docId}) : super(key: key);

// //   @override
// //   State<queryPopUpPage> createState() => _queryPopUpPageState();
// // }

// // class _queryPopUpPageState extends State<queryPopUpPage> {
// //   Future<DocumentSnapshot> fetchData() async {
// //     return await FirebaseFirestore.instance.collection('task').doc(widget.docId).get();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Task Releted Query'),
// //       ),
// //       body: FutureBuilder<DocumentSnapshot>(
// //         future: fetchData(),
// //         builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(child: CircularProgressIndicator());
// //           }

// //           if (snapshot.hasError) {
// //             return Center(child: Text("Error: ${snapshot.error}"));
// //           }

// //           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
// //           return Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               children: <Widget>[
// //                 Text("${data['query']}"),
// //                 Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: ElevatedButton(
// //                     child: Text('Back'),
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: Colors.blueAccent,
// //                     ),
// //                     onPressed: () {
// //                       Navigator.pop(context);
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Chat extends StatefulWidget {
//   const Chat({super.key});

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Query Chat')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('users').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) return const Text('Error');
//           if (snapshot.connectionState == ConnectionState.waiting) return const Text('Loading');
//           return ListView(
//             children: snapshot.data!.docs.map((doc) {
//               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//               String email = data['email'] ?? '';
//               String uid = data['uid'] ?? '';
//               return _auth.currentUser?.email != email
//                   ? ListTile(
//                       title: Text(email),
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatPage(
//                             receiverUserEmail: email,
//                             receiverUserID: uid,
//                           ),
//                         ),
//                       ),
//                     )
//                   : Container();
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// class ChatPage extends StatefulWidget {
//   final String receiverUserEmail;
//   final String receiverUserID;

//   const ChatPage({
//     super.key,
//     required this.receiverUserEmail,
//     required this.receiverUserID,
//   });

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
//       _messageController.clear();
//     }
//   }

//   Widget _buildMessageList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _chatService.getMessages(_firebaseAuth.currentUser!.uid, widget.receiverUserID),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//         if (snapshot.connectionState == ConnectionState.waiting) return const Text('Loading...');
//         return ListView(
//           reverse: true,
//           children: snapshot.data!.docs.map((doc) {
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             String senderId = data['senderId'] ?? '';
//             String senderEmail = data['senderEmail'] ?? '';
//             String message = data['message'] ?? '';
//             bool isCurrentUser = senderId == _firebaseAuth.currentUser!.uid;
//             return Container(
//               alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Text(senderEmail),
//                   const SizedBox(height: 5),
//                   ChatBubble(message: message),
//                 ],
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildMessageInput() {
//     return Row(
//       children: [
//         Expanded(
//           child: MyTextField(
//             controller: _messageController,
//             hintText: 'Enter message',
//             obscureText: false,
//           ),
//         ),
//         IconButton(
//           onPressed: sendMessage,
//           icon: const Icon(Icons.send, size: 30),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverUserEmail)),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }
// }

// class ChatService with ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   Stream<QuerySnapshot> getMessages(String senderUserID, String receiverUserID) {
//     String chatId = _getChatId(senderUserID, receiverUserID);
//     return _firebaseFirestore
//         .collection('messages')
//         .doc(chatId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots();
//   }

//   Future<void> sendMessage(String receiverUserID, String message) async {
//     String chatId = _getChatId(_firebaseAuth.currentUser!.uid, receiverUserID);
//     final Map<String, dynamic> chatMessage = {
//       'senderId': _firebaseAuth.currentUser!.uid,
//       'senderEmail': _firebaseAuth.currentUser!.email ?? '',
//       'receiverId': receiverUserID,
//       'receiverEmail': _firebaseAuth.currentUser!.email ?? '', // This line has been changed to correctly set the receiverEmail
//       'message': message,
//       'timestamp': Timestamp.now(),
//       'chatId': chatId,
//     };
//     await _firebaseFirestore.collection('messages').doc(chatId).collection('messages').add(chatMessage);
//   }

//   String _getChatId(String userId1, String userId2) {
//     return userId1.hashCode <= userId2.hashCode ? '$userId1-$userId2' : '$userId2-$userId1';
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   const ChatBubble({super.key, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(30),
//       ),
//       child: Text(message, style: const TextStyle(fontSize: 15)),
//     );
//   }
// }

// class MyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final bool obscureText;
//   const MyTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//       ),
//       obscureText: obscureText,
//     );
//   }
// }
