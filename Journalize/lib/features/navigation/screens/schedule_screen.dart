import 'package:flutter/material.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  // I usedDummy data for dis schedules tho
  final List<String> dummySchedules = [
    'Meeting at 9:00 AM',
    'Lunch Break at 12:30 PM',
    'Project Discussion at 2:00 PM',
    'Gym at 6:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dummySchedules.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Icon(Icons.schedule),
                title: Text(
                  dummySchedules[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // todo
                  },
                ),
                onTap: () {
                  // todo 
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
