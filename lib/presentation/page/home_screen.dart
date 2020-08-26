import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/Event.dart';
import 'package:scheduleapp/presentation/atom/bottom_navigation_bar.dart';
import 'package:scheduleapp/presentation/atom/event_in_day.dart';
import 'package:scheduleapp/presentation/atom/schedule_of_today.dart';
import 'package:scheduleapp/presentation/atom/thumbnail_new.dart';
import 'package:scheduleapp/presentation/page/ScorePanel.dart';

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
                        child: Text("Xin chào, An !",
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
/*
class ScorePanel extends StatelessWidget{
  Score curScore = Score(termOne: "8.1", termTwo: "-", overall: "-");
  Score goalScore = Score(termOne: "8.0", termTwo: "9.0", overall: "8.5");
  Widget build(BuildContext context)
  {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return GestureDetector (
      child: Container(
        padding: EdgeInsets.fromLTRB(w, h*2, w*5, h),
        width:  w*90,
        height: h*15,
        decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.white,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(""),
                Text(""),
                Text("Đạt được"),
                SizedBox(height: h*2),
                Text("Mục tiêu")
              ],
            ),
            Column(children: <Widget>[
              Text("HK1"),
              SizedBox(height: h*2),
              Text(curScore.termOne,style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: h*2),
              Text(goalScore.termOne,style: TextStyle(fontWeight: FontWeight.bold))
            ],),
            Column(children: <Widget>[
              Text("HK2"),
              SizedBox(height: h*2),
              Text(curScore.termTwo,style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: h*2),
              Text(goalScore.termTwo,style: TextStyle(fontWeight: FontWeight.bold))
            ],),
            Column(children: <Widget>[
              Text("Cả năm "),
              SizedBox(height: h*2),
              Text(curScore.overall,style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: h*2),
              Text(curScore.overall,style: TextStyle(fontWeight: FontWeight.bold))
            ],)
          ],
        ),
      )
    );
  }
}
*/

class EventList extends StatelessWidget {
  List<EventInDay> listEvent = [
    EventInDay(
        date: "16",
        list: [
          Event("Họp hội đồng với bô lão", "12:23 AM"),
          Event("Họp hội đồng với bô lão", "12:23 AM"),
          Event("Họp hội đồng với bô lão", "12:23 AM"),
        ],
        day: "Hôm nay"),
    EventInDay(
        date: "18",
        list: [
          Event("Họp hội đồng với bô lão", "12:23 AM"),
          Event("Họp hội đồng với bô lão", "12:23 AM"),
          Event("Họp hội đồng với bô lão", "12:23 AM"),
        ],
        day: "Thứ 7"),
  ];
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
                child: Text("Sự kiện sắp tới",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.add,
                        color: ColorApp.backgroundColor, size: 24)))
          ],
        ),
        Container(
          width: w * 100,
          height: h * listEvent.length * 16,
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: listEvent.length,
              itemBuilder: (context, index) {
                final item = listEvent[index];
                return EventInDayUI(item);
              }),
        )
      ],
    );
  }
}

/*
Future<void> _showMyDialog(BuildContext context) async {
  TextEditingController newScoreName = TextEditingController();
  TextEditingController newCoef = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text("Thêm cột điểm", style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C)))),
        content: Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Tên cột điểm", style: _biggerFont,),
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: _customTextField("Tên cột điểm mới", newScoreName, Color(0xFFBDBDBD))
                ),
                Text("Hệ số", style: _biggerFont,),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: _customTextField("Hệ số", newCoef, Color(0xFFBDBDBD))
                ),
              ],
            )
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Hủy", style: TextStyle(fontSize: 18.0, color: Color(0xFFBDBDBD))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Thêm', style: TextStyle(fontSize: 18.0, color: Color(0xFF00C48C) ),),
            onPressed: () {
              setState(() {
                nameScoreCol.add(newScoreName.text);
                heso.add(newCoef.text);
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
*/
/*
  Widget _customTextField(String hintText, TextEditingController controller, Color color) {
    return TextFormField(
        style: _biggerFont,
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintStyle: TextStyle(fontSize: 18.0, color: color),
          filled: true,
          enabled: false,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFF00C48C),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Color(0xFFE4E4E4),
              width: 1.0,
            ),
          ),
        )
    );
  }


 */
