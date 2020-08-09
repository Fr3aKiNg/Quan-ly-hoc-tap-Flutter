import 'package:flutter/material.dart';

class ChangeBGColorDropdown extends StatefulWidget {
  final Function(Color) onValueSelected;
  ChangeBGColorDropdown(this.onValueSelected);
  @override
  ChangeBGColorDropdownState createState() => ChangeBGColorDropdownState();
}
class ChangeBGColorDropdownState extends State<ChangeBGColorDropdown> {
  List<ColorModel> _colors = [
    ColorModel(color: Colors.blue, colorName: "Blue"),
    ColorModel(color: Colors.redAccent, colorName: "Red Accent"),
    ColorModel(color: Colors.pink, colorName: "Pink"),
    ColorModel(color: Colors.greenAccent, colorName: "Green Accent"),
    ColorModel(color: Colors.amber, colorName: "Amber"),
    ColorModel(color: Colors.brown, colorName: "Brown"),
  ];
  Color _selectedColor;
  @override
  Widget build(BuildContext context) {
    return  DropdownButton<Color>(
        icon: Icon(Icons.lens,color: _selectedColor,),
        iconSize: 30,
        items: _colors.map((color) =>
            DropdownMenuItem<Color>(
              child: Center(child: Icon(Icons.lens,color: color.color,)),
              value: color.color,
            )).toList(),
        onChanged: (Color value) {
          setState(() {
            _selectedColor = value;
            widget.onValueSelected(value);
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