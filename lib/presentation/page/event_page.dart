import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_icon_decoration.dart';


class Event{
  final String time;
  final String task;
  final String desc;
  final bool isDone;
  const Event(this.time,this.task,this.desc,this.isDone);
}

final List<Event> _eventList = [
  new Event("08:00", "Coffee", "Personal", true),
new Event("08:00", "Coffee", "Personal", true),
new Event("08:00", "Coffee", "Personal", false),
];

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    double iconSize =20;
    return ListView.builder(
      itemCount: _eventList.length,
      padding: const EdgeInsets.all(0),
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(left: 24.0,right: 24.0),
            child: Row(
              children: <Widget>[
                _lineStyle(iconSize, index, context, _eventList.length,_eventList[index].isDone),
                _displayTime(_eventList[index].time),
                _displayContent(_eventList[index])
              ],
            ),
          );
        },
    );
  }

  Widget _displayContent(Event event) {
    return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12,bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x20000000),
                          blurRadius: 5,
                          offset: Offset(0,3),
                        ),
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(event.task),
                        SizedBox(height: 12,),
                        Text(event.desc),
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget _displayTime(String time) {
    return Container(
                width: 80,
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(time),
              );
  }

  Widget _lineStyle(double iconSize, int index, BuildContext context,int listLength, bool isDone) {
    return Container(
                decoration: CustomIconDecoration(
                  iconSize: iconSize,
                  lineWidth: 1,
                  firstData: index==0,
                  lastData: index==listLength-1
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0,3),
                        color: Color(0x20000000),
                        blurRadius: 5
                      )
                    ],
                  ),
                  child: Icon(
                    isDone ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
                    size:20,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              );
  }
}