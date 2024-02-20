import 'package:flutter/material.dart';
import 'package:journalize/features/authentication/authentication.dart';
import 'package:journalize/features/navigation/widgets/entry_page.dart';
import 'package:journalize/utils/cards.dart';
import 'package:journalize/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final pages = [
    Entries(),
    Text("Mood")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Authentication()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: const Text("Journalize"),
            ),
            ListTile(
              title: Text('Home'),
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
            margin: const EdgeInsets.only(bottom: 10.0),
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
    );
  }
}
