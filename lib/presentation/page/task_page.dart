import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_button.dart';

class Task{
  final String task;
  final bool isDone;
  const Task(this.task,this.isDone);
}

final List<Task> _taskList = [
  new Task("Do home work",false),
  new Task("Do home work",true),
  new Task("Do home work",true),
  new Task("Do home work",true),
];

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}
class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: _taskList.length,
      itemBuilder: (context,index){
        return _taskList[index].isDone ? _taskComplete(_taskList[index].task) : _taskUncomplete(_taskList[index]);
        },
    );
  }

  Widget _taskUncomplete(Task data) {
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
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Confirm Task",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )
                    ),
                    SizedBox(height: 24,),
                    Text(
                      data.task
                    ),
                    SizedBox(height: 24,),
                    Text("",),
                    SizedBox(height: 24,),
                    CustomButton(
                      buttonText: "Complete",
                      onPressed: (){},
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
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
                      Text("Delete Task",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          )
                      ),
                      SizedBox(height: 24,),
                      Text(
                          data.task
                      ),
                      SizedBox(height: 24,),
                      Text("",),
                      SizedBox(height: 24,),
                      CustomButton(
                        buttonText: "Delete",
                        onPressed: (){},
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
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
            Text(data.task),
          ],
        ),
      ),
    );
  }
  Widget _taskComplete(String task) {
    return Container(
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
            Text(task),
          ],
        ),
      ),
    );
  }
}
