import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleOfTodayData {
  String subject1;
  String subject2;
  String subject3;
  String subject4;
  String subject5;
  String subject6;
  String subject7;
  String subject8;
  ScheduleOfTodayData(
      this.subject1,
      this.subject2,
      this.subject3,
      this.subject4,
      this.subject5,
      this.subject6,
      this.subject7,
      this.subject8);
}

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

class ScheduleOfToday extends StatelessWidget {
  ScheduleOfTodayData data = ScheduleOfTodayData(
      "Toán", "Toán", "Lí", "Lí", "Anh", "Văn", "Văn", "Sinh");
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Table(
      children: [
        TableRow(children: [
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 1")),
          subCard(context, data.subject1, Colors.blue),
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 5")),
          subCard(context, data.subject5, Colors.red)
        ]),
        TableRow(children: [
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 2")),
          subCard(context, data.subject2, Colors.blue),
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 6")),
          subCard(context, data.subject6, Colors.pinkAccent)
        ]),
        TableRow(children: [
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 3")),
          subCard(context, data.subject3, Colors.greenAccent),
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 7")),
          subCard(context, data.subject7, Colors.pinkAccent)
        ]),
        TableRow(children: [
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 4")),
          subCard(context, data.subject4, Colors.greenAccent),
          Padding(
              padding: EdgeInsets.only(left: w * 3, top: h),
              child: Text("Tiết 8")),
          subCard(context, data.subject8, Colors.purple)
        ]),
      ],
    );
  }
}
