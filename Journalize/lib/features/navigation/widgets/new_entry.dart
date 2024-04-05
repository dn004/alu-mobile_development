import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController photoURLController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController moodController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("New Entry")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: photoURLController,
                decoration: InputDecoration(labelText: 'Photo URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a photo URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
      
                controller: moodController,
                decoration: InputDecoration(labelText: 'Mood',border:OutlineInputBorder(borderSide: BorderSide(width: 1)) ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mood';
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height/3.5),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      )),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  shadowColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      photoURLController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      moodController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      // Creating data or Sending data to firestore.
                      await FirebaseFirestore.instance
                          .collection('Entries')
                          .add({
                        'title': titleController.text,
                        'photoURL': photoURLController.text,
                        'description': descriptionController.text,
                        'mood': moodController.text,
                        'date': Timestamp.now(),
                        'userID': user.uid,
                      }).then((DocumentReference document) {});
                      titleController.clear();
                      photoURLController.clear();
                      descriptionController.clear();
                      moodController.clear();
                      dateController.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Entry added successfully')),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add entry')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User is not logged in')),
                    );
                  }
                },
                child: const Icon(Icons.done_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
