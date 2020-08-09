import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Icon icon;
  CustomTextField({
    @required this.labelText, this.controller, this.icon,
});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          labelText: labelText,
        prefixIcon: icon,
      ),
    );
  }
}
