import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;


class MyDetailCoursePage extends StatelessWidget {
  final String course;
  MyDetailCoursePage({Key key, @required this.course}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: this.course, home: detailCourse(course: course,));
  }
}

class detailCourse extends StatefulWidget {
  final String course;

  detailCourse({Key key, @required this.course}) : super(key: key);
  @override
  detailCourseState createState() => new detailCourseState(course);

  String getCourseName() {
    return course;
  }
}

// ignore: camel_case_types
class detailCourseState extends State<detailCourse> {
  String CourseName;

  List<String> _nameCol = <String> ["Miệng", "15 phút", "1 tiết", "Giữa kỳ", "Cuối kỳ"];
  List _score = [[10.0, 9.5],[10.0, 8.5, 9.0],[8.75, 9.5],[9.5],[10.0]];
  List _heso = [1,1,2,2,3];

  double getAvg() {
    double res = 0.0;
    int count = 0;
    for (int i = 0; i < _heso.length; i++) {
      for (int j = 0; j < _score[i].length; j++) {
        res += _heso[i] * _score[i][j];
        for (int k = 0; k < _heso[i]; k++)
          count++;
      }
    }
    return (res/count);
  }
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController nameController = TextEditingController();

  detailCourseState(String course) {
    CourseName = course;
  }

  @override
  Widget build(BuildContext context) {
    String _value = "";
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {

            })
          ),
          title: Center(
            child: Text(CourseName)
          ),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: null),
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
                    Text("Học kỳ 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    Text(getAvg().toStringAsFixed(1).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
                  ],
                ),
              ),
              Expanded (
                  child: SizedBox(
                    height: 500,
                    child:ListView.builder(itemBuilder: (context, index) {
                      if (index < _nameCol.length)
                        return Container(
                            child: Column(
                              children: <Widget>[
                                _buildRow(_nameCol[index], _score[index]),
                                Divider()
                              ],),
                            margin: null,
                            color: null);
                      else
                        return null;
                    }),
                  )
              ),
            ],
          ),
        )
    );
  }

  Widget _buildRow(String nameCol, List score) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(nameCol, style: _biggerFont,),
            ),
            Expanded (
              child: Row (
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                  List.generate(score.length,(index){
                    return Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(score[index].toString(), style: _biggerFont,)
                    );
                  }
                )
              )
            )
          ],
        ),
        trailing: new Icon(
            Icons.add,
            color: Color(0xFF00C48C)),
        onTap: () {

        },
      );
  }

  void addScore() {
    
  }
}
