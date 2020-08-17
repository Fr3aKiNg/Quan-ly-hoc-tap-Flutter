import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduleapp/presentation/atom/event_card.dart';
import 'package:scheduleapp/presentation/model/event_model.dart';

class PushLocalNotificationCustom {
  EventModel event;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  PushLocalNotificationCustom({this.context,this.event});

  initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSetting = InitializationSettings(android,ios);
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: onSelectNotification);
    //_showNotification();
  }
  Future onSelectNotification(String payload) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Sự kiện"),
          content: EventCard(event: event,),
          actions: <Widget>[
          ],
        )
    );
  }

  void setNotify() async{
     await _showNotification();
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //await flutterLocalNotificationsPlugin.show(0, 'New Post', 'How to Show Notification in Flutter', platformChannelSpecifics, payload: 'Default_Sound',);
    await flutterLocalNotificationsPlugin.schedule(0,event.title ,event.description, event.eventDateFrom, platformChannelSpecifics,payload: event.title,androidAllowWhileIdle: true);
  }
}