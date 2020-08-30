import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/presentation/page/enter_information.dart';

String your_client_id = "1840745959411312";
String your_redirect_url =
    "https://www.facebook.com/connect/login_success.html";

class LoginFacebook extends StatefulWidget {
  LoginFacebookState createState() => LoginFacebookState();
}

class LoginFacebookState extends State<LoginFacebook> {
  final _auth = FirebaseAuth.instance;
  bool isUserSignedIn = false;
  bool isNewUser = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
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
        final user = await _auth.signInWithCredential(facebookAuthCred);

        AuthResult authResult =
        await _auth.signInWithCredential(facebookAuthCred);
        isNewUser = authResult.additionalUserInfo.isNewUser;
      } catch (e) {}
      if (isNewUser) {
        Navigator.of(context).pushNamed('personal_information');
      } else {
        isUserSignedIn = true;
        Navigator.of(context).pushNamed('home');
        // }
      }
    }
  }
    Widget build(BuildContext context) {
      double w = MediaQuery.of(context).size.width / 100;
      double h = MediaQuery.of(context).size.height / 100;
      return GestureDetector(
        onTap: () async {
          loginWithFacebook();
          FirebaseUser user = await _checkLogin();
          user ??
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyInformationPage()));
        },
        child: Container(
          width: w * 75,
          height: h * 8,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: ColorApp.Blue),
          padding: EdgeInsets.fromLTRB(w * 2, h, w * 8, h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: w * 3),
              SizedBox(
                  width: w * 8,
                  height: w * 8,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset("assets/fb_logo.png",
                          width: h * 3, height: h * 3))),
              SizedBox(width: w * 3),
              Expanded(
                child: Text("Đăng nhập với Facebook",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ],
          ),
        ),
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
          backgroundColor: ColorApp.backgroundColor,
          title: new Text("Facebook login"),
        ));
  }
}
