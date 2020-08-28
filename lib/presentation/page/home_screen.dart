import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/application/constant.dart';
import 'package:scheduleapp/data/Event.dart';
import 'package:scheduleapp/data/model/database.dart';
import 'package:scheduleapp/data/model/event_model.dart';
import 'package:scheduleapp/presentation/atom/bottom_navigation_bar.dart';
import 'package:scheduleapp/presentation/atom/event_in_day.dart';
import 'package:scheduleapp/presentation/atom/schedule_of_today.dart';
import 'package:scheduleapp/presentation/atom/thumbnail_new.dart';
import 'package:scheduleapp/presentation/page/ScorePanel.dart';
import 'package:scheduleapp/presentation/page/calender_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ScrollController controller = ScrollController();
  int _selectedItem = 0;

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
        bottomNavigationBar:
        BottomAppBar(
          child: CustomBottomNavigationBar(
            iconList: [
              Icons.home,
              Icons.assessment,
              Icons.note,
              Icons.dashboard,
            ],
            onChange: (val) {
              setState(() {
                _selectedItem = val;
              });
            },
            defaultSelectedIndex: 0,
            btnName: ["Tổng quan", "Điểm", "Ghi chú", "Khác"],
          ),
        ),
        body: SingleChildScrollView(
          controller: controller,
          child: Stack(children: <Widget>[
            Container(
                width: w * 100,
                height: h * 25,
                decoration: BoxDecoration(
                  color: ColorApp.backgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(160, 50),
                      bottomRight: Radius.elliptical(160, 50)),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(w * 5, h * 10, w * 5, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text("Xin chào bạn",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: h * 2),
                      ScorePanel(),
                      SizedBox(height: h * 2),
                      EventList(),
                      SizedBox(height: h * 2),
                      Text("Thời khóa biểu hôm nay (16/07)",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: h * 2),
                      ScheduleOfToday(),
                      SizedBox(height: h * 2),
                      ThumbnailNews()
                    ]))
          ]),
        ));
  }
}

class Score {
  String termOne;
  String termTwo;
  String overall;
  Score(
      {@required String termOne,
      @required String termTwo,
      @required String overall})
      : termOne = termOne,
        termTwo = termTwo,
        overall = overall;
}


class EventList extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  void getUid() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    // here you write the codes to input the data into firestore
  }
  EventList(){
   getUid();
  }
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                flex: 12,
                child: Text("Sự kiện",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalenderPage()),
                      );
                    },
                    child: Icon(Icons.add,
                        color: ColorApp.backgroundColor, size: 24)))
          ],
        ),
        Container(
          width: w * 100,
          height: h  * 16,
          child: StreamBuilder<List<EventModel>>(
              stream: eventDBS.streamList(),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<EventModel> allEvents = [];
                  for (int i = 0; i<snapshot.data.length;i++){
                    if(snapshot.data.elementAt(i).uid==uid)
                      allEvents.add(snapshot.data.elementAt(i));
                  }
                  if (allEvents.isNotEmpty){
                    return ListView.builder(
                        itemCount: allEvents.length,
                        padding: EdgeInsets.only(top:0),
                        itemBuilder: (context,index){
                          return EventInDayUI(allEvents[index]);
                          //return Text(allEvents[index].title);
                        }
                    );
                  }
                  else{
                    return Text("No event");
                  }
                }
                else{
                  return Center(child: CircularProgressIndicator()) ;
                }
              }
          ),
          /*ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: listEvent.length,
              itemBuilder: (context, index) {
                final item = listEvent[index];
                return EventInDayUI(item);
              }),*/
        )
      ],
    );
  }
}

