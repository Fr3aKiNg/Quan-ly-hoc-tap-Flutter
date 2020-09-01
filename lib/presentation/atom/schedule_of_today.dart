import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/timetable_model.dart';

Widget subCard(BuildContext context, String nameSub, Color color) {
  double w = MediaQuery.of(context).size.width / 100;
  double h = MediaQuery.of(context).size.height / 100;

  return Container(
      margin: EdgeInsets.fromLTRB(0, h / 3, w * 2, h / 3),
      width: w * 10,
      height: h * 4,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: color,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Text(
          nameSub,
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ));
}

class ScheduleOfToday extends StatefulWidget {
  @override
  _ScheduleOfTodayState createState() => _ScheduleOfTodayState();
}

class _ScheduleOfTodayState extends State<ScheduleOfToday> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  void getUid() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    // here you write the codes to input the data into firestore
  }


  List<List<TimeTableModel>> _events;
  List<List<TimeTableModel>> _groupEvents(List<TimeTableModel> events, List<List<TimeTableModel>> data) {
    events.forEach((event) {
      data[event.order][event.day] = event;
    });
    return data;
  }

  List<TimeTableModel> _todaySchedule (int day,List<TimeTableModel> data){
    for(int ord = 0;ord<_events.length;ord++){
      data.add(_events[ord][day]);
    }
    return data;
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;

    getUid();
    return StreamBuilder(
      stream: timetableDBS.streamList(),
      builder: (context,snapshot){
        TimeTableModel empty = TimeTableModel.empty(null);
        var data = List.generate(8, (index) => List.generate(7, (index) => empty));
        if (snapshot.hasData) {
          List<TimeTableModel> allTable = [];
          for (int i = 0; i<snapshot.data.length;i++){
            if(snapshot.data.elementAt(i).uid==uid){
              allTable.add(snapshot.data.elementAt(i));
            }
          }
          _events = _groupEvents(allTable, data);
          List<TimeTableModel> _today = [];
          switch (DateTime.now().weekday){
            case 1:
              _todaySchedule(0, _today);
              break;
            case 2:
              _todaySchedule(1, _today);
              break;
            case 3:
              _todaySchedule(2, _today);
              break;
            case 4:
              _todaySchedule(3, _today);
              break;
            case 5:
              _todaySchedule(4, _today);
              break;
            case 6:
              _todaySchedule(5, _today);
              break;
            case 7:
              _todaySchedule(6, _today);
              break;
            default:
              _todaySchedule(0, _today);
          }
          return Table(
            children: [
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 1")),
                subCard(context, _today[0].subject_name, _today[0].color ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 5")),
                subCard(context, _today[4].subject_name, _today[4].color ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 2")),
                subCard(context, _today[1].subject_name, _today[1].color ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 6")),
                subCard(context, _today[5].subject_name, _today[5].color ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 3")),
                subCard(context, _today[2].subject_name, _today[2].color ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 7")),
                subCard(context, _today[6].subject_name, _today[6].color ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 4")),
                subCard(context, _today[3].subject_name, _today[3].color ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 8")),
                subCard(context, _today[7].subject_name, _today[7].color ),
              ]),
            ],
          );
        }
        else
          return Table(
            children: [
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 1")),
                subCard(context, "", Colors.lightgrey ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 5")),
                subCard(context, "", Colors.lightgrey ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 2")),
                subCard(context, "", Colors.lightgrey ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 6")),
                subCard(context, "", Colors.lightgrey ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 3")),
                subCard(context, "", Colors.lightgrey ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 7")),
                subCard(context, "", Colors.lightgrey ),
              ]),
              TableRow(children: [
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 4")),
                subCard(context, "", Colors.lightgrey ),
                Padding(
                    padding: EdgeInsets.only(left: w * 3, top: h),
                    child: Text("Tiết 8")),
                subCard(context, "", Colors.lightgrey ),
              ]),
            ],
          );
      },
    );
  }
}
