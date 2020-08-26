import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:scheduleapp/presentation/atom/custom_date_time_picker.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:scheduleapp/presentation/atom/push_local_notification.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;
  const AddEventPage({Key key, this.note}) : super(key: key);
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime _selectedDate;
  TimeOfDay _selectedTimeFrom;
  TimeOfDay _selectedTimeTo;
  TextEditingController _textEventControlerName ;
  TextEditingController _textEventControlerDesc ;

  bool processing;

  PushLocalNotificationCustom _notify;

  @override
  void initState(){
    super.initState();
    _textEventControlerName = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _textEventControlerDesc = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _selectedDate = widget.note != null ? widget.note.eventDateFrom : DateTime.now();
    _selectedTimeFrom = widget.note != null ? TimeOfDay.fromDateTime(widget.note.eventDateFrom):TimeOfDay.now();
    _selectedTimeTo = widget.note != null ? TimeOfDay.fromDateTime(widget.note.eventDateTo):TimeOfDay.now();
    processing = false;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Text(
              widget.note != null ? "Sửa sự kiện" : "Thêm sự kiện",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 24,),
          CustomTextField(
            controller: _textEventControlerName,
            labelText: "Tiêu đề sự kiện",
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
                  value: TimeOfDay(hour: _selectedTimeTo.hour, minute: _selectedTimeTo.minute).toString().substring(10,15),
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
          SizedBox(height: 24,),
          if (processing) Center(child: LinearProgressIndicator()) else CustomModalActionButton(
            onClose: () => Navigator.of(context).pop(),
            onSave: () async {
              setState(() {
                processing = true;
              });
              if (widget.note!= null){
                await eventDBS.updateData(widget.note.id, {
                  'title': _textEventControlerName.text,
                  'description': _textEventControlerDesc.text,
                  'event_date_from': DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeFrom.hour, _selectedTimeFrom.minute),
                  'event_date_to': DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeTo.hour, _selectedTimeTo.minute),
                  //'color': _selectedColor
                });
                //_notify.flutterLocalNotificationsPlugin.cancelAll();
                //_notify.setNotify();
              }
              else{
                await eventDBS.createItem(EventModel(
                  title: _textEventControlerName.text,
                  description:  _textEventControlerDesc.text,
                  eventDateFrom: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeFrom.hour, _selectedTimeFrom.minute),
                  eventDateTo: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeTo.hour, _selectedTimeTo.minute),
                  //color: _selectedColor
                ));
                _notify = PushLocalNotificationCustom(context: context,event: EventModel(
                  title: _textEventControlerName.text,
                  description:  _textEventControlerDesc.text,
                  eventDateFrom: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeFrom.hour, _selectedTimeFrom.minute),
                  eventDateTo: DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeTo.hour, _selectedTimeTo.minute),
                  // color: _selectedColor
                ));
                _notify.initializeNotifications();
                _notify.setNotify();
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
  @override
  void dispose() {
    _textEventControlerName.dispose();
    _textEventControlerDesc.dispose();
    super.dispose();
  }
}