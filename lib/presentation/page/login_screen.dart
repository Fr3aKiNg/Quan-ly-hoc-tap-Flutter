import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/presentation/facebook_login.dart';
import 'package:scheduleapp/presentation/onBoard/on_board_detail.dart';

class LoginScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Material(
      child: Scaffold(body:SingleChildScrollView(
        child: Stack(children:[
          Container(
              width: w * 100,
              height: h * 45,
              decoration: BoxDecoration(
                color: ColorApp.backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(160, 50),
                    bottomRight: Radius.elliptical(160, 50)),
              )),
          Container(margin: EdgeInsets.fromLTRB(w, h*17, w*3, h*6),
            padding: EdgeInsets.fromLTRB(w*4, 0, w*2, 0),
            width: w*100,height: h*100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/login.png",
                  fit: BoxFit.cover,
                  width: w * 100,
                  height: h * 42,
                ),
                Container(width: w*100,
                  child: Center(
                    child: Text("Đăng nhập để bắt đầu cùng Educare !",style: TextStyle(
                      fontSize: 20,color: ColorApp.backgroundColor,fontWeight: FontWeight.w400
                    ),),
                  ),
                ),
                SizedBox(height: h*3),
                LoginGoogle(),
                SizedBox(height: h*3),
                LoginFacebook()
              ],
            )),
      ])),
    ));
  }
}