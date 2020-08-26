import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:scheduleapp/application/color_app.dart';



class LoginFacebook extends StatefulWidget{
  LoginFacebookState createState() => LoginFacebookState();
}
class LoginFacebookState extends State<LoginFacebook>{
  final _auth = FirebaseAuth.instance;
  final _facebooklogin = FacebookLogin();
  bool isUserSignedIn = false;


  @override
  void initState() {
    super.initState();
    _checkLogin();
  }
  Future _loginWithFacebook() async {

    final result = await _facebooklogin.logIn(['email']);

    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );
//      final user = (await _auth.signInWithCredential(credential)).user;
//      setState(() {
//        print("Logged in as ${user.displayName}");
//        isUserSignedIn = true;
//      });
    }
  }


  Future _logout() async {

    await _auth.signOut();

    await _facebooklogin.logOut();
    setState(() {
      isUserSignedIn = false;
    });
  }

  Future _checkLogin() async {
    final user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        print("Logged in as ${user.displayName}");
        isUserSignedIn = true;
      });
    }
  }
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width / 100;
    double h = MediaQuery
        .of(context)
        .size
        .height / 100;
    return GestureDetector(
      onTap: () async {
        _loginWithFacebook();
        FirebaseUser user = await _checkLogin();
        var userSignedIn = await Navigator.of(context).pushNamed('personal_information');
        setState(() {
          isUserSignedIn = userSignedIn == null ? true : false;
        });
      },
      child: Container(width: w * 75,
        height: h * 8,
        decoration: BoxDecoration(shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: ColorApp.Blue),
        padding: EdgeInsets.fromLTRB(w * 2, h, w * 8, h),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: w * 3),
            SizedBox(width: w * 8,
                height: w * 8,
                child: CircleAvatar(backgroundColor: Colors.white,
                    child: Image.asset(
                        "assets/fb_logo.png", width: h * 3, height: h * 3))),
            SizedBox(width: w * 3),
            Expanded(
              child: Text("Đăng nhập với Facebook", style: TextStyle(
                  fontSize: 18, color: Colors.white
              )),
            )
          ],
        ),),
    );
  }
}