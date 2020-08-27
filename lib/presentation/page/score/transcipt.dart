import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/bottom_navigation_bar.dart';
import 'package:scheduleapp/presentation/page/score/detailCourse.dart';
import 'package:scheduleapp/presentation/page/score/addCourse.dart';
import 'dart:async';
import '../user.dart';
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
  User user = User();
  int count = 0;
  List _courses;
  List _coursesTemp = [
    "loading data ...",
  ];
  List _score = [[], [], []];
  List _scoreTemp = [[""],[""],[""]];
  List _coef = [
    [1, 2],
    [1, 2],
    [1, 2]
  ];
  List _coefController = List();
  List<String> _year = ["2018-2019", "2019-2020", "2020-2021"];
  String _yearChosen = "2018-2019";
  int _yearChosenIndex = 0;
  String dropdownValue = "";
  int countLoop = 0;

  void init() async {
    if (count == 0) {
      final FirebaseUser Fuser = await auth.currentUser();
      user.id = Fuser.uid;
      final collection = Firestore.instance.collection("users");
      collection.document(Fuser.uid).get().then((value) {
        _coursesTemp = value["course"];
        var temp1 = value["year1"]["overall"]["ingredientScore"];
        var temp2 = value["year2"]["overall"]["ingredientScore"];
        var temp3 = value["year3"]["overall"]["ingredientScore"];

        _scoreTemp[0].removeLast();
        _scoreTemp[1].removeLast();
        _scoreTemp[2].removeLast();

        for (int i = 0; i < _coursesTemp.length; i++) {
          _scoreTemp[0].add(temp1[_coursesTemp[i]]);
          _scoreTemp[1].add(temp2[_coursesTemp[i]]);
          _scoreTemp[2].add(temp3[_coursesTemp[i]]);
        }
        setState(() {
          _courses = _coursesTemp;
          _score = _scoreTemp;
        });
      });
      count = 1;
    }
  }

  double Avg(List score) {
    int num = _yearChosenIndex;
    for (int i = 0; i < score.length; i++) if (_yearChosen == _year[i]) num = i;
    double result = 0;
    int count = 0;
    for (int i = 0; i < score[num].length; i++) {
      String temp = score[num][i].toString();
      if (temp != "null" &&
          temp != "Đạt" &&
          temp != "Không đạt" &&
          temp != "-" &&
          temp != "") {
        result += double.parse(score[num][i]);
        count++;
      }
    }
    return result / count;
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController nameController = TextEditingController();
  int _selectedItem;
  @override
  Widget build(BuildContext context) {
    init();
    _courses = _coursesTemp;
    _score = _scoreTemp;
    String _value = "";

    return Scaffold(bottomNavigationBar: BottomAppBar(
      child: CustomBottomNavigationBar(
        iconList: [
          Icons.home,
          Icons.assessment,
          Icons.note,
          Icons.dashboard,
        ],
        onChange: (val) {
          setState(() {
            _selectedItem = val;
          });
        },
        defaultSelectedIndex: 1,
        btnName: ["Tổng quan", "Điểm", "Ghi chú", "Khác"],
      ),
    ),
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
              child: IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              dropdownValue = _yearChosen;
              _showMyDialog();
            },
          )),
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
                  if (index == 0) {
                    for (int i = 0; i < _year.length; i++)
                      if (_year[i] == _yearChosen) _yearChosenIndex = i;
                  }
                  if (_courses != null && index < _courses.length)
                    return Container(
                      child: Column(
                        children: <Widget>[
                          _buildRow(_courses[index],
                              _score[_yearChosenIndex][index].toString()),
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
                        uid: user.id
                      )));
        },
      );
    else
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(
              child: Text(
                course,
                style: _biggerFont,
              ),
            )
          ],
        ),
      );
  }

  Widget _customTextField(
      String hintText, TextEditingController controller, Color color) {
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
        ));
  }

  Future<void> _showMyDialog() async {
    if (countLoop == 0) {
      for (int i = 0; i < _year.length; i++) {
        _coefController.add(new List());
        for (int j = 0; j < 2; j++) {
          _coefController[i]
              .add(new TextEditingController(text: _coef[i][j].toString()));
        }
      }
      countLoop = 1;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
              height: 320,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Hệ số học kỳ",
                    style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "HK1",
                            style: _biggerFont,
                          ),
                        ),
                        title: _customTextField(
                            "Hệ số",
                            _coefController[_yearChosenIndex][0],
                            Color(0xFFBDBDBD)),
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "HK2",
                            style: _biggerFont,
                          ),
                        ),
                        title: _customTextField(
                            "Hệ số",
                            _coefController[_yearChosenIndex][1],
                            Color(0xFFBDBDBD)),
                      )),
                  Text(
                    "Năm học",
                    style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: ListTile(
                          leading: Text(
                            "NH",
                            style: _biggerFont,
                          ),
                          title: DropdownButtonHideUnderline(
                              child: DropdownButton(
                            value: dropdownValue,
                            icon: Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                            onChanged: (String newValue) {
                              setState(() {
                                _yearChosen = newValue;
                                dropdownValue = newValue;
                              });
                              Navigator.of(context).pop();
                              _showMyDialog();
                            },
                            items: _year
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      value,
                                      style: _biggerFont,
                                    ),
                                    value == _yearChosen
                                        ? Icon(Icons.check,
                                            color: Color(0xFF00C48C))
                                        : Icon(Icons.check, color: Colors.white)
                                  ],
                                ),
                              );
                            }).toList(),
                          ))))
                ],
              )),
          actions: <Widget>[
            FlatButton(
              child: Text("Hủy",
                  style: TextStyle(fontSize: 18.0, color: Color(0xFFBDBDBD))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Lưu',
                style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)),
              ),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < _year.length; i++) {
                    for (int j = 0; j < 2; j++) {
                      _coef[i][j] = int.parse(_coefController[i][j].text);
                    }
                  }
                });
                user.updateCoefficient(user.id, _coef);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
