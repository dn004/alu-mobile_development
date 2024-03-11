import 'package:flutter/material.dart';
import 'package:journalize/features/authentication/authentication.dart';
import 'package:journalize/features/navigation/widgets/entry_page.dart';
import 'package:journalize/features/navigation/widgets/mood_page.dart';
import 'package:journalize/features/navigation/widgets/new_entry.dart';
import 'package:journalize/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final pages = [Entries(), MoodPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Authentication()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Icon(Icons.book_outlined)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: pages[_selectedIndex],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Journalize"),
              ),
              ListTile(
                title: const Text('Journalize'),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SafeArea(
            child: Container(
              width: MyConstants.screenWidth(context),
              height: 100,
              color: Colors.transparent,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.amber,
                unselectedItemColor: Colors.grey,
                iconSize: 30,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    label: 'Entries',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pie_chart_outline_rounded),
                    label: 'Mood',
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEntry()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
