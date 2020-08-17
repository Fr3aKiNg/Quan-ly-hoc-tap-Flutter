import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/event_card.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<dynamic> data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.clear,color: Colors.green,),
          onPressed: ()=>Navigator.pop(context),
        ),
      ),
      body: data == null ? Center(child: LinearProgressIndicator(backgroundColor: Colors.orangeAccent),):
      ListView.builder(
          itemCount: data.length,
          itemBuilder: (context,index){
            return EventCard(event: data[index],);
          }
      ),
    );
  }
}