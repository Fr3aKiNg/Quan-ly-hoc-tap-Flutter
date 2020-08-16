import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/model/database.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:scheduleapp/presentation/page/view_event_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarController _calendarController;
  Map<DateTime,List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Map<DateTime,List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime,List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date = DateTime(event.eventDateFrom.year,event.eventDateFrom.month,event.eventDateFrom.day,12);
      if(data[date] == null) data[date] = [];
      data[date].add(event);
    });
    return data;
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
            onPressed: ()  async {
              await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                  content: AddEventPage(),
                ),
              );
            },
          ),
        ],
      ),
      body:StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<EventModel> allEvents = snapshot.data;
            if(allEvents.isNotEmpty){
              _events = _groupEvents(allEvents);
            }
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  events: _events,
                  calendarController: _calendarController,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  initialCalendarFormat: CalendarFormat.month,
                  onDaySelected: (date,events){
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonVisible: false,
                  ),
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onDoubleTap: (){
                            Navigator.of(context).pushNamed('event',arguments: _events);
                          },
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
                ..._selectedEvents.map((event) => ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.lens,color: Theme.of(context).primaryColor,),
                      SizedBox(width: 5,),
                      Text(event.title),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                              event: event,
                            )));
                  },
                )),
              ],
            ),
          );
        }
      ),
    );
  }

}