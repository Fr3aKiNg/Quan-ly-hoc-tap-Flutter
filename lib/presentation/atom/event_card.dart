import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';


class EventCard extends StatefulWidget {
  final EventModel event;
  EventCard({Key key,this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      margin: EdgeInsets.only(top:5),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Icon(Icons.lens,color: Colors.greenAccent,)),
              Expanded(
                flex: 5,
                child: Text(widget.event.title,
                  style: TextStyle(
                      fontSize: 35
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: PopupMenuButton <String> (
                    icon: Icon(Icons.more_vert,color: Colors.grey,),
                    onSelected: (String _selected) async {
                      if(_selected=="Edit"){
                        await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: AddEventPage(note:widget.event,),
                          ),
                        );
                      }
                      else if(_selected=="Delete"){
                        await eventDBS.removeItem(widget.event.id);
                        Navigator.of(context).pop();
                      }
                    } ,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "Edit",
                        child: Text('Sửa sự kiện'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Delete",
                        child: Text('Xóa sự kiện',style: TextStyle(color: Colors.redAccent),),
                      ),
                    ],
                  )
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(flex: 1,child: Icon(Icons.calendar_today,color: Colors.grey,)),
              Expanded(
                flex: 6,
                child: Text(DateFormat.yMMMMEEEEd().format(widget.event.eventDateFrom),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1,child: Icon(Icons.access_time,color: Colors.grey,)),
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Text(TimeOfDay.fromDateTime(widget.event.eventDateFrom).toString().substring(10,15),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(" - ",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(TimeOfDay.fromDateTime(widget.event.eventDateTo).toString().substring(10,15),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 1,child: Icon(Icons.list,color: Colors.grey,)),
              Expanded(
                flex: 5,
                child: Text(widget.event.description,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        ],
      ),
    );
  }
}