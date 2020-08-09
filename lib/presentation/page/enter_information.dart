import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scheduleapp/presentation/page/colorBloc.dart';
import 'package:scheduleapp/presentation/page/listcourse.dart';
import 'package:path/path.dart' as Path;

class MyInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "List course", home: EnterInformation());
  }
}

class EnterInformation extends StatefulWidget {
  @override
  InformationState createState() => new InformationState();
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class InformationState extends State<EnterInformation> {
  final _biggerFont = const TextStyle(fontSize: 18.0, color: Colors.black);

  TextEditingController name = TextEditingController();
  TextEditingController school = TextEditingController();
  TextEditingController grade = TextEditingController();
  String _nameValue = "";
  String _schoolValue = "";
  String _gradeValue = "";

  String _dropdownValue = 'Học kỳ 1';

  ColorBloc colorBloc1 = new ColorBloc();
  ColorBloc colorBloc2 = new ColorBloc();
  ColorBloc colorBloc3 = new ColorBloc();

  String _alert = "";
  @override
  void dispose() {
    colorBloc1.dispose();
    colorBloc2.dispose();
    colorBloc3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomPadding:false,
        appBar: RoundedAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 5, right: 5),
                  padding: EdgeInsets.only(left: 3),
                  child: StreamBuilder(
                    initialData: Color(0xFFE4E4E4),
                    stream: colorBloc1.colorStream,
                    builder: (BuildContext context, snapShot) => TextFormField(
                        controller: name,
                        style: _biggerFont,
                        onChanged: (text) {
                          _nameValue = text;
                          debugPrint(snapShot.data.toString());
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Tên',
                          hintStyle: TextStyle(
                              fontSize: 18.0, color: Color(0xFFBDBDBD)),
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
                              color: snapShot.data,
                              width: 1.0,
                            ),
                          ),
                        )),
                  )),
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 5, right: 5),
                  padding: EdgeInsets.only(left: 3),
                  child: StreamBuilder(
                    initialData: Color(0xFFE4E4E4),
                    stream: colorBloc2.colorStream,
                    builder: (BuildContext context, snapShot) => TextFormField(
                        controller: school,
                        style: _biggerFont,
                        onChanged: (text) {
                          _nameValue = text;
                          debugPrint(snapShot.data.toString());
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Trường',
                          hintStyle: TextStyle(
                              fontSize: 18.0, color: Color(0xFFBDBDBD)),
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
                              color: snapShot.data,
                              width: 1.0,
                            ),
                          ),
                        )),
                  )),
              Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 10, left: 5, right: 5),
                  padding: EdgeInsets.only(left: 3),
                  child: StreamBuilder(
                    initialData: Color(0xFFE4E4E4),
                    stream: colorBloc3.colorStream,
                    builder: (BuildContext context, snapShot) => TextFormField(
                        controller: grade,
                        style: _biggerFont,
                        onChanged: (text) {
                          _nameValue = text;
                          debugPrint(snapShot.data.toString());
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: 'Lớp',
                          hintStyle: TextStyle(
                              fontSize: 18.0, color: Color(0xFFBDBDBD)),
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
                              color: snapShot.data,
                              width: 1.0,
                            ),
                          ),
                        )),
                  )),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10, left: 7, right: 5),
                padding: EdgeInsets.only(left: 10),
                child: (ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 60),
                    child: (DropdownButtonHideUnderline(
                        child: DropdownButton(
                      value: _dropdownValue,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFBDBDBD),
                      ),
                      iconSize: 24,
                      style: _biggerFont,
                      onChanged: (String newValue) {
                        debugPrint(newValue);
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                      items: <String>['Học kỳ 1', 'Học kỳ 2', 'Học kỳ 3']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ))))),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFE4E4E4))),
              ),
              Center(
                child: Text('$_alert',
                    style: TextStyle(fontSize: 18.0, color: Colors.red)),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
                child: (ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 50),
                    child: (RaisedButton(
                        color: Color(0xFF00C48C),
                        textColor: Colors.white,
                        disabledTextColor: Colors.white,
                        child: Text("Tiếp tục",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)),
                        disabledColor: Color(0xFF00C48C),
                        onPressed: () {
                          Start();
                        })))),
              )
            ],
          ),
        ));
  }

  void Start() {
    if (name.text == "") {
      colorBloc1.changeColor();
    } else {
      colorBloc1.resumeColor();
    }
    if (school.text == "") {
      colorBloc2.changeColor();
    } else {
      colorBloc2.resumeColor();
    }
    if (grade.text == "") {
      colorBloc3.changeColor();
    } else {
      colorBloc3.resumeColor();
    }
    if (name.text != "" && school.text != "" && grade.text != "") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyListCoursePage()));
    } else {
      setState(() {
        _alert = "Vui lòng nhập đầy đủ thông tin!";
      });
    }
  }
}

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _appbarFont = const TextStyle(
      fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
          child: Text(
        "Thông tin cá nhân",
        style: _appbarFont,
      )),
      decoration: new BoxDecoration(
        color: Color(0xFF00C48C),
        boxShadow: [new BoxShadow(blurRadius: 2.0)],
        borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(
                MediaQuery.of(context).size.width, 100.0)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200.0);
}
