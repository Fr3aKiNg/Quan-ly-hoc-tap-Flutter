import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:scheduleapp/data/model/timetable_model.dart';
import 'package:scheduleapp/data/model/timetablenote_model.dart';
import 'package:scheduleapp/data/model/event_model.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());
DatabaseService<TimeTableNoteModel> noteDBS = DatabaseService<TimeTableNoteModel>("timetablenotes",fromDS: (id,data) => TimeTableNoteModel.fromDS(id, data), toMap:(note) => note.toMap());
DatabaseService<TimeTableModel> timetableDBS = DatabaseService<TimeTableModel>("timetables", fromDS: (id, data) => TimeTableModel.fromDS(id, data),toMap: (timetable) => timetable.toMap());