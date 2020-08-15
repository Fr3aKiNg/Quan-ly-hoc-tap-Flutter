import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  const EventCard({Key key,this.event}) : super(key: key);

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
              Expanded(flex: 1,child: Icon(Icons.lens,color: Colors.redAccent,)),
              Expanded(
                flex: 5,
                child: Text(event.title,
                  style: TextStyle(
                      fontSize: 35
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: PopupMenuButton <String> (
                    icon: Icon(Icons.more_vert,color: Colors.grey,),
                    onSelected: (String _selected){
                      if(_selected=="Edit"){

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
                child: Text(DateFormat.yMMMMEEEEd().format(event.eventDateFrom),
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
                child: Text("9:00 AM - 10:00AM",
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
              Expanded(flex: 1,child: Icon(Icons.list,color: Colors.grey,)),
              Expanded(
                flex: 5,
                child: Text(event.description,
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