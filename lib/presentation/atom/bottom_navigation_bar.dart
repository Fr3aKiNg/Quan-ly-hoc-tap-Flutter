import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;
  final List<String> btnName;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
        @required this.iconList,
        @required this.onChange,@required this.btnName});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];
  List<String> _btnName = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
    _btnName = widget.btnName;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i,_btnName[i]));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index,String name) {
    double h  = MediaQuery.of(context).size.height/100;
    double w  = MediaQuery.of(context).size.width/100;
    return GestureDetector(
        onTap: () {
          widget.onChange(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, h*1.5, 0, h),
          height: h*10,
          width: MediaQuery.of(context).size.width / _iconList.length,
          decoration: index == _selectedIndex
              ? BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 4, color: Colors.white),
            ),
          )
              : BoxDecoration(),
          child: Column(
              children: <Widget>[
                Icon(
                    icon,
                    color: index == _selectedIndex ? ColorApp.backgroundColor : Colors.grey,
                    size: 28),
                Text(name, style: TextStyle(color:index == _selectedIndex ? ColorApp.backgroundColor : Colors.grey ),)
              ]),
        ));
  }
}
