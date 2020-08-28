import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/data/model/note.dart';
import 'package:scheduleapp/data/model/user.dart';
import 'package:scheduleapp/presentation/atom/bottom_navigation_bar.dart';
import 'package:scheduleapp/presentation/page/calender_page.dart';
import 'package:scheduleapp/presentation/page/login_screen.dart';
import 'package:scheduleapp/presentation/page/note/note_screen.dart';
import 'package:scheduleapp/presentation/page/timetable_page.dart';
import 'package:scheduleapp/presentation/page/user.dart';

class OtherScreen extends StatefulWidget {
  OtherState createState() => OtherState();
}

class OtherState extends State<OtherScreen> {
  List<String> item = ["Thời khóa biểu", "Sự kiện", "Đọc báo"];

  List<IconData> iconItem = [
    Icons.calendar_today,
    Icons.today,
    Icons.collections_bookmark
  ];
  bool isLogout;
  String userName;
  void getName() async {
    FirebaseUser user = await auth.currentUser();
    setState(() {
      userName = user.displayName;
    });
  }
  void initState() {
    super.initState();
    // setState(() {
      getName();
    // });
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController controller = ScrollController();
  int _selectedItem = 0;


  Future<bool> isUserLogged() async {
    FirebaseUser firebaseUser = await getLoggedFirebaseUser();
    if (firebaseUser != null) {
      IdTokenResult tokenResult = await firebaseUser.getIdToken(refresh: true);
      return tokenResult.token != null;
    } else {
      return false;
    }
  }
  Future<FirebaseUser> getLoggedFirebaseUser() {
    return auth.currentUser();
  }
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  _signOut() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }

  Widget build(BuildContext context) {
    final name = Provider.of<CurrentUser>(context)?.data?.displayName;

    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text("Khác",
            softWrap: false,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 22,
            )),
        backgroundColor: ColorApp.backgroundColor,
      ),
      bottomNavigationBar: BottomAppBar(
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
        defaultSelectedIndex: 3,
        btnName: ["Tổng quan", "Điểm", "Ghi chú", "Khác"],
      )),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: w * 100,
            height: h * 8,
            child: GestureDetector(
              onTap: () {


                setState(() {
                   userName != null ?
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                            color: Colors.white,
                            width: w * 100,
                            height: h * 18,
                            padding: EdgeInsets.fromLTRB(
                                w * 3, h * 2, w * 3, h),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Bạn có muốn đăng xuất khỏi Educare?",
                                  style: (TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(
                                            child: Text(
                                              "Hủy",
                                              style: TextStyle(
                                                  color: ColorApp
                                                      .backgroundColor,
                                                  fontSize: 16),
                                            )),
                                        color: Colors.white),
                                    RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15)),
                                        onPressed: () {
                                          setState(() {
                                            _signOut();
                                            userName = null;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Center(
                                            child: Text(
                                              "Đăng xuất",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            )),
                                        color: ColorApp.backgroundColor)
                                  ],
                                )
                              ],
                            )),
                      );
                    })
                    : Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
              });
              },
              child: MergeSemantics(
                child: ListTile(
                  title: Text(name != null ? name : "Tài khoản",
                      style: TextStyle(fontSize: 18)),
                  leading: _buildAvatar(context),
                ),
              ),
            )),
        Container(
          width: w * 100,
          height: h * 7 * item.length,
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return listItem(context, item[index], iconItem[index]);
              }),
        ),
      ]),
    );
  }

  Widget listItem(BuildContext context, String title, IconData icon) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return GestureDetector(
      onTap: () {
        if (title == "Thời khóa biểu")
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimetablePage()),
          );
        else if (title == "Sự kiện") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CalenderPage()),
          );
        }
      },
      child: Container(
        width: w * 100,
        height: h * 6,
        margin: EdgeInsets.only(left: w * 4, bottom: h * 0.6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40,
              color: Colors.grey,
            ),
            SizedBox(width: 15),
            Text(title, style: TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}

Widget _buildAvatar(BuildContext context) {
  final url = Provider.of<CurrentUser>(context)?.data?.photoUrl;
  return CircleAvatar(
    backgroundImage: url != null ? NetworkImage(url) : null,
    child: url == null ? const Icon(Icons.face) : null,
    radius: 20,
  );
}

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = Provider.of<CurrentUser>(context)?.data?.displayName;
    return ChangeNotifierProvider(
        create: (_) => NoteFilter(), // watching the note filter
        child: Consumer2<NoteFilter, List<Note>>(
            builder: (context, filter, notes, child) {
          return GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => _logOutDialog(context));
            },
            child: MergeSemantics(
              child: ListTile(
                // title: Text(name),
                leading: _buildAvatar(context),
              ),
            ),
          );
        }));
  }
}

Widget _logOutDialog(BuildContext context) {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  _signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  double h = MediaQuery.of(context).size.height / 100;
  double w = MediaQuery.of(context).size.width / 100;
  return Dialog(
    child: Container(
        color: Colors.white,
        width: w * 100,
        height: h * 18,
        padding: EdgeInsets.fromLTRB(w * 3, h * 2, w * 3, h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Bạn có muốn đăng xuất khỏi Educare?",
              style: (TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "Hủy",
                      style: TextStyle(
                          color: ColorApp.backgroundColor, fontSize: 16),
                    )),
                    color: Colors.white),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      _signOut();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                    color: ColorApp.backgroundColor)
              ],
            )
          ],
        )),
  );
}
