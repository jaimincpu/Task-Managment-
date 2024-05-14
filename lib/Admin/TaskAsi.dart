import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TAskAsi extends StatefulWidget {
  const TAskAsi({Key? key}) : super(key: key);

  @override
  State<TAskAsi> createState() => _TAskAsiState();
}

class _TAskAsiState extends State<TAskAsi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of task"),
      ),
      body: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('task').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskPopUpPage(
                          docId: document.id,
                        ), // Pass the document ID to PopUpPage
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(
                        8.0), // add some margin around each container
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "name: ${document['name']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "task: ${document['task']}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.check_circle, // this is the approve icon
                              color: Color.fromARGB(255, 0, 255, 102),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}

class TaskPopUpPage extends StatefulWidget {
  final String docId;
  const TaskPopUpPage({Key? key, required this.docId}) : super(key: key);

  @override
  _TaskPopUpPageState createState() => _TaskPopUpPageState();
}

class _TaskPopUpPageState extends State<TaskPopUpPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DocumentSnapshot document =
        await _firestore.collection('task').doc(widget.docId).get();
    setState(() {
      _controller.text = document['task'];
    });
  }

  Future<void> updateData() async {
    if (_formKey.currentState!.validate()) {
      await _firestore.collection('task').doc(widget.docId).update({
        'task': _controller.text,
      });
    }
  }

  Future<void> deleteField() async {
    await _firestore.collection('task').doc(widget.docId).update({
      'task': FieldValue.delete(),
    }).then((_) {
      print('Field Deleted');
    }).catchError((error) {
      print('Error deleting field: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
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
                    return 'Please enter some text';
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
                      onPressed: () {
                   updateData();
                     Navigator.pop(context);
                       },
                      child: Text('Update'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                          deleteField();
                            Navigator.pop(context);
                             },                
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
