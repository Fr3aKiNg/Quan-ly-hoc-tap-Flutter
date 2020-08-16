import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/event_card.dart';
import 'package:scheduleapp/presentation/atom/push_local_notification.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Map data = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.clear,color: Colors.white,),
          onPressed: ()=>Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          mainContent(context),
          Positioned(
            right: 0,
            child: Text(
              DateFormat.d().format(DateTime.now()),
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
                  DateFormat.EEEE().format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            data == null ? Center(child: CircularProgressIndicator()) :
            ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index){
                  return EventCard(event: data[index]);
                }
            ),
          ]
      ),
    );
  }
}