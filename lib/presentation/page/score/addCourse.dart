import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:scheduleapp/utils/sign_in.dart';
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
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
  
  TextEditingController newCourseController = TextEditingController();
  TextEditingController newName = TextEditingController();
  TextEditingController newHeso = TextEditingController();
  
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
                    Icon(Icons.add, color: Color(0xFF00C48C)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                  Flexible(
                    flex: 4,
                    child: _customTextField("Tên cột điểm", newName, Color(0xFFBDBDBD)),
                  ),
                  Flexible(
                    flex: 2,
                    child: _customTextField("Hệ số", newHeso, Color(0xFFBDBDBD)),
                  )
                ],
              ),
              Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: nameScoreCol.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < nameScoreCol.length) {
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
                                child: _customTextField(nameScoreCol[index], null, Colors.black),
                              ),
                              Flexible(
                                flex: 2,
                                child: _customTextField(heso[index].toString(), null, Colors.black),
                              )
                            ],
                          ),
                        ),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            nameScoreCol.removeAt(index);
                            heso.removeAt(index);
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

  void Accept() {
    String newCourseName = newCourseController.text;
    if (newName.text != "")
      nameScoreCol.add(newName.text);
    if (newHeso.text != "")
      heso.add(int.parse(newHeso.text));

    //xử lí Database

    //
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            MyTranscriptPage()));
  }
}
