import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/timetable_model.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';

/*class TitleCell extends StatelessWidget {
  TitleCell({
    Key key, @required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 60.0,
        height: 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey.shade200)
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

class TimeTableCell extends StatefulWidget {

  @override
  _TimeTableCellState createState() => _TimeTableCellState();
}

class _TimeTableCellState extends State<TimeTableCell> {
  TextEditingController _textControllerName = TextEditingController();
  TextEditingController _textControllerClass = TextEditingController();
  TextEditingController _textControllerTeacher = TextEditingController();

  void onValueSelected(Color color){
    backgroundColor = color;
  }

  String text = "";
  String room = "";
  String teach = "";
  Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: InkWell(
          onLongPress: (){
            showDialog(
                context: context,
                builder: (context)=> AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Text("Xoa mon hoc ?"),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: (){
                        setState(() {
                          text = "";
                          room = "";
                          teach = "";
                          backgroundColor = Colors.transparent;
                          _textControllerTeacher.clear();
                          _textControllerClass.clear();
                          _textControllerName.clear();
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    ),
                  ],
                )
            );

          },
          onDoubleTap: (){
            showDialog(
                context: context,
                builder: (context)=> AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lens,color: backgroundColor),
                            SizedBox(width: 5,),
                            Text(
                              text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24,),
                        Row(
                          children: [
                            Icon(Icons.edit_location),
                            SizedBox(width: 5,),
                            Text(room),
                          ],
                        ),
                        SizedBox(height: 12,),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 5,),
                            Text(teach),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"),
                    )
                  ],
                )
            );
          },
          onTap: ()  {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Thêm thời khoá biểu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 24,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: CustomTextField(
                              controller: _textControllerName,
                              labelText: "Tên môn học",
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ChangeBGColorDropdown(onValueSelected),
                          ),
                        ],
                      ),
                      SizedBox(height: 12,),
                      CustomTextField(
                        labelText: "Lớp học",
                        icon: Icon(Icons.edit_location),
                        controller: _textControllerClass,
                      ),
                      SizedBox(height: 12,),
                      CustomTextField(
                        labelText: "Tên giáo viên",
                        icon: Icon(Icons.person),
                        controller: _textControllerTeacher,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CustomModalActionButton(
                    onClose: () => Navigator.of(context).pop(),
                    onSave: () {
                      if(backgroundColor==null){
                        showDialog(context: context,builder: (context) => AlertDialog(content: Text("Hãy chọn màu đại diện"),actions: <Widget>[FlatButton(child: Text("Ok"),onPressed: ()=>Navigator.of(context).pop(),),],));
                      }
                      else{
                        setState(() {
                          this.text = _textControllerName.text;
                          this.room = _textControllerClass.text;
                          this.teach = _textControllerTeacher.text;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            width: 60.0,
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: backgroundColor,
                border: Border.all(color: Colors.grey.shade200)
            ),
            child: Text(
              '$text',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
    );
  }
}

*/

class TitleCell extends StatelessWidget {
  TitleCell({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        padding: EdgeInsets.all(5),
        width: 60.0,
        height: 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey.shade200)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}

class TimeTableCell extends StatefulWidget {
  TimeTableCell(
      {Key key,
        @required this.sub_name,
        @required this.location,
        @required this.teacher_name,
        @required this.color,
        @required this.day,
        @required this.id,
        @required this.uid,
        @required this.order})
      : super(key: key);
  String sub_name;
  String location;
  String teacher_name;
  Color color;
  String id;
  String uid;
  int order;
  int day;

  @override
  _TimeTableCellState createState() => _TimeTableCellState();
}

class _TimeTableCellState extends State<TimeTableCell> {
  TextEditingController _textControllerName = TextEditingController();
  TextEditingController _textControllerClass = TextEditingController();
  TextEditingController _textControllerTeacher = TextEditingController();

  void onValueSelected(Color color) {
    backgroundColor = color;
  }

  @override
  void initState() {
    super.initState();
    this.text = widget.sub_name;
    this.room = widget.location;
    this.teach = widget.teacher_name;
    this.day = widget.day;
    this.order = widget.order;
    this.id = widget.id;
    this.uid = widget.uid;
    this.backgroundColor = widget.color;
    _textControllerClass.text = room;
    _textControllerName.text = text;
    _textControllerTeacher.text = teach;
  }

  String text = "";
  String id;
  String uid;
  String room = "";
  String teach = "";
  Color backgroundColor;
  int day;
  int order;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: InkWell(
          onLongPress: () {
            if (text != "") {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Text("Xoa mon hoc ?"),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          if (text != "") {
                            setState(() {
                              text = "";
                              room = "";
                              teach = "";
                              backgroundColor = Colors.transparent;
                              _textControllerTeacher.clear();
                              _textControllerClass.clear();
                              _textControllerName.clear();
                            });
                            if (this.id != null)
                              await timetableDBS.removeItem(this.id);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Ok"),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel"),
                      ),
                    ],
                  ));
            }
          },
          onDoubleTap: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lens, color: backgroundColor),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              text,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          children: [
                            Icon(Icons.edit_location),
                            SizedBox(
                              width: 5,
                            ),
                            Text(room),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(
                              width: 5,
                            ),
                            Text(teach),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Close"),
                    )
                  ],
                ));
          },
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Thêm thời khoá biểu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: CustomTextField(
                              controller: _textControllerName,
                              labelText: "Tên môn học",
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ChangeBGColorDropdown(onValueSelected),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        labelText: "Lớp học",
                        icon: Icon(Icons.edit_location),
                        controller: _textControllerClass,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CustomTextField(
                        labelText: "Tên giáo viên",
                        icon: Icon(Icons.person),
                        controller: _textControllerTeacher,
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  CustomModalActionButton(
                    onClose: () => Navigator.of(context).pop(),
                    onSave: () async {
                      if (backgroundColor == null || backgroundColor == Color(0))
                        backgroundColor = Color(4280391411);
                      if (text != "") {
                        await timetableDBS.updateData(
                            this.id,
                            TimeTableModel(
                                uid: this.uid,
                                subject_name: _textControllerName.text,
                                location: _textControllerClass.text,
                                teacher_name: _textControllerTeacher.text,
                                day: this.day,
                                order: this.order,
                                color: this.backgroundColor)
                                .toMap());
                      } else {
                        DocumentReference res = await timetableDBS.createItem(
                            TimeTableModel(
                                uid: this.uid,
                                subject_name: _textControllerName.text,
                                location: _textControllerClass.text,
                                teacher_name: _textControllerTeacher.text,
                                day: this.day,
                                order: this.order,
                                color: this.backgroundColor));
                        this.id = res.documentID;
                      }
                      setState(() {
                        this.text = _textControllerName.text;
                        this.room = _textControllerClass.text;
                        this.teach = _textControllerTeacher.text;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(5),
            width: 60.0,
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: backgroundColor,
                border: Border.all(color: Colors.grey.shade200)),
            child: Text(
              '$text',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}