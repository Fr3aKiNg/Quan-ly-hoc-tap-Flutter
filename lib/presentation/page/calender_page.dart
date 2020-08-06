import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scheduleapp/presentation/atom/change_bg_color_dropdown.dart';
import 'package:scheduleapp/presentation/atom/custom_date_time_picker.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/atom/custom_textfield.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarController _calendarController;


  final _textEventControlerName = TextEditingController();
  final _textEventControlerDesc = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTimeFrom = TimeOfDay.now();
  TimeOfDay _selectedTimeTo = TimeOfDay.now();
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
        context: context,
        initialTime: new TimeOfDay.now());
    if(timepick!=null)
      setState(() {
      isFrom ? _selectedTimeFrom = timepick :_selectedTimeTo = timepick;
    });
  }



  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sự kiện"),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {  },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: AddEventPage(), //addDialog(context),
                  )
              );
            },
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              initialCalendarFormat: CalendarFormat.month,
              onDaySelected: (date,events){
                  Navigator.of(context).pushNamed("task_event");
                },
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}