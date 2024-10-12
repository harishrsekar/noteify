// lib/widgets/note_tile.dart

import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;

  NoteTile({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: note.imageUrl.isNotEmpty
            ? Image.network(
          note.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : null,
        title: Text(note.note),
        subtitle: Text(
            '${note.createdAt.toLocal()}'.split(' ')[0]), // Display date
      ),
    );
  }
}
