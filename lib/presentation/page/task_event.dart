import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_button.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:scheduleapp/presentation/page/add_task_page.dart';
import 'package:scheduleapp/presentation/page/event_page.dart';
import 'package:scheduleapp/presentation/page/task_page.dart';

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
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    return Scaffold(
      body: Stack(
        children: <Widget>[
          mainContent(context),
          Container(
            color: Theme.of(context).accentColor,
            height: 35,
          ),
          Positioned(
            right: 0,
            child: Text("6",
              style: TextStyle(
                fontSize: 200,
                color: Color(0x10000000),
              ),),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return Dialog(
                  child: currentPage == 0 ? AddTaskPage() : AddEventPage(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                );
              }
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60,),
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _button(context),
          ),
          Expanded(
            child: PageView (
              controller: _pageController,
              children: <Widget>[TaskPage(),EventPage(),],
            ),
          ),
        ]
    );
  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child:CustomButton(
              onPressed: () {
                _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
              },
              buttonText: "Task",
              color: currentPage < 0.5 ? Theme.of(context).accentColor : Colors.white,
              textColor: currentPage < 0.5 ? Colors.white : Theme.of(context).accentColor,
              borderColor: currentPage < 0.5 ? Colors.transparent : Theme.of(context).accentColor,
            )
        ),
        SizedBox(width: 32,),
        Expanded(
          child: CustomButton(
            onPressed: (){
              _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
            },
            buttonText: "Event",
            color: currentPage > 0.5 ? Theme.of(context).accentColor : Colors.white,
            textColor: currentPage > 0.5 ? Colors.white : Theme.of(context).accentColor,
            borderColor: currentPage > 0.5 ? Colors.transparent : Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}