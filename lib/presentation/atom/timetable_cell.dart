import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';

class TitleCell extends StatelessWidget {
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
