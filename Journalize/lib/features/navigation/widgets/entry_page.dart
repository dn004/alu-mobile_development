import 'package:flutter/material.dart';
import 'package:journalize/utils/constants.dart';

class Entries extends StatelessWidget {
  Entries({super.key});

  final List<Map> entries =
      List.generate(5, (index) => {"id": index, "name": "Entry ${index + 1}"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
          itemCount: entries.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(
                        constraints: BoxConstraints(
                            maxHeight: MyConstants.screenHeight(context) * 0.9),
                        child: Scaffold(
                          body:
                              Center(child: Text("${entries[index]["name"]}")),
                        ));
                  },
                  context: context,
                );
              },
              child: Container(
                child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.amber),
                        width: MyConstants.screenWidth(context) / 2.3,
                        height: MyConstants.screenHeight(context),
                        child: Column(
                          children: [
                            Expanded(
                                child:
                                    Text("Picture ${entries[index]["name"]}")),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                width: MyConstants.screenWidth(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text("${entries[index]["name"]} title"),
                                )),
                          ],
                        ))),
              ),
            );
          }),
    );
  }
}
