// lib/models/note.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String userId;
  final String note;
  final String imageUrl;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.note,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    return Note(
      id: doc.id,
      userId: doc['userId'] ?? '',
      note: doc['note'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
    );
  }
}
