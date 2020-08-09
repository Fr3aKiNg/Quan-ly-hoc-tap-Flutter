import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Thời khóa biểu"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () { /*Navigator.of(context).pop();*/ },
          icon: Icon(Icons.arrow_back_ios),
      ),
        centerTitle: true,
    ),
      body: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            buildTableRowTitle(),
            TableRow(children: [SizedBox(height: 10,),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),]),
            buildTimeTableRow("Tiet 1"),
            buildTimeTableRow("Tiet 2"),
            buildTimeTableRow("Tiet 3"),
            buildTimeTableRow("Tiet 4"),
            TableRow(children: [SizedBox(height: 20,),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),SizedBox(),]),
            buildTimeTableRow("Tiet 5"),
            buildTimeTableRow("Tiet 6"),
            buildTimeTableRow("Tiet 7"),
            buildTimeTableRow("Tiet 8"),
          ]
        ),
      )
    );
  }

  TableRow buildTableRowTitle() {
    return TableRow(
            children: [
              SizedBox(),
              TitleCell(title: "T2",),
              TitleCell(title: "T3",),
              TitleCell(title: "T4",),
              TitleCell(title: "T5",),
              TitleCell(title: "T6",),
              TitleCell(title: "T7",),
              TitleCell(title: "CN",),
            ]
          );
  }

  TableRow buildTimeTableRow(String title) {
    return TableRow(
            children: [
              TitleCell(title: title,),
              TimeTableCell(),
              TimeTableCell(),
              TimeTableCell(),
              TimeTableCell(),
              TimeTableCell(),
              TimeTableCell(),
              TimeTableCell(),
            ],
          );
  }
}

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
  Color backgroundColor ;
  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: InkWell(
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