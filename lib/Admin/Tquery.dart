import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tquery extends StatefulWidget {
  const Tquery({super.key});

  @override
  State<Tquery> createState() => _TqueryState();
}

class _TqueryState extends State<Tquery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Query List'),
      ),
      body: QueryList(),
    );
  }
}

class QueryList extends StatefulWidget {
  @override
  _QueryListState createState() => _QueryListState();
}

class _QueryListState extends State<QueryList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
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
      stream: FirebaseFirestore.instance
          .collection('task')
          .where('query', isNotEqualTo: null)
          // .orderBy('updateCounter', descending: false)
          .snapshots(),
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
                  builder: (context) => queryPopUpPage(docId: userDoc.id),
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
class queryPopUpPage extends StatefulWidget {
  final String docId;

  const queryPopUpPage({Key? key, required this.docId}) : super(key: key);

  @override
  State<queryPopUpPage> createState() => _queryPopUpPageState();
}

class _queryPopUpPageState extends State<queryPopUpPage> {
  Future<DocumentSnapshot> fetchData() async {
    return await FirebaseFirestore.instance.collection('task').doc(widget.docId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Releted Query'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text("${data['query']}"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
