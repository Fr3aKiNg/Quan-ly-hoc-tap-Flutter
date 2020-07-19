import 'package:flutter/material.dart';
import 'package:Educare/presentation/page/on_board.dart';


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
      home: OnboardingMe(),
      
    );
  }
}

