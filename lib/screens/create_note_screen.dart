// lib/screens/create_note_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/note_service.dart';
import '../services/image_service.dart';

class CreateNoteScreen extends StatefulWidget {
  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  final NoteService _noteService = NoteService();
  final ImageService _imageService = ImageService();
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _pickAndUploadImage() async {
    File? image = await _imageService.pickImage();
    if (image != null) {
      setState(() {
        _isLoading = true;
      });
      String? url = await _imageService.uploadImage(image);
      setState(() {
        _imageUrl = url;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Note cannot be empty')));
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }

    await _noteService.addNote(
        user.uid, _noteController.text.trim(), _imageUrl ?? '');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Note')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true),
                maxLines: 5,
              ),
              SizedBox(height: 10),
              _isLoading
                  ? CircularProgressIndicator()
                  : _imageUrl != null
                  ? Image.network(
                _imageUrl!,
                height: 200,
              )
                  : Container(),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickAndUploadImage,
                icon: Icon(Icons.image),
                label: Text('Upload Image'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text('Save Note'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width
                ),
              ),
            ],
          ),
        ));
  }
}
