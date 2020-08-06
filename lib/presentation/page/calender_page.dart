import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarController _calendarController;

  List<Event> listEvents = [];


  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Sự kiện"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {  },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: ()  {
              showAddDialog(context);
            },
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              initialCalendarFormat: CalendarFormat.month,
              onDaySelected: (date,events){
                  Navigator.of(context).pushNamed("task_event");
                },
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showAddDialog(BuildContext context) async {
    final event = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: AddEventPage(), //addDialog(context),
                )
            );
    setState(() {
      listEvents.add(event);
    });
  }
}