import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scheduleapp/application/color_app.dart';


String your_client_id = "1840745959411312";
String your_redirect_url =
    "https://www.facebook.com/connect/login_success.html";

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

//  Future _loginWithFacebook() async {
//
//    final result = await _facebooklogin.logIn(['email']);
//
//    if (result.status == FacebookLoginStatus.loggedIn) {
//      final credential = FacebookAuthProvider.getCredential(
//        accessToken: result.accessToken.token,
//      );
//
//      final user = (await _auth.signInWithCredential(credential)).user;
//      setState(() {
//        print("Logged in as ${user.displayName}");
//        isUserSignedIn = true;
//      });
//    }
//  }
//
//
//  Future _logout() async {
//
//    await _auth.signOut();
//
//    await _facebooklogin.logOut();
//    setState(() {
//      isUserSignedIn = false;
//    });
//  }
//
  Future _checkLogin() async {
    final user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        print("Logged in as ${user.displayName}");
        isUserSignedIn = true;
      });
    }
  }
  loginWithFacebook() async {
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CustomWebView(
                  selectedUrl:
                  'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
                ),
            maintainState: true));
    if (result != null) {
      try {
        final facebookAuthCred =
        FacebookAuthProvider.getCredential(accessToken: result);
        final user =
        await _auth.signInWithCredential(facebookAuthCred);

      } catch (e) {}
      Navigator.of(context).pushNamed(
          'personal_information');
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
        loginWithFacebook();
//        _loginWithFacebook();
        FirebaseUser user = await _checkLogin();
        user ??  await Navigator.of(context).pushNamed(
              'personal_information');

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
class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ));
  }
}