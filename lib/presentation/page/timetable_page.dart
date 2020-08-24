import 'package:flutter/material.dart';

import 'package:scheduleapp/presentation/atom/custom_button.dart';

import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/timetable_cell.dart';
import 'package:scheduleapp/presentation/model/database.dart';
import 'package:scheduleapp/presentation/model/timetablenote_model.dart';
import 'package:scheduleapp/presentation/page/add_task_page.dart';

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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
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
            ),
          ),
          Divider(thickness: 2,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ghi Chú",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.mode_edit),
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return Dialog(
                            child: AddTaskPage(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          );
                        }
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TimeTableNoteModel>>(
                stream: noteDBS.streamList(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List<TimeTableNoteModel> allNotes = snapshot.data;
                      return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context,index){
                            return allNotes[index].isDone
                                ? _taskComplete(allNotes[index])
                                : _taskUncomplete(allNotes[index]);
                          }
                      );
                  }
                  else{
                    return Center(child: CircularProgressIndicator()) ;
                  }
                }
            ),
          )
        ],
      ),
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

  Widget _taskUncomplete(TimeTableNoteModel data) {
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(DateFormat.yMMMMEEEEd().format(data.noteDate),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                      SizedBox(height: 24,),
                      Text(
                          data.description
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            buttonText: "Xong",
                            onPressed: () async {
                              await noteDBS.updateData(data.id,{
                                'description': data.description,
                                'note_date': data.noteDate,
                                'is_done': true,
                              });
                              Navigator.of(context).pop();
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
      onLongPress: (){
        showDialog(
            context: context,
            builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Xoá ghi chú",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  data.description
                              ),
                              SizedBox(height: 24,),
                              Text(DateFormat.yMMMMEEEEd().format(data.noteDate),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            buttonText: "Xoá",
                            onPressed: (){
                              noteDBS.removeItem(data.id);
                              //Navigator.of(context).pushReplacementNamed('timetable');
                              Navigator.of(context).pop();
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        );
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
            SizedBox(width: 28,),
            Text(data.description,
                style: TextStyle(
                  fontSize: 17,
                ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _taskComplete(TimeTableNoteModel data) {
    return InkWell(
      onLongPress: (){
        showDialog(
            context: context,
            builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Xoá ghi chú",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  data.description
                              ),
                              SizedBox(height: 24,),
                              Text(DateFormat.yMMMMEEEEd().format(data.noteDate),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            buttonText: "Xoá",
                            onPressed: (){
                              noteDBS.removeItem(data.id);
                              //Navigator.of(context).pushReplacementNamed('timetable');
                              Navigator.of(context).pop();
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
      onTap: (){
        showDialog(
            context: context,
            builder: (context){
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(DateFormat.yMMMMEEEEd().format(data.noteDate),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                      SizedBox(height: 24,),
                      Text(
                          data.description
                      ),
                      SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton(
                            buttonText: "Chưa xong",
                            onPressed: () async {
                              await noteDBS.updateData(data.id,{
                                'description': data.description,
                                'note_date': data.noteDate,
                                'is_done': false,
                              });
                              Navigator.of(context).pop();
                            },
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
        );
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
              SizedBox(width: 28,),
              Text(data.description,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}