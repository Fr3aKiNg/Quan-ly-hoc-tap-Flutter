import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:scheduleapp/presentation/page/score/transcipt.dart';
import 'package:scheduleapp/presentation/page/score/editCourse.dart';
import '../user.dart';
class MyDetailCoursePage extends StatelessWidget {
  final String course;
  final String uid;
  MyDetailCoursePage({Key key, @required this.course, @required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: this.course, home: detailCourse(course: course, uid: uid,));
  }
}

class detailCourse extends StatefulWidget {
  final String course;
  final String uid;
  detailCourse({Key key, @required this.course, @required this.uid}) : super(key: key);
  @override
  detailCourseState createState() => new detailCourseState(course, uid);

  String getCourseName() {
    return course;
  }
}

// ignore: camel_case_types
class detailCourseState extends State<detailCourse> {
  String CourseName;
  String uid;
  int chosenYear = 0;
  //gọi hàm lấy dữ liệu từ db truyền vào các biến
  List _nameCol = [];
  List _scoreSes1 = [];
  List _scoreSes2 = [];
  List _heso = [];
  int count = 0;
  //
  double getAvg(List _score) {
    double res = 0.0;
    int count = 0;
    for (int i = 0; i < _heso.length; i++) {
      for (int j = 0; j < _score[i].length; j++) {
        if (_score[i][j] is String)
          res += double.parse(_heso[i]) * double.parse(_score[i][j]);
        else
          res += _heso[i] * _score[i][j];
        for (int k = 0; k < int.parse(_heso[i]); k++)
          count++;
      }
    }
    return (res/count);
  }
  final _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController nameController = TextEditingController();
  TextEditingController newScoreController = new TextEditingController();
  detailCourseState(String course, String userid) {
    CourseName = course;
    uid = userid;
  }

  void init() {
    if (count == 0) {
      final collection = Firestore.instance.collection("users");
      collection.document(uid).get().then((value) {
        _nameCol = value.data["columnScore"][CourseName]["column"];
        _heso = value.data["columnScore"][CourseName]["coef"];
        setState(() {
          if (chosenYear == 0) {
            for (int i = 0; i < _nameCol.length; i++) {
              _scoreSes1.add(value.data["year1"]["HK1"]["ingredientScore"][CourseName][_nameCol[i]]);
              _scoreSes2.add(value.data["year1"]["HK2"]["ingredientScore"][CourseName][_nameCol[i]]);
            }
          }
          else if (chosenYear == 1) {
            for (int i = 0; i < _nameCol.length; i++) {
              _scoreSes1.add(value.data["year2"]["HK1"]["ingredientScore"][CourseName][_nameCol[i]]);
              _scoreSes2.add(value.data["year2"]["HK2"]["ingredientScore"][CourseName][_nameCol[i]]);
            }
          }
          else {
            for (int i = 0; i < _nameCol.length; i++) {
              _scoreSes1.add(value.data["year3"]["HK1"]["ingredientScore"][CourseName][_nameCol[i]]);
              _scoreSes2.add(value.data["year3"]["HK2"]["ingredientScore"][CourseName][_nameCol[i]]);
            }
          }
        });

      });
      count = 1;
    }
  }
  @override
  Widget build(BuildContext context) {
    String _value = "";
    init();
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: new IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {
              //Gọi hàm lưu lại thay đổi lên db từ các biến _nameCol, _scoreSes1, _scoreSes2, _heso

              //
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      MyTranscriptPage()));
            })
          ),
          title: Center(
            child: Text(CourseName)
          ),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditCoursePage(
                      course: this.CourseName,
                      uid: this.uid,
                      nameColumn: _nameCol,
                      coef: _heso,)));
            }),
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
                                _buildRow(_nameCol[index], _scoreSes1[index], 1),
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
                                _buildRow(_nameCol[index], _scoreSes2[index], 2),
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

  Widget _buildRow(String nameCol, List score, int ses) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(nameCol, style: _biggerFont,),
            ),
            Expanded (
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                ),
              )
            )
          ],
        ),
        trailing: new Icon(
            Icons.add,
            color: Color(0xFF00C48C)),
        onTap: () {
          _showMyDialog(nameCol, score, ses);
        },
      );
  }

  Future<void> _showMyDialog(String nameCol, List score, int ses) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(nameCol, style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)))),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: score.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return ListTile(
                    title: TextFormField(
                        style: _biggerFont,
                        controller: newScoreController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Nhập điểm',
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
                else
                  return
                    Dismissible(
                        child: ListTile(
                          title: TextFormField(
                              style: _biggerFont,
                              initialValue: score[index-1].toString(),
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: '',
                                hintStyle: TextStyle(fontSize: 18.0),
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
                            if (ses == 1) {
                              int num = 0;
                              int num2 = 0;
                              for (int i = 0; i < _nameCol.length; i++)
                                if (_nameCol[i] == nameCol)
                                  num = i;
                              for (int i = 0; i < _scoreSes1[num].length; i++)
                              {
                                if (_scoreSes1[num][i] == score[index-1])
                                  num2 = i;
                              }
                              int temp2 = _scoreSes1[num].length;
                              List newList;
                              newList = _scoreSes1[num];
                              newList.removeAt(num2);
                              setState(() {
                                _scoreSes1[num] = newList;
                                Navigator.of(context).pop();
                                _showMyDialog(nameCol, score, ses);
                              });
                            }
                            else {
                              int num = 0;
                              int num2 = 0;
                              for (int i = 0; i < _nameCol.length; i++)
                                if (_nameCol[i] == nameCol)
                                  num = i;
                              for (int i = 0; i < _scoreSes2[num].length; i++)
                              {
                                if (_scoreSes2[num][i] == score[index-1])
                                  num2 = i;
                              }
                              int temp2 = _scoreSes2[num].length;
                              List newList;
                              newList = _scoreSes2[num];
                              newList.removeAt(num2);
                              setState(() {
                                _scoreSes2[num] = newList;
                                Navigator.of(context).pop();
                                _showMyDialog(nameCol, score, ses);
                              });
                            }
                          },
                        ),
                        key: ValueKey(score[index-1].toString())
                    );
              },
            ),
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
                print(_scoreSes1);
                String temp = newScoreController.text;
                int num = 0;
                if (temp != "") {
                  if (ses == 1) {
                    for (int i = 0; i < _nameCol.length; i++)
                      if (_nameCol[i] == nameCol)
                        num = i;
                    int temp2 = _scoreSes1[num].length;
                    List newList;
                    newList = _scoreSes1[num];
                    newList.add(temp);
                    setState(() {
                      _scoreSes1[num] = newList;
                    });

                  }
                  else {
                    for (int i = 0; i < _nameCol.length; i++)
                      if (_nameCol[i] == nameCol)
                        num = i;
                    int temp2 = _scoreSes2[num].length;
                    List newList;

                    newList = _scoreSes2[num];
                    newList.add(temp);
                    setState(() {
                      _scoreSes2[num] = newList;
                    });

                  }
                  newScoreController.text = "";
                }
                User user = User();
                user.updateScore(uid, CourseName, _scoreSes1, _scoreSes2, _nameCol, chosenYear);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
