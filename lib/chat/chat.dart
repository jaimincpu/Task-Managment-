// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/chat/ChatPage.dart';

// class Chat extends StatefulWidget {
//   const Chat({Key? key});

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Stream<QuerySnapshot<Map<String, dynamic>>> _getUserStream() {
//     // Query to exclude the current user
//     return FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isNotEqualTo: _auth.currentUser?.email)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat Users')),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: _getUserStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(child: Text('Error fetching data.'));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) {
//               final doc = snapshot.data!.docs[index];
//               final data = doc.data() as Map<String, dynamic>;
//               final email = data['email'] as String?;
//               final username = data['username'] as String?;

//               return ListTile(
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                Text(username ?? 'Unknown User'),
//                     Text('UID: ${doc.id}'), // Using the document ID as UID
//                   ],
//                 ),
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatPage(
//                       receiverEmail: email ?? '',
//                       receiverID: doc.id, // Pass the document ID as the UID
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat/ChatPage.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> _getUserStream() {
    // Query to exclude the current user
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isNotEqualTo: _auth.currentUser?.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Users'), backgroundColor: Colors.deepPurple,),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
               final email = data['email'] as String?;
              final Username = data['Username'] as String?; // Assuming you have a 'username' field

              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Username ?? 'Unknown User'),
                    Text('UID: ${doc.id}'), // Using the document ID as UID
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverEmail: data['email'] as String? ?? '',
                      receiverID: doc.id, // Pass the document ID as the UID
                       username: Username,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
