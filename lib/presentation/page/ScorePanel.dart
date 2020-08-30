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

  String scoreTerm1 = "loading";
  String scoreTerm2 = "loading";
  String scoreOverall = "loading";

  Score curScore;
  Score goalScore;
  FirebaseUser Fuser;
  int count = 0;

  bool valid = false;
  String scoreError = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  void init() async {
    if (count == 0) {
      final collection = Firestore.instance.collection("users");
      Fuser = await auth.currentUser();
      print("aaaa " + Fuser.uid );
      collection.document(Fuser.uid).get().then((value) {
        setState(() {
          expectedScoreTerm1 = value.data["expectedScore"]["term 1"];
          expectedScoreTerm2 = value.data["expectedScore"]["term 2"];
          expectedScoreOverall = value.data["expectedScore"]["term 3"];
          scoreTerm1 = value.data["year1"]["HK1"]["final"];
          scoreTerm2 = value.data["year1"]["HK2"]["final"];
          scoreOverall = value.data["year1"]["overall"]["final"];
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
    curScore = Score(termOne: scoreTerm1, termTwo: scoreTerm2, overall: scoreOverall);
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
              height: 250,
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
                  ),
                  Container (
                      margin: EdgeInsets.only(top: 10),
                      child:
                      Center(
                        child: Text(scoreError, style: TextStyle(color: Colors.red),),
                      )
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
                  valid = false;
                  String score1, score2, overall;
                  double tempScore1 = 0;
                  double tempScore2 = 0;
                  double tempScore3 = 0;

                  bool check1 = false;
                  bool check2 = false;
                  bool check3 = false;

                  if (HK1.text == "-" || HK1.text == "")
                    check1 = true;
                  if (HK2.text == "-" || HK2.text == "")
                    check2 = true;
                  if (All.text == "-" || All.text == "")
                    check3 = true;

                  if (check1 == false) {
                    tempScore1 = double.parse(HK1.text);
                    if (tempScore1 < 0)
                      tempScore1 *= -1;
                  }

                  if (check2 == false) {
                    tempScore2 = double.parse(HK2.text);
                    if (tempScore2 < 0)
                      tempScore2 *= -1;
                  }
                  if (check3 == false) {
                    tempScore3 = double.parse(All.text);
                    if (tempScore3 < 0)
                      tempScore3 *= -1;
                  }

                  if (check1 == false)
                    if (tempScore1 > 10)
                    {
                      valid = true;
                    }
                  if (check2 == false)
                    if (tempScore2 > 10)
                    {
                      valid = true;
                    }

                  if (check3 == false)
                    if (tempScore3 > 10)
                    {
                      valid = true;
                    }

                  if (valid) {
                    setState(() {
                      scoreError = "Nhập điểm <= 10";
                    });
                    Navigator.of(context).pop();
                    _showMyDialog();
                  }
                  else {
                    scoreError = "";
                    setState(() {
                      HK1.text == "" ? expectedScoreTerm1 = "-" : expectedScoreTerm1 = HK1.text;
                      HK2.text == "" ? expectedScoreTerm2 = "-" : expectedScoreTerm2 = HK2.text;
                      All.text == "" ? expectedScoreOverall = "-" : expectedScoreOverall = All.text;
                    });
                    User user = User();
                    user.addExpectedScore(expectedScoreTerm1, expectedScoreTerm2, expectedScoreOverall, Fuser.uid);
                    Navigator.of(context).pop();
                  }
                  //scoreError = "";

                }
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
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintStyle: TextStyle(fontSize: 18.0, color: color),
        filled: true,
        enabled: true,
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


