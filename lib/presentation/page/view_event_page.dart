import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/event_card.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết'),
      ),
      body: Stack(
        children: <Widget>[
          mainContent(context),
          Positioned(
            right: 0,
            child: Text(
              DateFormat.d().format(event.eventDateFrom),
              style: TextStyle(
                fontSize: 100,
                color: Color(0x10000000),
              ),),
          )
        ],
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  DateFormat.EEEE().format(event.eventDateFrom),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            EventCard(event: event,),
          ]
      ),
    );
  }
}