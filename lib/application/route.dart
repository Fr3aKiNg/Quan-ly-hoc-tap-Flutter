import 'package:flutter/material.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/presentation/page/calender_page.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/note/note_screen.dart';
import 'package:scheduleapp/presentation/page/other_screen.dart';
import 'package:scheduleapp/presentation/page/splash_screen.dart';
import 'package:scheduleapp/presentation/page/timetable_page.dart';
import 'package:scheduleapp/presentation/page/view_event_page.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());
      case RoutePaths.OtherScreen:
        return MaterialPageRoute(builder: (BuildContext context) => OtherScreen());
      case RoutePaths.Note:
        return MaterialPageRoute(builder: (BuildContext context) => NoteScreen());
      case RoutePaths.SplashScreen:
        return MaterialPageRoute(builder: (BuildContext context)=> SplashPage());
      case RoutePaths.CalendarPage:
        return MaterialPageRoute(builder: (BuildContext context)=> CalenderPage());
      case RoutePaths.TimetablePage:
        return MaterialPageRoute(builder: (BuildContext context)=> TimetablePage());
      case RoutePaths.EventList:
        return MaterialPageRoute(builder: (BuildContext context)=> EventDetailsPage());
        default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}
