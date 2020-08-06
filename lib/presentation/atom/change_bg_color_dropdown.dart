import 'package:flutter/material.dart';

class ChangeBGColorDropdown extends StatefulWidget {
  Color selectedColor;
  ChangeBGColorDropdown(this.selectedColor);
  @override
  ChangeBGColorDropdownState createState() {
    return new ChangeBGColorDropdownState(this.selectedColor);
  }
}
class ChangeBGColorDropdownState extends State<ChangeBGColorDropdown> {
  List<ColorModel> _colors = [
    ColorModel(color: Colors.blue, colorName: "Blue"),
    ColorModel(color: Colors.purple, colorName: "Purple"),
    ColorModel(color: Colors.pink, colorName: "Pink"),
    ColorModel(color: Colors.teal, colorName: "Teal"),
    ColorModel(color: Colors.amber, colorName: "Amber"),
    ColorModel(color: Colors.brown, colorName: "Brown"),
  ];
  ChangeBGColorDropdownState(this._selectedColor);
  Color _selectedColor;
  @override
  Widget build(BuildContext context) {
    return  DropdownButton<Color>(
        icon: Icon(Icons.add_circle,color: _selectedColor,),
        iconSize: 30,
        items: _colors.map((color) =>
            DropdownMenuItem<Color>(
              child: Center(child: Icon(Icons.add_circle,color: color.color,)),
              value: color.color,
            )).toList(),
        onChanged: (Color value) {
          setState(() {
            _selectedColor = value;
          });
        },
      );
  }
}

//Create a Model class to hold key-value pair data
class ColorModel {
  String colorName;
  Color color;
  ColorModel({this.colorName, this.color});
}