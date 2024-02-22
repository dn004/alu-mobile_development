import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodPage extends StatelessWidget {
  MoodPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> sampleData = [
    {
      'mood_count': 20.0,
      'mood_color': 0xFF00FF00, // Green color
      'mood_name': 'Happy',
    },
    {
      'mood_count': 15.0,
      'mood_color': 0xFFFFA500, // Orange color
      'mood_name': 'Excited',
    },
    {
      'mood_count': 10.0,
      'mood_color': 0xFF0000FF, // Blue color
      'mood_name': 'Sad',
    },
    {
      'mood_count': 5.0,
      'mood_color': 0xFFFFFF00, // Yellow color
      'mood_name': 'Neutral',
    },
    {
      'mood_count': 3.0,
      'mood_color': 0xFFFF0000, // Red color
      'mood_name': 'Angry',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Chart'),
      ),
      body: Container(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: PieChart(
            PieChartData(
              sections: _getPieChartSections(),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final List<PieChartSectionData> sections = [];
    for (final data in sampleData) {
      final double value = data['mood_count'] ?? 0.0;
      final int colorValue = data['mood_color'] ?? 0xFFFFFFFF;
      final String title = data['mood_name'] ?? '';
      final Color color = Color(colorValue);
      sections.add(
        PieChartSectionData(
          value: value,
          color: color,
          title: title,
          radius: 100,
          showTitle:true,
          
        ),
      );
    }
    return sections;
  }
}
