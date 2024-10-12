// lib/screens/note_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart'; // Adjust the path according to your folder structure

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  Future<void> deleteNote(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('notes').doc(note.id).delete();
      print('Note deleted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note deleted successfully')),
      );
      Navigator.pop(context); // Navigate back after deletion
    } catch (e) {
      print('Error deleting note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => deleteNote(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.note, // Displaying the note text
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            note.imageUrl.isNotEmpty
                ? Image.network(note.imageUrl) // Display the image if available
                : Container(),
            SizedBox(height: 16),
            Text(
              'Created At: ${note.createdAt.toLocal().toString()}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
