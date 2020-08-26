import 'dart:core';

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/Event.dart';
import 'user.dart';
class Score{
  String termOne;
  String termTwo;
  String overall;
  Score({@required String termOne, @required String termTwo, @required String overall}):
        termOne = termOne,
        termTwo = termTwo,
        overall = overall;
  setScore(String term1, String term2, String overall) {
    this.termOne = term1;
    this.termTwo = term2;
    this.overall = overall;
  }
}

class ScorePanel extends StatefulWidget {

  @override
  scorePanelState createState() => new scorePanelState();

}
class scorePanelState extends State<ScorePanel>{
  User user;
  String expectedScoreTerm1 = "loading";
  String expectedScoreTerm2 = "loading";
  String expectedScoreOverall = "loading";
  Score curScore;
  Score goalScore;
  FirebaseUser Fuser;
  int count = 0;
  void init() async {
    if (count == 0) {
      final collection = Firestore.instance.collection("users");
      Fuser = await auth.currentUser();
      collection.document(Fuser.uid).get().then((value) {
        setState(() {
          expectedScoreTerm1 = value.data["expectedScore"]["term 1"];
          expectedScoreTerm2 = value.data["expectedScore"]["term 2"];
          expectedScoreOverall = value.data["expectedScore"]["term 3"];
        });
      });
    }
    count = 1;
  }
  scorePanelState() {
    user = User();
  }

  Widget build(BuildContext context)
  {
    curScore = Score(termOne: "8.1", termTwo: "-", overall: "10.0");
    goalScore  = Score(termOne: expectedScoreTerm1, termTwo: expectedScoreTerm2, overall: expectedScoreOverall);

    init();
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return GestureDetector (
        onTap: () => _showMyDialog(),
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
                Text(goalScore.overall,style: TextStyle(fontWeight: FontWeight.bold))
              ],)
            ],
          ),
        )
    );
  }

  Future<void> _showMyDialog() async {
    final _biggerFont = const TextStyle(fontSize: 18.0);
    final _greenFont = const TextStyle(fontSize: 18.0, color: Color(0xFF00C48C));
    TextEditingController HK1 = TextEditingController(text: goalScore.termOne);
    TextEditingController HK2 = TextEditingController(text: goalScore.termTwo);
    TextEditingController All = TextEditingController(text: goalScore.overall);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Điểm mục tiêu", style: _greenFont)),
          content: Container(
              height: 210,
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Container(
                      child: Text("Học kỳ 1", style: _biggerFont,),
                      padding: EdgeInsets.only(top: 5)
                    ),
                    title: _customTextField("Nhập điểm mong muốn", HK1, Color(0xFFBDBDBD)),
                  ),
                  ListTile(
                    leading: Container(
                        child: Text("Học kỳ 2", style: _biggerFont,),
                        padding: EdgeInsets.only(top: 5)
                    ),
                    title: _customTextField("Nhập điểm mong muốn", HK2, Color(0xFFBDBDBD)),
                  ),
                  ListTile(
                    leading: Container(
                        child: Text("Cả năm  ", style: _biggerFont,),
                        padding: EdgeInsets.only(top: 5)
                    ),
                    title: _customTextField("Nhập điểm mong muốn", All, Color(0xFFBDBDBD)),
                  )
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
                  String score1, score2, overall;
                  HK1.text == "" ? score1 = goalScore.termOne : score1 = HK1.text;
                  HK2.text == "" ? score2 = goalScore.termTwo : score2 = HK2.text;
                  All.text == "" ? overall = goalScore.overall : overall = All.text;
                  expectedScoreTerm1 = score1;
                  expectedScoreTerm2 = score2;
                  expectedScoreOverall = overall;
                });
                user.addExpectedScore(expectedScoreTerm1,  expectedScoreTerm2, expectedScoreOverall, Fuser.uid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _customTextField(String hintText, TextEditingController controller, Color color) {
  final _biggerFont = const TextStyle(fontSize: 18.0);
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


