import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scheduleapp/presentation/atom/event_card.dart';

class PushLocalNotificationCustom {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;
  PushLocalNotificationCustom(this.context);

  initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSetting = InitializationSettings(android,ios);
    await flutterLocalNotificationsPlugin.initialize(initSetting,onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Notification"),
          content: EventCard(),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        )
    );
  }

  void show(){
    _showNotification();
  }

  Future _showNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    //await flutterLocalNotificationsPlugin.show(0, 'New Post', 'How to Show Notification in Flutter', platformChannelSpecifics, payload: 'Default_Sound',);
    await flutterLocalNotificationsPlugin.schedule(1,'Testing' , 'hahahhahahaa', DateTime.now().add(Duration(seconds: 2)), platformChannelSpecifics,payload: "FUCK",androidAllowWhileIdle: true);
  }
}