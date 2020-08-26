import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/data/model/user.dart';
import 'package:scheduleapp/presentation/page/ScorePanel.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
import 'package:scheduleapp/presentation/page/note/note_editor.dart';
import 'package:scheduleapp/presentation/page/note/note_screen.dart';
import 'package:scheduleapp/presentation/page/other_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;
  final List<String> btnName;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
        @required this.iconList,
        @required this.onChange,@required this.btnName});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];
  List<String> _btnName = [];

  Route _generateRoute(RouteSettings settings) {
    try {
      return _doGenerateRoute(settings);
    } catch (e, s) {
      debugPrint("failed to generate route for $settings: $e $s");
      return null;
    }
  }

  Route _doGenerateRoute(RouteSettings settings) {
    if (settings.name?.isNotEmpty != true) return null;
    final uri = Uri.parse(settings.name);
    final path = uri.path ?? '';
    switch (path) {
      case '/note': {
        final note = (settings.arguments as Map ?? {})['note'];
        return _buildRoute(settings, (_) => NoteEditor(note: note));
      }
      default:
        return null;
    }
  }

  /// Create a [Route].
  Route _buildRoute(RouteSettings settings, WidgetBuilder builder) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: builder,
      );


@override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
    _btnName = widget.btnName;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i,_btnName[i]));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index,String name) {
    double h  = MediaQuery.of(context).size.height/100;
    double w  = MediaQuery.of(context).size.width/100;
    return GestureDetector(
        onTap: () {
          widget.onChange(index);
          if (index == 0) {
            Navigator.of(context).push(
                PageRouteBuilder(pageBuilder: (context, animation1, animation2) => HomeScreen()));
          }
          if (index == 1) {
            setState(() {
              _selectedIndex =index;
            });
            Navigator.of(context).push( PageRouteBuilder(pageBuilder: (context, animation1, animation2) =>  ScorePanel()));
          }
          else if (index == 3) {
            Navigator.of(context).push(
                PageRouteBuilder(pageBuilder: (context, animation1, animation2) =>  OtherScreen()));
            setState(() {
              _selectedIndex =index;
            });
          }
          else if (index == 2)
          {
            Navigator.of(context).push(
                PageRouteBuilder(pageBuilder: (context, animation1, animation2)  =>
                StreamProvider.value(
    value: FirebaseAuth.instance.onAuthStateChanged.map((user) => CurrentUser.create(user)),
    initialData: CurrentUser.initial,
    child: Consumer<CurrentUser>(
      builder: (context, user, _) => MaterialApp(
        theme: Theme.of(context).copyWith(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme.of(context).copyWith(
            elevation: 1,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarColor: Colors.white,
          primaryTextTheme: Theme.of(context).primaryTextTheme.copyWith(

          ),
        ),
        home:  NoteScreen(),
        routes: {
          '/settings': (_) => NoteScreen(),
        },
        onGenerateRoute: _generateRoute,
      ),
    ),
  )));
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, h*1.5, 0, h),
          height: h*10,
          width: MediaQuery.of(context).size.width / _iconList.length,
          decoration: _selectedIndex == index
              ? BoxDecoration(color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 4, color: Colors.white),
            ),
          )
              : BoxDecoration(color: Colors.white),
          child: Column(
              children: <Widget>[
                Icon(
                    icon,
                    color:  _selectedIndex == index  ? ColorApp.backgroundColor : Colors.grey,
                    size: 28),
                Text(name, style: TextStyle(color: _selectedIndex == index  ? ColorApp.backgroundColor : Colors.grey ),)
              ]),
        ));
  }
}
