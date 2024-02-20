import 'package:flutter/material.dart';

class Entries extends StatelessWidget {
   Entries({super.key});
  
  final List<Map> entries = List.generate(5, (index) => {"id": index, "name": "Entry ${index + 1}"});


  @override
  Widget build(BuildContext context) {
    return  Center(
      child: GridView.builder(
        itemCount: entries.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 1, mainAxisSpacing: 1),
         itemBuilder:(BuildContext, index ){
          return Container(
            color: Colors.blue,
            child: Center(child: Text("${entries[index]["name"]}")),
          );
         } ),
    );
  }
}