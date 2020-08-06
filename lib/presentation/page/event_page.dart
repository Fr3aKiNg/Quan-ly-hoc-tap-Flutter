import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';

class EventPage extends StatefulWidget {
  EventPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Map data = {};
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
              DateFormat.d().format(data['date']),
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
                  DateFormat.EEEE().format(data['date']),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            EventCard(),
            EventCard(),
          ]
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      margin: EdgeInsets.only(top:5),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1,child: Icon(Icons.work,color: Colors.redAccent,)),
              Expanded(
                flex: 5,
                child: Text("Thi Toán",
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
                child: Text("Thứ 5, 19 tháng 7, 2020",
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
                child: Text("Ôn phần 2 3 4 chương 6. Phần 3 4 5 6 7 của các chương còn lại.",
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