import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';

import 'home_screen.dart';
import 'user.dart';
class MyListCoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "List course", home: RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<String> _courses = <String>[
    "Toán",
    "Vật lý",
    "Hóa học",
    "Anh văn",
    "Sinh học",
    "Ngữ văn",
    "Lịch sử",
    "Địa lí",
    "Công dân",
    "Công nghệ",
    "Tin học",
    "Quốc phòng",
    "Âm nhạc",
    "Mỹ thuật",
    "Thể dục"
  ];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<String> _saved = new Set<String>();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String _value = "";
    return Scaffold(
        appBar: RoundedAppBar(),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                padding: EdgeInsets.only(left: 3),
                child: TextFormField(
                  controller: nameController,
                  style: _biggerFont,
                  onChanged: (text) {
                    _value = text;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText: 'Thêm môn học',
                      filled: true,
                      suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            addItemToList();
                          })),
                ),
              ),
              Expanded(
                  child: SizedBox(
                height: 500,
                child: ListView.builder(itemBuilder: (context, index) {
                  if (index < _courses.length)
                    return Container(
                        child: Column(
                          children: <Widget>[
                            _buildRow(_courses[index]),
                            Divider()
                          ],
                        ),
                        margin: null,
                        color: null);
                  else
                    return null;
                }),
              )),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: (ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 50),
                    child: (RaisedButton(
                        onPressed: () {
                          User user = User();
                          user.addCourse(_saved);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                        color: Color(0xFF00C48C),
                        textColor: Colors.white,
                        disabledTextColor: Colors.white,
                        child: Text("Bắt đầu", style: _biggerFont),
                        disabledColor: Color(0xFF00C48C))))),
              )
            ],
          ),
        ));
  }

  Widget _buildRow(String wordPair) {
    final bool alreadySaved = _saved.contains(wordPair);
    return ListTile(
      title: Text(
        wordPair,
        style: _biggerFont,
      ),
      trailing: new Icon(
          alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
          color: alreadySaved ? Color(0xFF00C48C) : null),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(wordPair);
          } else {
            _saved.add(wordPair);
          }
        });
      },
    );
  }

  void addItemToList() {
    setState(() {
      _courses.insert(0, nameController.text);
      _saved.add(nameController.text);
      nameController.text = "";
    });
  }
}

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final _appbarFont = const TextStyle(
      fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
          child: Text(
        "Chọn môn học",
        style: _appbarFont,
      )),
      decoration: new BoxDecoration(
        color: Color(0xFF00C48C),
        boxShadow: [new BoxShadow(blurRadius: 2.0)],
        borderRadius: new BorderRadius.vertical(
            bottom: new Radius.elliptical(
                MediaQuery.of(context).size.width, 100.0)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200.0);
}

void Start() {}
