import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        backgroundColor: Colors.deepPurple,
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
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _animation = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
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
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data!.docs;
        var filteredUsers = users.where((userDoc) {
          final userData = userDoc.data() as Map<String, dynamic>;
          return userData['name'] != null && userData['name'] != 'Unknown';
        }).toList();
        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final userDoc = filteredUsers[index];
            final userData = userDoc.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopUpPage(userData: userData, userId: userDoc.id),
                    ),
                  );
                },
                child: SlideTransition(
                  position: _animation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(userData['name']),
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
  final String userId;
  final TextEditingController taskController = TextEditingController();

  PopUpPage({Key? key, required this.userData, required this.userId}) : super(key: key);

  Future<void> saveTask(BuildContext context, String taskName, String userName) async {
    try {
      final assignmentsRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('assignments');
      await assignmentsRef.add({
        'taskName': taskName,
        'dueDate': Timestamp.now(),
        'assignedBy': FirebaseAuth.instance.currentUser!.displayName,
      });
      Navigator.pop(context); // Close the dialog after task is saved
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning task: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = userData['name'] ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(title: Text('Task Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text("Assign task to $userName"),
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
                  hintText: 'Enter the task to assign',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () async {
                  final taskName = taskController.text;
                  if (taskName.isNotEmpty) {
                    await saveTask(context, taskName, userName);
                    taskController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a task name')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
