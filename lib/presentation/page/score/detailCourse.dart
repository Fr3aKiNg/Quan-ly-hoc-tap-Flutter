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

  //gọi hàm lấy dữ liệu từ db truyền vào các biến
  List<String> _nameCol = <String> ["Miệng", "15 phút", "1 tiết", "Giữa kỳ", "Cuối kỳ"];
  List _scoreSes1 = [[10.0, 9.5],[10.0, 8.5, 9.0],[8.75, 9.5],[9.5],[10.0]];
  List _scoreSes2 = [[10.0, 9.5],[10.0, 8.5, 9.0],[8.75, 9.5],[9.5],[]];
  List _heso = [1,1,2,2,3];
  //
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
  TextEditingController newScoreController = new TextEditingController();
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
              //Gọi hàm lưu lại thay đổi lên db từ các biến _nameCol, _scoreSes1, _scoreSes2, _heso

              //
              Navigator.of(context).pushReplacementNamed('score');
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
                String temp = newScoreController.text;
                int num = 0;
                if (temp != "") {
                  if (ses == 1) {
                    for (int i = 0; i < _nameCol.length; i++)
                      if (_nameCol[i] == nameCol)
                        num = i;
                    int temp2 = _scoreSes1[num].length;
                    List newList;
                    debugPrint(_scoreSes1[num][0].toString());
                    newList = _scoreSes1[num];
                    newList.add(double.parse(temp));
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
                    newList.add(double.parse(temp));
                    setState(() {
                      _scoreSes2[num] = newList;
                    });

                  }
                  newScoreController.text = "";
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRowDialog(String nameCol, double score, int ses) {
    return Dismissible(
      child: ListTile(
        title: TextFormField(
            style: _biggerFont,
            initialValue: score.toString(),
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
          int num = 0;
          int num2 = 0;
          for (int i = 0; i < _nameCol.length; i++)
            if (_nameCol[i] == nameCol)
              num = i;
          for (int i = 0; i < _scoreSes2[num].length; i++)
          {
            if (_scoreSes2[num][i] == score)
              num2 = i;
          }
          int temp2 = _scoreSes2[num].length;
          List newList;

          newList = _scoreSes2[num];
          newList.removeAt(num2);
          setState(() {
            _scoreSes2[num] = newList;
            Navigator.of(context).pop();
          });

        },
      ),
      key: ValueKey(score.toString())
    );
  }

  void editSubject(List nameCol, List heso) {

  }
}
