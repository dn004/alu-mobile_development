import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:journalize/features/navigation/widgets/update_entry.dart';
import 'package:journalize/utils/constants.dart';

class Entries extends StatefulWidget {
  const Entries({Key? key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> entryStream;

  @override
  void initState() {
    super.initState();
    entryStream = FirebaseFirestore.instance
        .collection("Entries")
        .orderBy("date", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: entryStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // READING DATA FROM FIREBASE
          final entries = snapshot.data!.docs
              .where((doc) =>
                  doc.data()['userID'] ==
                  FirebaseAuth.instance.currentUser!.uid)
              .map((doc) => doc.data())
              .toList();

          return GridView.builder(
            itemCount: entries.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                        constraints: BoxConstraints(
                          maxHeight: MyConstants.screenHeight(context) * 0.9,
                        ),
                        child: Scaffold(
                          body: Center(
                            child: SizedBox(
                              height: MyConstants.screenHeight(context),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: MyConstants.screenWidth(context),
                                      child: Image.network(
                                        "${entries[index]["imageUrl"]}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: MyConstants.screenWidth(
                                              context,
                                            ),
                                            child: Text(
                                              "${entries[index]["title"]}",
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${entries[index]["description"]}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    entries[index]["date"]
                                        .toDate()
                                        .toString()
                                        .substring(0, 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    context: context,
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Options"),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              ListTile(
                                //UPDATING DATA FROM FIREBASE
                                leading: Icon(Icons.edit),
                                title: Text('Edit Entry'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateEntryPage(
                                          entryData: entries[index],
                                          entryID:
                                              snapshot.data!.docs[index].id),
                                    ),
                                  );
                                },
                              ),
                              ListTile(
                                //DELETING DATA FROM FIREBASE
                                leading: Icon(Icons.delete),
                                title: Text('Delete Entry'),
                                onTap: () {
                                  Navigator.pop(context);
                                  FirebaseFirestore.instance
                                      .collection('Entries')
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amber,
                      ),
                      width: MyConstants.screenWidth(context) / 2.3,
                      height: MyConstants.screenHeight(context),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: CustomImageWidget(
                                imageUrl: entries[index]["photoURL"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            width: MyConstants.screenWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${entries[index]["title"]}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final BoxFit fit;

  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      print(imageUrl);
      return Icon(Icons.error_outline_rounded);
    }

    return Image.network(
      imageUrl!,
      fit: fit,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        print(imageUrl);
        return Icon(Icons.error_outline);
      },
    );
  }
}
