import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:scheduleapp/presentation/page/other_screen.dart';
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
        backgroundColor: Color(0xff07CD94),
        title: Text("Sự kiện"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                    dayBuilder: (context,date,events)=> Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(fontSize: 15),
                        )),
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: InkWell(
                          onDoubleTap: (){
                              Navigator.of(context).pushNamed('event_detail',arguments: _selectedEvents);
                          },
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white,fontSize: 20),
                          ),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white,fontSize: 15),
                        )),
                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];
                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            right: 1,
                            bottom: 1,
                            child: _buildEventsMarker(date, events),
                          ),
                        );
                      }
                      return children;
                    },
                  ),
                ),
                ..._selectedEvents.map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.lens,color: Colors.greenAccent,size: 30,),
                        SizedBox(width: 5,),
                        Text(event.title,
                          style: TextStyle(fontSize: 20),
                        ),
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
                  ),
                )),
              ],
            ),
          );
        }
      ),
    );
  }
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 20.0,
      height: 20.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}