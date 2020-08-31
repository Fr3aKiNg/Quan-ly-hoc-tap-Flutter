import 'dart:math';

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
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.fromLTRB(w, h, w, 0),
      width: w*100,
      height: h*10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        Expanded(flex:2,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
final colors = [
  Color(0xffffffff), // classic white
  Color(0xfff28b81), // light pink
  Color(0xfff7bd02), // yellow
  Color(0xfffbf476), // light yellow
  Color(0xffcdff90), // light green
  Color(0xffa7feeb), // turquoise
  Color(0xffcbf0f8), // light cyan
  Color(0xffafcbfa), // light blue
  Color(0xffd7aefc), // plum
  Color(0xfffbcfe9), // misty rose
  Color(0xffe6c9a9), // light brown
  Color(0xffe9eaee) // light gray
];
Widget eventCard(BuildContext context, String name, String timeLine)
{
  double w = MediaQuery.of(context).size.width / 100;
  double h = MediaQuery.of(context).size.height / 100;
  var rnd = Random();
  int i = rnd.nextInt(10);
  return Container(
    margin: EdgeInsets.fromLTRB(w, 0, 0, 0),
    padding: EdgeInsets.fromLTRB(w*2, h, w, h/2),
    width: w*25,
    height: w*15,
    decoration: BoxDecoration(shape: BoxShape.rectangle,color: colors[i],
      borderRadius: BorderRadius.circular(10),),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(name,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500)),
        SizedBox(height: h),
        Expanded(child: Text(timeLine,style:TextStyle(fontSize: 14,color: Colors.black)))
      ],),
  );
}