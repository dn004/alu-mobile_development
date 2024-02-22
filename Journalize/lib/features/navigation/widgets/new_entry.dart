import 'package:flutter/material.dart';

class NewEntry extends StatelessWidget {
  const NewEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Entry"),),
      body: const Center(child:  Text("Your Entry goes here!")),
    );
  }
}