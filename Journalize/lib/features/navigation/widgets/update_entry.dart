import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateEntryPage extends StatefulWidget {
  final Map<String, dynamic> entryData;
  final String entryID;

  const UpdateEntryPage({Key? key, required this.entryData, required this.entryID}) : super(key: key);

  @override
  _UpdateEntryPageState createState() => _UpdateEntryPageState();
}

class _UpdateEntryPageState extends State<UpdateEntryPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.entryData['title'];
    _descriptionController.text = widget.entryData['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Entry'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Update entry details in Firestore
                FirebaseFirestore.instance
                    .collection('Entries')
                    .doc(widget.entryID)
                    .update({
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                }).then((value) {
                  // Navigate back to previous screen
                  Navigator.pop(context);
                }).catchError((error) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update entry')),
                  );
                });
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
