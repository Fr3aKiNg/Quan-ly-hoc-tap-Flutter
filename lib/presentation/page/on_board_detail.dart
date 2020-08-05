import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scheduleapp/application/color_app.dart';

class OnBoardDetail {
  String imgUrl;
  String title;
  String des;
  Widget loginFB;
  Widget loginGG;
  Widget continueBtn;
  OnBoardDetail({@required String img, @required String title, @required String des,
    @required Widget loginFacebook, @required Widget loginGoogle, @required Widget continueBtn}):
        imgUrl = img,
        title = title,
        des = des,
        loginFB = loginFacebook,
        loginGG = loginGoogle,
        continueBtn = continueBtn;
}

class OnBoardInfo extends StatelessWidget {
  OnBoardDetail item;
  OnBoardInfo(OnBoardDetail _item) : item = _item;
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(margin: EdgeInsets.fromLTRB(0, h*15, w*3, 0),
        padding: EdgeInsets.fromLTRB(w*4, 0, w*2, 0),
        width: w*100,height: h*100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Image.asset(
              item.imgUrl,
              fit: BoxFit.cover,
              width: w * 100,
              height: h * 45,
            ),
            item.title != ""  ? Text(item.title,
                style: TextStyle(fontSize: 32, color: Colors.black,fontWeight: FontWeight.w600)) : LoginGoogle(),
            SizedBox(height: h * 5),
            Text(item.des, style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(height: h * 6),
            Align(alignment: Alignment.bottomRight,child: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('home');
                },
                child: Text("Bỏ qua",
                    style: TextStyle(fontSize: 16, color: Colors.grey))))
          ],
        ));
  }
}
class LoginGoogle extends StatefulWidget
{
  LoginGoogleState createState() => LoginGoogleState();
}
class LoginGoogleState extends State<LoginGoogle> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();

    checkIfUserIsSignedIn();
  }
  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    FirebaseUser user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = await _auth.currentUser();
    }
    else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }
  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    var userSignedIn = await Navigator.of(context).pushNamed('list_course');
//    await Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) =>
//              WelcomeUserWidget(user, _googleSignIn)),
//    );

    setState(() {
      isUserSignedIn = userSignedIn == null ? true : false;
    });
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
        onGoogleSignIn(context);
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
                        "assets/gg_logo.png", width: h * 3, height: h * 3))),
            SizedBox(width: w * 5),
            Text("Đăng nhập bằng Google", style: TextStyle(
                fontSize: 18, color: Colors.white
            ))
          ],
        ),),
    );
  }
}
class WelcomeUserWidget extends StatelessWidget {

  GoogleSignIn _googleSignIn;
  FirebaseUser _user;

  WelcomeUserWidget(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(50),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                        child: Image.network(
                            _user.photoUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover
                        )
                    ),
                    SizedBox(height: 20),
                    Text('Welcome,', textAlign: TextAlign.center),
                    Text(_user.displayName, textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                    SizedBox(height: 20),
                    FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _googleSignIn.signOut();
                          Navigator.pop(context, false);
                        },
                        color: Colors.redAccent,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.exit_to_app, color: Colors.white),
                                SizedBox(width: 10),
                                Text('Log out of Google', style: TextStyle(color: Colors.white))
                              ],
                            )
                        )
                    )
                  ],
                )
            )
        )
    );
  }
}