import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/data/Event.dart';

class EventInDayUI extends StatelessWidget{
  ScrollController scrollController = ScrollController();
  EventInDay event;
  EventInDayUI(EventInDay eventInDay): event = eventInDay;
  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(
      width: w*100,
      height: h*12,
      child: Row(children: <Widget>[
        Expanded(flex:2,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[
            Text(event.date,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            Text(event.dayInWeek, style: TextStyle(fontSize: 12) )
          ]),
        ),
        Expanded(flex: 10, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          itemCount: event.eventOfTheDay.length,
          itemBuilder: (context,index){
            final item = event.eventOfTheDay[index];
            return eventCard(context, item.name, item.timeline);
          },
        ))
      ]),
    );
  }
}
Widget eventCard(BuildContext context, String name, String timeLine)
{
  double w = MediaQuery.of(context).size.width / 100;
  double h = MediaQuery.of(context).size.height / 100;
  return Container(
    margin: EdgeInsets.fromLTRB(w*2, 0, 0, h*2),
    padding: EdgeInsets.fromLTRB(w, h, w, h/2),
    width: w*25,
    height: w*12,
    decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.amberAccent,
      borderRadius: BorderRadius.circular(10),),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(name,style: TextStyle(fontSize: 14,color: Colors.white)),
        SizedBox(height: h*2),
        Expanded(child: Text(timeLine,style:TextStyle(fontSize: 14,color: Colors.white)))
      ],),
  );
}