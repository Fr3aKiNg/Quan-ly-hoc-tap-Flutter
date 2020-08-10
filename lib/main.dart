import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/application/route.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/note/note_editor.dart';
import 'package:scheduleapp/presentation/page/note/note_screen.dart';
import 'package:scheduleapp/presentation/page/on_board.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import 'package:scheduleapp/utils/firestore/locator.dart';

import 'data/model/note.dart';
import 'data/model/user.dart';
import 'presentation/page/enter_information.dart';
import 'presentation/page/listcourse.dart';

void main() {
//  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Note note =  Note();
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
        'list_course':(context) => MyListCoursePage(),
        'personal_information':(context) => MyInformationPage(),
        'note_editor': (context) => NoteEditor(note: note),
        'note_screen':(context) => NoteScreen()
      },
      onGenerateRoute: Router.generateRoute,

      initialRoute: 'on_board',

    );
  }
}
