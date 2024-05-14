import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _animation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final userData = userDoc.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopUpPage(userData: userData, docId: userDoc.id), // Pass the document ID to PopUpPage
                    ),
                  );
                },
                child: SlideTransition(
                  position: _animation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(userData['name'] ?? 'Unknown'),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PopUpPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String docId; // Add a new parameter for the document ID

  final taskController = TextEditingController();

  PopUpPage({Key? key, required this.userData, required this.docId }) : super(key: key); // Include the document ID in the constructor

  @override
  Widget build(BuildContext context) {
    final userName = userData['name'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Assignment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Assign task to $userName "),
            // , (UID: $docId)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: taskController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: 'Task',
                  hintText: 'Enter The task to Assign',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('task')
                      .doc(docId)
                      .set({
                    'task': taskController.text,
                    'name': userName,
                  });

                  taskController.clear();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
