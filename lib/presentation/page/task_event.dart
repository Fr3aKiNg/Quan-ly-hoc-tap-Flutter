import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/page/event_page.dart';


class TaskEventPage extends StatefulWidget {
  TaskEventPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TaskEventPageState createState() => _TaskEventPageState();
}

class _TaskEventPageState extends State<TaskEventPage> {
  PageController _pageController = PageController();

  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.clear,color: Colors.white,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          mainContent(context),
          Positioned(
            right: 0,
            top: 0,
            child: Text("6",
              style: TextStyle(
                fontSize: 150,
                color: Color(0x10000000),
              ),),
          )
        ],
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Monday",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: EventPage(),
          ),
        ]
    );
  }
}