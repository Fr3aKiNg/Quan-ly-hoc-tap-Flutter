import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final Color color;
  final Color textColor;
  final Color borderColor;

  CustomButton({
  @required this.onPressed,
  this.buttonText,
  this.color,
  this.textColor,
  this.borderColor = Colors.transparent
});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      onPressed: onPressed,
      textColor: textColor,
      padding: const EdgeInsets.all(14.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: Text(buttonText),
    );
  }
}
