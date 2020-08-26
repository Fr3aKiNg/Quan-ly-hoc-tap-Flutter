import 'package:flutter/material.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/timetablenote_model.dart';
import 'package:scheduleapp/presentation/atom/custom_date_time_picker.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/page/user.dart';




class AddTaskPage extends StatefulWidget {
  final TimeTableNoteModel note;
  const AddTaskPage({Key key, this.note}) : super(key: key);
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  User user = User();
  DateTime _selectedDate ;
  TextEditingController _textTaskControler;
  bool processing;

  Future _pickDate() async {
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));
    if(datepick!=null){
      setState(() {
        _selectedDate = datepick;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textTaskControler = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _selectedDate = widget.note != null ? widget.note.noteDate : DateTime.now();
    processing = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textTaskControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_textTaskControler.clear();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              "Thêm ghi chú",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 24,),
          CustomTextField(
            labelText: "Mô tả",
            controller: _textTaskControler,
          ),
          CustomDateTimePicker(
            onPressed: _pickDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
            icon: Icons.date_range,
          ),
          SizedBox(height: 24,),
          if (processing) Center(child: LinearProgressIndicator()) else CustomModalActionButton(
            onClose: () => Navigator.of(context).pop(),
            onSave: () async {
              setState(() {
                processing = true;
              });
              if (widget.note!= null){
                await noteDBS.updateData(widget.note.id, {
                  'uid':widget.note.uid,
                  'description': _textTaskControler.text,
                  'note_date': _selectedDate,
                  'is_done': false,
                });
              }
              else{
                await noteDBS.createItem(TimeTableNoteModel(
                  uid: user.id,
                  description:  _textTaskControler.text,
                  noteDate: _selectedDate,
                  isDone: false,
                ));
              }
              Navigator.of(context).pop();
              setState(() {
                processing = false;
              });
            },
          )
        ],
      ),
    );
  }
}