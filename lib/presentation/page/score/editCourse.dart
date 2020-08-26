import 'dart:ffi';
import '../user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:scheduleapp/utils/sign_in.dart';
import 'package:scheduleapp/presentation/page/score/detailCourse.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
class EditCoursePage extends StatelessWidget {
  final String course;
  final String uid;
  final List nameColumn;
  final List coef;

  EditCoursePage({Key key, @required this.course, @required this.uid, @required this.nameColumn, @required this.coef}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Sửa môn", home: editCourse(course: course, uid: uid, nameColumn: nameColumn, coef: coef));
  }
}

class editCourse extends StatefulWidget {
  final String course;
  final String uid;
  final List nameColumn;
  final List coef;
  editCourse({Key key, @required this.course, @required this.uid, @required this.nameColumn, @required this.coef}) : super(key: key);
  @override
  editCourseState createState() => new editCourseState(course, uid, nameColumn, coef);
}

// ignore: camel_case_types
class editCourseState extends State<editCourse> {
  String _courseName;
  String uid;
  List nameScoreCol = [];
  List heso = [];

  editCourseState(String course, String uid, List column, List coef) {
    this._courseName = course;
    this.uid = uid;
    this.nameScoreCol = column;
    this.heso = coef;
  }

  final _biggerFont = const TextStyle(fontSize: 18.0);

  List _courses = [
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
  int count = 0;
  void init() {
    if (count == 0) {
      count=1;
    }
  }
  TextEditingController newCourseController;

  List HeSoController = new List();
  List NameScoreController = new List();

  Widget build(BuildContext context) {
    print(uid);
    if (count == 0) {
      newCourseController = TextEditingController(text: _courseName);
      count = 1;
    }

    print(newCourseController.text);
    return Scaffold(
        resizeToAvoidBottomPadding:false,
        appBar: AppBar(
          leading: GestureDetector(
              child: new IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            MyDetailCoursePage(course: _courseName, uid: uid)));
                  })),
          title: Center(child: Text("Sửa môn")),
          actions: <Widget>[
            new IconButton(
                icon: const Icon(Icons.check, color: Colors.white),
                onPressed: Accept),
          ],
          backgroundColor: Color(0xFF00C48C),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Column(children: <Widget>[
              TextFormField(
                  style: _biggerFont,
                  controller: newCourseController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintStyle:
                    TextStyle(fontSize: 18.0, color: Colors.black),
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
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Cột điểm", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    IconButton(icon: Icon(Icons.add, color: Color(0xFF00C48C)),onPressed: () {
                      _showMyDialog();
                    },),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
                child: SizedBox(
                  height: 500,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: nameScoreCol.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (HeSoController.length != 0 && index == 0) {
                          HeSoController.removeRange(0, HeSoController.length);
                          NameScoreController.removeRange(0, NameScoreController.length);
                        }
                        if (index < nameScoreCol.length) {
                          HeSoController.add(new TextEditingController(text: heso[index].toString()));
                          NameScoreController.add(new TextEditingController(text: nameScoreCol[index]));
                          return Dismissible(
                            background: Container(
                              color: Colors.red,
                              child: Icon(Icons.cancel),
                            ),
                            child: Container (
                              margin: EdgeInsets.only(top: 10),
                              child: Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    flex: 1,
                                    child: Icon(Icons.close, color: Colors.red),
                                  ),
                                  Flexible(
                                    flex: 4,
                                    child: _customTextField(nameScoreCol[index], NameScoreController[index], Colors.black),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    child: _customTextField(heso[index].toString(), HeSoController[index], Colors.black),
                                  )
                                ],
                              ),
                            ),
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              setState(() {
                                nameScoreCol.removeAt(index);
                                heso.removeAt(index);
                                HeSoController.removeAt(index);
                                NameScoreController.removeAt(index);
                              });
                            },
                          );
                        }
                        return null;
                      }
                  ),
                )
              ),
              Container (
                child: RaisedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.restore_from_trash, color: Colors.red),
                      Text(" Xóa môn", style: TextStyle(fontSize: 18.0, color: Colors.red),),
                    ],
                  ),
                  color: Colors.white,
                  disabledColor: Colors.white,
                  onPressed: () {
                    User user = User();
                    user.deleteCourse(uid, _courseName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            MyTranscriptPage()));
                  },
                )
              ),
            ]),
          ),
        ));
  }

  Widget _customTextField(String hintText, TextEditingController controller, Color color) {
    return TextFormField(
        style: _biggerFont,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintStyle: TextStyle(fontSize: 18.0, color: color),
          filled: true,
          enabled: false,
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
    );
  }


  Future<void> _showMyDialog() async {
    TextEditingController newScoreName = TextEditingController();
    TextEditingController newCoef = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Thêm cột điểm", style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)))),
          content: Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Tên cột điểm", style: _biggerFont,),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: _customTextField("Tên cột điểm mới", newScoreName, Color(0xFFBDBDBD))
                ),
                Text("Hệ số", style: _biggerFont,),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: _customTextField("Hệ số", newCoef, Color(0xFFBDBDBD))
                ),
              ],
            )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Hủy", style: TextStyle(fontSize: 18.0, color: Color(0xFFBDBDBD))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Thêm', style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C) ),),
              onPressed: () {
                setState(() {
                  nameScoreCol.add(newScoreName.text);
                  heso.add(newCoef.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void Accept() {
    for (int i =0 ; i < nameScoreCol.length; i++)
      {
        nameScoreCol[i] = NameScoreController[i].text;
        heso[i] = HeSoController[i].text;
      }
    User user = User();
    print(_courseName);
    print(newCourseController.text);
    if (_courseName != newCourseController.text){
      user.editCourse(uid, _courseName, nameScoreCol, heso, newCourseController.text, true);
      //user.deleteCourse(uid, _courseName);
    }
    else {
      user.editCourse(uid, _courseName, nameScoreCol, heso, newCourseController.text, false);
    }

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            MyDetailCoursePage(course: _courseName, uid: uid,)));
  }
}

