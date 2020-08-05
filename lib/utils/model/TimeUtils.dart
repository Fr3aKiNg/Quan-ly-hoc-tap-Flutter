import 'package:intl/intl.dart';

abstract class TimeUtils{
  DateTime created_time;
  DateTime modified_time;
  static var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss.sss');
  TimeUtils(){
    DateTime now = DateTime.now();
    this.created_time = now;
    this.modified_time = now;
  }
  void updateModify(){
    this.modified_time = DateTime.now();
  }
}