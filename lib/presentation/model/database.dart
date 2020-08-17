import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:scheduleapp/presentation/model/timetable_model.dart';
import 'event_model.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());
DatabaseService<TimeTableModel> timetableDBS = DatabaseService<TimeTableModel>(
    "timetables",
    fromDS: (id, data) => TimeTableModel.fromDS(id, data),
    toMap: (timetable) => timetable.toMap());
