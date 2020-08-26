import 'package:flutter/material.dart';
import 'package:scheduleapp/application/route.dart';
import 'package:scheduleapp/presentation/onBoard/on_board.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';

import 'presentation/page/enter_information.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        'home': (context) => HomeScreen(),
        'on_board': (context) => OnboardingMe(),
        'score': (context) => MyTranscriptPage(),
        'list_course':(context) => MyListCoursePage(),
        'personal_information':(context) => MyInformationPage()
      },
      onGenerateRoute: Router.generateRoute,

      initialRoute: 'on_board',

    );
  }
}
