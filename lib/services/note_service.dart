// lib/services/note_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final CollectionReference _noteCollection =
  FirebaseFirestore.instance.collection('notes');

  // Add a new note
  Future<void> addNote(String userId, String noteText, String imageUrl) async {
    await _noteCollection.add({
      'userId': userId,
      'note': noteText,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });
  }

  // Get notes for a specific user
  Stream<QuerySnapshot> getUserNotes(String userId) {
    return _noteCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
