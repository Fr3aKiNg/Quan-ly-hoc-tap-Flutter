import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';
import 'package:scheduleapp/presentation/atom/custom_button.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/model/database.dart';
import 'package:scheduleapp/presentation/page/add_task_page.dart';
import 'package:scheduleapp/presentation/model/timetable_model.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<List<TimeTableModel>> _events;
  List<dynamic> _selecteds;

  @override
  void initState() {
    super.initState();
    _selecteds = [];
  }

  List<List<TimeTableModel>> _groupEvents(
      List<TimeTableModel> events, List<List<TimeTableModel>> data) {
    events.forEach((event) {
      data[event.order][event.day] = event;
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    //final uid = Provider.of<CurrentUser>(context).data.uid;
    //var timetableDBS = gettimetableDBS("1234");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Thời khóa biểu"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            /*Navigator.of(context).pop();*/
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: timetableDBS.streamList(),
          builder: (context, snapshot) {
            TimeTableModel empty = TimeTableModel.empty(null);
            var data =
                List.generate(8, (index) => List.generate(7, (index) => empty));
            if (snapshot.hasData) {
              List<TimeTableModel> allTable = snapshot.data;
              _events = _groupEvents(allTable, data);
            }
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          buildTableRowTitle(),
                          TableRow(children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                          ]),
                          buildTimeTableRow("1", _events[0], 1),
                          buildTimeTableRow("2", _events[1], 1),
                          buildTimeTableRow("3", _events[2], 2),
                          buildTimeTableRow("4", _events[3], 3),
                          TableRow(children: [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                            SizedBox(),
                          ]),
                          buildTimeTableRow("5", _events[4], 4),
                          buildTimeTableRow("6", _events[5], 5),
                          buildTimeTableRow("7", _events[6], 6),
                          buildTimeTableRow("8", _events[7], 7),
                        ]),
                  ),
                ),
                _taskUncomplete("Dummy"),
                _taskUncomplete("Dummy"),
                _taskUncomplete("Dummy"),
                _taskComplete("Dummy"),
                _taskComplete("Dummy"),
                _taskComplete("Dummy"),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: AddTaskPage(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  TableRow buildTableRowTitle() {
    return TableRow(children: [
      SizedBox(),
      TitleCell(
        title: "T2",
      ),
      TitleCell(
        title: "T3",
      ),
      TitleCell(
        title: "T4",
      ),
      TitleCell(
        title: "T5",
      ),
      TitleCell(
        title: "T6",
      ),
      TitleCell(
        title: "T7",
      ),
      TitleCell(
        title: "CN",
      ),
    ]);
  }

  TableRow buildTimeTableRow(
      String title, List<TimeTableModel> data, int order) {
    return TableRow(
      children: [
        TitleCell(
          title: title,
        ),
        TimeTableCell(
          sub_name: data[0].subject_name,
          location: data[0].location,
          teacher_name: data[0].teacher_name,
          id: data[0].id,
          color: data[0].color,
          day: 0,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[1].subject_name,
          location: data[1].location,
          id: data[1].id,
          teacher_name: data[1].teacher_name,
          color: data[1].color,
          day: 1,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[2].subject_name,
          location: data[2].location,
          id: data[2].id,
          teacher_name: data[2].teacher_name,
          color: data[2].color,
          day: 2,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[3].subject_name,
          location: data[3].location,
          id: data[3].id,
          teacher_name: data[3].teacher_name,
          color: data[3].color,
          day: 3,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[4].subject_name,
          location: data[4].location,
          id: data[4].id,
          teacher_name: data[4].teacher_name,
          color: data[4].color,
          day: 4,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[5].subject_name,
          location: data[5].location,
          teacher_name: data[5].teacher_name,
          color: data[5].color,
          id: data[5].id,
          day: 5,
          order: order,
        ),
        TimeTableCell(
          sub_name: data[6].subject_name,
          location: data[6].location,
          id: data[6].id,
          teacher_name: data[6].teacher_name,
          color: data[6].color,
          day: 6,
          order: order,
        ),
      ],
    );
  }

  Widget _taskUncomplete(String data) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        new DateFormat("dd-MM-yyyy").format(DateTime.now()),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Complete",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Delete Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        new DateFormat("dd-MM-yyyy").format(DateTime.now()),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Delete",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.radio_button_unchecked,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
            SizedBox(
              width: 28,
            ),
            Text(data),
          ],
        ),
      ),
    );
  }

  Widget _taskComplete(String data) {
    return InkWell(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Delete Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        new DateFormat("dd-MM-yyyy").format(DateTime.now()),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Delete",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Confirm Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(
                        height: 24,
                      ),
                      Text(data),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        new DateFormat("dd-MM-yyyy").format(DateTime.now()),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      CustomButton(
                        buttonText: "Uncompleted",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: Color(0x60FDFDFD),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.radio_button_checked,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 28,
              ),
              Text(data),
            ],
          ),
        ),
      ),
    );
  }
}

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
      @required this.order})
      : super(key: key);
  String sub_name;
  String location;
  String teacher_name;
  Color color;
  String id;
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
void initState(){
    super.initState();
    this.text = widget.sub_name;
    this.room = widget.location;
    this.teach = widget.teacher_name;
    this.day = widget.day;
    this.order = widget.order;
    this.id = widget.id;
    this.backgroundColor = widget.color;
    _textControllerClass.text = room;
    _textControllerName.text = text;
    _textControllerTeacher.text = teach;
}
  String text = "";
  String id;

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
                  if(backgroundColor == null || backgroundColor == Color(0))
                    backgroundColor = Color(4280391411);
                  if (text != "") {
                    await timetableDBS.updateData(
                        this.id,
                        TimeTableModel(
                            subject_name: _textControllerName.text,
                            location: _textControllerClass.text,
                            teacher_name: _textControllerTeacher.text,
                            day: this.day,
                            order: this.order,
                            color: this.backgroundColor)
                            .toMap());
                  } else {
                    DocumentReference res = await timetableDBS.createItem(TimeTableModel(
                        subject_name: _textControllerName.text,
                        location: _textControllerClass.text,
                        teacher_name: _textControllerTeacher.text,
                        day: this.day,
                        order: this.order,
                      color: this.backgroundColor
                    ));
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
