import 'package:flutter/material.dart';

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
          onPressed: () {  },
          icon: Icon(Icons.arrow_back_ios),
      ),
        centerTitle: true,
    ),
      body: SingleChildScrollView(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          /*border: TableBorder(
            verticalInside: BorderSide(color: Colors.grey.shade200),
            horizontalInside: BorderSide(color: Colors.grey.shade200),
          ),*/
          children: [
            TableRow(
              children: [
                TimeTableCell(text: "",textColor: Colors.transparent,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T2",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T3",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T4",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T5",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T6",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "T7",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "CN",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 1",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Toan",textColor: Colors.white,backgroundColor: Colors.redAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 2",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Toan",textColor: Colors.white,backgroundColor: Colors.redAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 3",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Hoa",textColor: Colors.white,backgroundColor: Colors.orangeAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Sinh",textColor: Colors.white,backgroundColor: Colors.greenAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 4",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Hoa",textColor: Colors.white,backgroundColor: Colors.orangeAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Sinh",textColor: Colors.white,backgroundColor: Colors.greenAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 5",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Anh",textColor: Colors.white,backgroundColor: Colors.blueAccent,),
                TimeTableCell(text: "Anh",textColor: Colors.white,backgroundColor: Colors.blueAccent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 6",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.white,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 7",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Sinh",textColor: Colors.white,backgroundColor: Colors.greenAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Toan",textColor: Colors.white,backgroundColor: Colors.redAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
            TableRow(
              children: [
                TimeTableCell(text: "Tiet 8",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Sinh",textColor: Colors.white,backgroundColor: Colors.greenAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
                TimeTableCell(text: "Toan",textColor: Colors.white,backgroundColor: Colors.redAccent,),
                TimeTableCell(text: "",textColor: Colors.grey.shade700,backgroundColor: Colors.transparent,),
              ],
            ),
          ]
        ),
      )
    );
  }
}

class TimeTableCell extends StatelessWidget {
  const TimeTableCell({
    Key key, @required this.text, @required this.textColor, @required this.backgroundColor,
  }) : super(key: key);

  final String text;
  final Color backgroundColor, textColor;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: InkWell(
        onTap: (){
          showDialog(
              context: context,
              child: AlertDialog(
                content: Text(text),
              )
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
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
        ),
      )
    );
  }
}
