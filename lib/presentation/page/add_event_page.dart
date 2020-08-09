import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';
import 'package:scheduleapp/presentation/atom/custom_date_time_picker.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';


class AddEventPage extends StatefulWidget {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTimeFrom = TimeOfDay.now();
  TimeOfDay _selectedTimeTo = TimeOfDay.now();

  Color _selectedColor = Colors.red;
  TextEditingController _textEventControlerName ;
  TextEditingController _textEventControlerDesc;

  AddEventPage(this._textEventControlerName,this._textEventControlerDesc,this._selectedDate,this._selectedTimeFrom,this._selectedTimeTo,this._selectedColor);

  @override
  _AddEventPageState createState() => _AddEventPageState(this._textEventControlerName,this._textEventControlerDesc,this._selectedDate,this._selectedTimeFrom,this._selectedTimeTo,this._selectedColor);
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTimeFrom = TimeOfDay.now();
  TimeOfDay _selectedTimeTo = TimeOfDay.now();

  Color _selectedColor = Colors.red;
  TextEditingController _textEventControlerName ;
  TextEditingController _textEventControlerDesc;

  _AddEventPageState(this._textEventControlerName,this._textEventControlerDesc,this._selectedDate,this._selectedTimeFrom,this._selectedTimeTo,this._selectedColor);

  @override
  void initState(){
    super.initState();
  }

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

  Future _pickTime(bool isFrom) async{
    TimeOfDay timepick = await showTimePicker(
        context: context, initialTime: new TimeOfDay.now());
    if(timepick!=null) setState(() {
      isFrom ? _selectedTimeFrom = timepick :_selectedTimeTo = timepick;
    });
  }

  void onValueSelected(Color color){
    Color backgroundColor = color;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              "Thêm sự kiện",
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
                  controller: _textEventControlerName,
                  labelText: "Tiêu đề sự kiện",
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
            controller: _textEventControlerDesc,
            labelText: "Chi tiết",
          ),
          SizedBox(height: 12,),
          CustomDateTimePicker(
            onPressed: _pickDate,
            value: new DateFormat.yMMMMEEEEd().format(_selectedDate) ,//new DateFormat("dd-MM-yyyy").format(_selectedDate),
            icon: Icons.date_range,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: CustomDateTimePicker(
                  onPressed: () {_pickTime(true);},
                  value: new TimeOfDay(hour: _selectedTimeFrom.hour, minute: _selectedTimeFrom.minute).toString().substring(10,15),
                  icon: Icons.access_time,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text("-", textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
              ),
              Expanded(
                flex: 3,
                child: CustomDateTimePicker(
                  onPressed: () {_pickTime(false);} ,
                  value: new TimeOfDay(hour: _selectedTimeTo.hour, minute: _selectedTimeTo.minute).toString().substring(10,15),
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
          //SizedBox(height: 24,),
        ],
      ),
    );
  }
}