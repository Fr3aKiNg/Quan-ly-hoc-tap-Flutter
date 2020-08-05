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
  List _scoreSes1 = [[10.0, 9.5],[10.0, 8.5, 9.0],[8.75, 9.5],[9.5],[10.0]];
  List _scoreSes2 = [[10.0, 9.5],[10.0, 8.5, 9.0],[8.75, 9.5],[9.5],[]];
  List _heso = [1,1,2,2,3];

  double getAvg(List _score) {
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

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: 'Initial value');
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
                    Text(getAvg(_scoreSes1).toStringAsFixed(1).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
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
                                _buildRow(_nameCol[index], _scoreSes1[index]),
                                Divider()
                              ],),
                            margin: null,
                            color: null);
                      else
                        return null;
                    }),
                  )
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Học kỳ 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                    Text(getAvg(_scoreSes2).toStringAsFixed(1).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),)
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
                                _buildRow(_nameCol[index], _scoreSes2[index]),
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
          _showMyDialog(nameCol, score);
        },
      );
  }

  Future<void> _showMyDialog(String nameCol, List score) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(nameCol, style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)))),
          content: Container (
            height: 250,
            child: Column (
              children: <Widget>[
                Expanded (
                    child: SizedBox(
                      height: 500,
                      child:ListView.builder(itemBuilder: (context, index) {
                        if (index < score.length)
                          return Container(
                              child: Column(
                                children: <Widget>[
                                  _buildRowDialog(score[index])
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
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRowDialog(double score) {
    return ListTile(
      title: TextFormField(
          style: _biggerFont,
          initialValue: score.toString(),
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintText: '',
            hintStyle: TextStyle(fontSize: 18.0, color: Color(0xFFBDBDBD)),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Color(0xFF00C48C),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Color(0xFFE4E4E4),
                width: 1.0,
              ),
            ),
          )
      ),
      trailing: new Icon(Icons.close, color: Colors.red),
      onTap: () {

      },
    );
  }
}
class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });
  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //...bottom card part,
        //...top circlular image part,
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

}