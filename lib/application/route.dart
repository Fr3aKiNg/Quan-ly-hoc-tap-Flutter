import 'package:flutter/material.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/note/note_editor.dart';
import 'package:scheduleapp/presentation/page/note/note_screen.dart';
import 'package:scheduleapp/presentation/page/other_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeScreen());
      case RoutePaths.OtherScreen:
        return MaterialPageRoute(builder: (BuildContext context) => OtherScreen());
      case RoutePaths.Note:
        return MaterialPageRoute(builder: (BuildContext context) => NoteScreen());
//      case RoutePaths.NoteEditor:
//        return MaterialPageRoute(builder: (BuildContext context)=> NoteEditor(note: note,) );
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
