import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:scheduleapp/presentation/model/timetablenote_model.dart';
import 'event_model.dart';

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",fromDS: (id,data) => EventModel.fromDS(id, data), toMap:(event) => event.toMap());
DatabaseService<TimeTableNoteModel> noteDBS = DatabaseService<TimeTableNoteModel>("timetablenotes",fromDS: (id,data) => TimeTableNoteModel.fromDS(id, data), toMap:(note) => note.toMap());