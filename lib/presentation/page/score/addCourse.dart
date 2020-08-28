import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:scheduleapp/utils/sign_in.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import '../user.dart';
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
  List heso = [1,1,2,2,3];
  List nameScoreCol = ["Miệng", "15 phút", "1 tiết", "Giữa Kỳ", "Cuối Kỳ"];
  int length = 0;
  TextEditingController newCourseController = TextEditingController();

  List HeSoController = new List();
  List NameScoreController = new List();

  @override
  Widget build(BuildContext context) {
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
                            MyTranscriptPage()));
                  })),
          title: Center(child: Text("Thêm môn")),
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
                    IconButton(icon: Icon(Icons.add, color: Color(0xFF00C48C)), onPressed: () => _showMyDialog(),),
                  ],
                ),
              ),
              Container(
                width: double.maxFinite,
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
                                child: _customTextField('', NameScoreController[index], Colors.black),
                              ),
                              Flexible(
                                flex: 2,
                                child: _customTextField('', HeSoController[index], Colors.black),
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
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 18.0, color: color),
          filled: true,
          enabled: true,
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
                  length = nameScoreCol.length + 2;
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
    String newCourseName = newCourseController.text;

    for (int i =0 ; i < nameScoreCol.length; i++)
    {
      nameScoreCol[i] = NameScoreController[i].text;
      heso[i] = HeSoController[i].text;

    }

    User user = User();
    user.addNewCourse(newCourseName, nameScoreCol, heso);
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            MyTranscriptPage()));
  }
}

