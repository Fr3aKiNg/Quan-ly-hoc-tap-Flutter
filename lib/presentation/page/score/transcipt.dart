import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/page/score/detailCourse.dart';
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
    "Thể dục",
    "Quốc phòng",
    "Âm nhạc",
    "Mỹ thuật",
    "Thể dục"
  ];
  final List<double> _score = <double>[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String _value = "";
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(

          ),
          title: Center(child: Text("Bảng điểm")),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.add), color: Colors.white, onPressed: null),
          ],
          backgroundColor: Color(0xFF00C48C),
        ),
        body: Center (
          child: Column (
            children: <Widget>[
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Cả năm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    Text("9.0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
                  ],
                ),
              ),
              Expanded (
                  child: SizedBox(
                    height: 500,
                    child:ListView.builder(itemBuilder: (context, index) {
                      if (index < _courses.length)
                        return Container(
                            child: Column(
                              children: <Widget>[
                                _buildRow(_courses[index], _score[index]),
                                Divider()
                              ],),
                            margin: null,
                            color: null);
                      else
                        return null;
                    }),
                  )
              ),
              Container (
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: (
                    ConstrainedBox (
                        constraints: BoxConstraints.expand(height: 50),
                        child: (
                            RaisedButton(
                                color: Color(0xFF00C48C),
                                textColor: Colors.white,
                                disabledTextColor: Colors.white,
                                child: Text("Bắt đầu", style: _biggerFont),
                                disabledColor: Color(0xFF00C48C)
                            )
                        )
                    )
                ),
              )
            ],
          ),
        )
    );
  }

  Widget _buildRow(String course, double score) {
    if (score != -1)
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(course),
            ),
            Expanded (
              child: Text(score.toString())
            )
          ],
        ),
        trailing: new Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFBDBDBD)),
        onTap: () {
          Navigator.push(
            context,
              MaterialPageRoute(builder: (context) => MyDetailCoursePage(course: course,) )
          );
        },
      );
    else return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(course,style: _biggerFont,),
          Text("0.0",style: _biggerFont,)
        ],
      ),
      trailing: new Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFFBDBDBD)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyDetailCoursePage(course: course,) )
        );
      },
    );
  }
}
