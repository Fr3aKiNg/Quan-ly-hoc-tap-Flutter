import 'package:flutter/material.dart';
import 'package:scheduleapp/application/route.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:scheduleapp/presentation/page/calender_page.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/on_board.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import 'package:scheduleapp/presentation/page/event_page.dart';
import 'package:scheduleapp/presentation/page/timetable_page.dart';
import 'package:scheduleapp/utils/firestore/locator.dart';

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
        primarySwatch: Colors.green,
      ),
      routes: {
        'home': (context) => HomeScreen(),
        'on_board': (context) => OnboardingMe(),
        'score': (context) => MyTranscriptPage(),
        'list_course':(context) => MyListCoursePage(),
        'personal_information':(context) => MyInformationPage(),
        'event':(context)=> EventPage(),
        'calendar':(context)=> CalenderPage(),
        'timetable':(context)=> TimetablePage(),
      },
      onGenerateRoute: Router.generateRoute,

      initialRoute: 'calendar',

    );
  }
}
