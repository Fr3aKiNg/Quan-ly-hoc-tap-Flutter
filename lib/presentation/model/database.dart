import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:scheduleapp/presentation/model/timetable_model.dart';
import 'event_model.dart';
final auth = FirebaseAuth.instance;
String getUid() {
   auth.currentUser().then((FirebaseUser user) {
     return user.uid;
   });
}
final String uid = getUid();
DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>("events",
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());
DatabaseService<TimeTableModel> timetableDBS = DatabaseService<TimeTableModel>(
    "timetables-"+getUid().toString(),
    fromDS: (id, data) => TimeTableModel.fromDS(id, data),
    toMap: (timetable) => timetable.toMap());
