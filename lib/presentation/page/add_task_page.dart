import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_date_time_picker.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  DateTime _selectedDate = DateTime.now();
  final _textTaskControler = TextEditingController();

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
  Widget build(BuildContext context) {
    //_textTaskControler.clear();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              "Add new task",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 24,),
          CustomTextField(
            labelText: "Enter task name",
            controller: _textTaskControler,
          ),
          CustomDateTimePicker(
            onPressed: _pickDate,
            value: new DateFormat("dd-MM-yyyy").format(_selectedDate),
            icon: Icons.date_range,
          ),
          SizedBox(height: 24,),
          CustomModalActionButton(
            onClose: () => Navigator.of(context).pop(),
            onSave: ()=> Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}