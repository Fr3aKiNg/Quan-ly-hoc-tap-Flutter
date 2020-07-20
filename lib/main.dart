import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/page/on_board.dart';
import 'package:scheduleapp/presentation/page/task_event.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskEventPage(), //OnboardingMe(),
    );
  }
}

