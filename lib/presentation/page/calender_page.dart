import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/atom/custom_modal_action_button_save.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';
import 'package:scheduleapp/presentation/page/add_event_page.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  _CalenderPageState createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  CalendarController _calendarController;
  Map<DateTime,List<dynamic>> _events;
  List<Event> listEvents = [];

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTimeFrom = TimeOfDay.now();
  TimeOfDay _selectedTimeTo = TimeOfDay.now();

  Color _selectedColor = Colors.red;
  final _textEventControlerName = TextEditingController();
  final _textEventControlerDesc = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            onPressed: ()  async {
              await showAddDialog(context);
            },
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              events: _events,
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              initialCalendarFormat: CalendarFormat.month,
              onDaySelected: (date,events){
                  Navigator.pushNamed(context,"event",arguments:{
                    "date" : DateTime(date.year,date.month,date.day),
                    "event" : listEvents,
                  });
                },
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonVisible: false,
              ),
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future showAddDialog(BuildContext context) async {
    Event event = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: AddEventPage(_textEventControlerName,_textEventControlerDesc,_selectedDate,_selectedTimeFrom,_selectedTimeTo,_selectedColor),
                  actions: <Widget>[
                    CustomModalActionButton(
                      onClose: () => Navigator.of(context).pop(),
                      onSave: (){
                        if(_textEventControlerName.text.isEmpty) {
                          Navigator.of(context).pop();
                        }
                        else {
                          Navigator.of(context).pop(Event(_textEventControlerName.text,_textEventControlerDesc.text, DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeFrom.hour, _selectedTimeFrom.minute),DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTimeTo.hour, _selectedTimeTo.minute),_selectedColor));
                        }
                      },
                    ),
                  ],
                )
            );
    setState(() {
      if(event!=null) {
        listEvents.add(event);
      }
    });
  }
}