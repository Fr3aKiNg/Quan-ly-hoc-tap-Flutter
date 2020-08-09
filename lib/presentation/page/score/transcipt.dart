import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/page/score/detailCourse.dart';
import 'package:scheduleapp/presentation/page/score/addCourse.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;

class MyTranscriptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "List course", home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<String> _courses = <String>[
    "Toán",
    "Vật lý",
    "Hóa học",
    "Anh văn",
    "Sinh học",
    "Ngữ văn",
    "Lịch sử",
    "Địa lí",
    "Công dân",
    "Công nghệ",
    "Tin học",
    "Quốc phòng",
    "Âm nhạc",
    "Mỹ thuật",
    "Thể dục"
  ];
  final List _score = [
    9.1,
    8.8,
    null,
    null,
    5.6,
    9.0,
    8.8,
    6.8,
    8.0,
    6.1,
    8.8,
    8.1,
    'Đạt',
    'Đạt',
    'Đạt'
  ];

  double Avg(List score) {
    double result = 0;
    int count = 0;
    for (int i = 0; i < score.length; i++) {
      String temp = score[i].toString();
      if (temp != "null" && temp != "Đạt" && temp != "Không đạt") {
        result += score[i];
        count++;
      }
    }
    return result/count;
  }
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String _value = "";
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(),
          title: Center(child: Text("Bảng điểm")),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCoursePage()));
                }),
          ],
          backgroundColor: Color(0xFF00C48C),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Cả năm",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    Text(
                      Avg(_score).toStringAsFixed(1),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: 500,
                child: ListView.builder(itemBuilder: (context, index) {
                  if (index < _courses.length)
                    return Container(
                      child: Column(
                        children: <Widget>[
                          _buildRow(_courses[index], _score[index].toString()),
                          Divider()
                        ],
                      ),
                    );
                  else
                    return null;
                }),
              )),

            ],
          ),
        ));
  }

  Widget _buildRow(String course, String score) {
    if (score != 'null')
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(course), Text(score)],
        ),
        trailing: new Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyDetailCoursePage(
                        course: course,
                      )));
        },
      );
    else
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              course,
              style: _biggerFont,
            ),
            Text(
              "",
              style: _biggerFont,
            )
          ],
        ),
        trailing: new Icon(Icons.arrow_forward_ios, color: Color(0xFFBDBDBD)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyDetailCoursePage(
                        course: course,
                      )));
        },
      );
  }
}
