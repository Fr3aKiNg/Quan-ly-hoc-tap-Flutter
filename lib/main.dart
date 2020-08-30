import 'package:flutter/material.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/application/route.dart';
import 'package:scheduleapp/presentation/page/event_page.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/onBoard/on_board.dart';
import 'package:scheduleapp/presentation/page/login_screen.dart';
import 'package:scheduleapp/presentation/page/score/addCourse.dart';
import 'package:scheduleapp/presentation/page/score/detailCourse.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import 'package:scheduleapp/presentation/page/enter_information.dart';
import 'package:scheduleapp/presentation/page/splash_screen.dart';


import 'presentation/page/enter_information.dart';
import 'presentation/page/listcourse.dart';
import 'presentation/page/news_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        // '/':(context) => HomeScreen(),
        'home': (context) => HomeScreen(),
        'on_board': (context) => OnboardingMe(),
        'score': (context) => MyTranscriptPage(),
        'list_course':(context) => MyListCoursePage(),
        'personal_information':(context) => MyInformationPage(),
        'add_course': (context) => AddCoursePage(),
        'event_detail': (context) =>EventPage(),
        'news_screen':(context)=> MyTabbedPage(),
        'login_screen':(context) => LoginScreen()
      },
      onGenerateRoute: Router.generateRoute,
      initialRoute: RoutePaths.SplashScreen,
      home: SplashPage(),
    );
  }
}
