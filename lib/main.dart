import 'package:flutter/material.dart';
import 'package:scheduleapp/application/route.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/on_board.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import 'package:scheduleapp/utils/firestore/locator.dart';

import 'presentation/page/listcourse.dart';

void main() {
//  setupLocator();
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
      routes: {
        'home': (context) => HomeScreen(),
        'on_board': (context) => OnboardingMe(),
        'score': (context) => MyTranscriptPage(),
        'list_course':(context) => MyListCoursePage()
      },
      onGenerateRoute: Router.generateRoute,

      initialRoute: 'on_board',

    );
  }
}
