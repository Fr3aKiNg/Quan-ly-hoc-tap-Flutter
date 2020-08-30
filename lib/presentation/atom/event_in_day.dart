import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:intl/intl.dart';

class EventInDayUI extends StatelessWidget{
  ScrollController scrollController = ScrollController();
  EventModel event;
  EventInDayUI(EventModel event): event = event;
  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(
      padding: EdgeInsets.fromLTRB(w, h, w, h),
      width: w*100,
      height: h*12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        Expanded(flex:2,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text(DateFormat.yMMM().format(event.eventDateFrom),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            Text(DateFormat.d().format(event.eventDateFrom), style: TextStyle(fontSize: 12) )
          ]),
        ),
        Expanded(flex: 4, child: eventCard(context, event.title, DateFormat.Hm().format(event.eventDateFrom))),
      ]),
    );
  }
}
Widget eventCard(BuildContext context, String name, String timeLine)
{
  double w = MediaQuery.of(context).size.width / 100;
  double h = MediaQuery.of(context).size.height / 100;
  return Container(
    margin: EdgeInsets.fromLTRB(w, 0, 0, 0),
    padding: EdgeInsets.fromLTRB(w*2, h, w, h),
    width: w*25,
    height: w*15,
    decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.amberAccent,
      borderRadius: BorderRadius.circular(10),),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(name,style: TextStyle(fontSize: 14,color: Colors.white)),
        SizedBox(height: h),
        Expanded(child: Text(timeLine,style:TextStyle(fontSize: 14,color: Colors.white)))
      ],),
  );
}