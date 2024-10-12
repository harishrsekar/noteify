import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('notes').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['courseName']),
                subtitle: Text("Uploaded by: ${doc['username']}"),
                leading: Image.network(doc['imageUrl']),
                trailing: doc['userId'] == FirebaseAuth.instance.currentUser!.uid
                    ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteNote(doc.id),
                )
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _deleteNote(String docId) async {
    await FirebaseFirestore.instance.collection('notes').doc(docId).delete();
  }
}
