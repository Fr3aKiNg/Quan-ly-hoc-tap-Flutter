import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;

class AddCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Thêm môn", home: addCourse());
  }
}

class addCourse extends StatefulWidget {
  @override
  addCourseState createState() => new addCourseState();
}

// ignore: camel_case_types
class addCourseState extends State<addCourse> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController newCourseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              child: new IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    //Gọi hàm lưu lại thay đổi lên db từ các biến _nameCol, _scoreSes1, _scoreSes2, _heso

                    //
                    Navigator.of(context).pushReplacementNamed('score');
                  })),
          title: Center(child: Text("Thêm môn")),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: null),
          ],
          backgroundColor: Color(0xFF00C48C),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(children: <Widget>[
              TextFormField(
                  style: _biggerFont,
                  controller: newCourseController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Môn học',
                    hintStyle:
                        TextStyle(fontSize: 18.0, color: Color(0xFFBDBDBD)),
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
                  )),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Cột điểm", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Icon(Icons.add, color: Color(0xFF00C48C)),
                  ],
                )
              ),
            ]),
          ),
        ));
  }

  Widget _buildRow(String nameCol, List score, int ses) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              nameCol,
              style: _biggerFont,
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(score.length, (index) {
                  return Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        score[index].toString(),
                        style: _biggerFont,
                      ));
                })),
          ))
        ],
      ),
      trailing: new Icon(Icons.add, color: Color(0xFF00C48C)),
      onTap: () {},
    );
  }
}
