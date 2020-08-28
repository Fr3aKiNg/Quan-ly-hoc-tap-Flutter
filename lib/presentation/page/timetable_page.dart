import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/timetable_model.dart';
import 'package:scheduleapp/data/model/timetablenote_model.dart';
import 'package:scheduleapp/presentation/atom/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/timetable_cell.dart';
import 'package:scheduleapp/presentation/page/add_task_page.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<List<TimeTableModel>> _events;
  List<dynamic> _selecteds;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  void getUid() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    super.initState();
    _selecteds = [];
    getUid();
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
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: ColorApp.backgroundColor,
        title: Text("Thời khóa biểu"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: timetableDBS.streamList(),
          builder: (context, snapshot) {
            TimeTableModel empty = TimeTableModel.empty(null);
            var data = List.generate(8, (index) => List.generate(7, (index) => empty));
            if (snapshot.hasData) {
              List<TimeTableModel> allTable = [];
              for (int i = 0; i<snapshot.data.length;i++){
                if(snapshot.data.elementAt(i).uid==uid){
                  allTable.add(snapshot.data.elementAt(i));
                }
              }
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
                          List<TimeTableNoteModel> allNotes = [];
                          for (int i = 0; i<snapshot.data.length;i++){
                            if(snapshot.data.elementAt(i).uid==uid)
                              allNotes.add(snapshot.data.elementAt(i));
                          }
                          return ListView.builder(
                              itemCount: allNotes.length,
                              itemBuilder: (context,index){
                                return allNotes[index].isDone ? _taskComplete(allNotes[index]) : _taskUncomplete(allNotes[index]);
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
            );
          }),
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
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[1].subject_name,
          location: data[1].location,
          id: data[1].id,
          teacher_name: data[1].teacher_name,
          color: data[1].color,
          day: 1,
          order: order,
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[2].subject_name,
          location: data[2].location,
          id: data[2].id,
          teacher_name: data[2].teacher_name,
          color: data[2].color,
          day: 2,
          order: order,
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[3].subject_name,
          location: data[3].location,
          id: data[3].id,
          teacher_name: data[3].teacher_name,
          color: data[3].color,
          day: 3,
          order: order,
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[4].subject_name,
          location: data[4].location,
          id: data[4].id,
          teacher_name: data[4].teacher_name,
          color: data[4].color,
          day: 4,
          order: order,
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[5].subject_name,
          location: data[5].location,
          teacher_name: data[5].teacher_name,
          color: data[5].color,
          id: data[5].id,
          day: 5,
          order: order,
          uid: uid,
        ),
        TimeTableCell(
          sub_name: data[6].subject_name,
          location: data[6].location,
          id: data[6].id,
          teacher_name: data[6].teacher_name,
          color: data[6].color,
          day: 6,
          order: order,
          uid: uid,
        ),
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
                            buttonText: "Hoàn Thành",
                            onPressed: () async {
                              await noteDBS.updateData(data.id,{
                                'description': data.description,
                                'note_date': data.noteDate,
                                'uid': uid,
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
                            buttonText: "Chưa Hoàn Thành",
                            onPressed: () async {
                              await noteDBS.updateData(data.id,{
                                'description': data.description,
                                'note_date': data.noteDate,
                                'uid': uid,
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