import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Query extends StatefulWidget {
  const Query({Key? key}) : super(key: key);

  @override
  _queryState createState() => _queryState();
}

class _queryState extends State<Query> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late final String uid;
  final queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    uid = user!.uid;
  }

  void storeQuery() {
    FirebaseFirestore.instance.collection('task').doc(uid).update({'query': queryController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
      title: Text('Query', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
        backgroundColor: Colors.deepPurple,
        
      ),
      body: StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance.collection('task').doc(uid).snapshots(),
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

    if (snapshot.connectionState == ConnectionState.active) {
      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[ Container(
                 child: Text("Task: ${data['task']
                //  .length > 100 ? data['task'].substring(0,50)+'...':data['task']
                 }", maxLines: 3,style: TextStyle(fontSize: 18),
    overflow: TextOverflow.ellipsis,),
                ),
                  Column(
                    children: <Widget>[        
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:queryController,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                  labelText: 'query',
                  hintText: 'Rasid the query for the task',
                                  ),
                                ),
                              ),
                      ElevatedButton(
                        onPressed: () {
                          storeQuery();
                          queryController.clear();
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Text("loading");
        },
      ),
    );
  }
}


