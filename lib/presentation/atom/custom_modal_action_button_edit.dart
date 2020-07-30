import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onEdit;

  CustomModalActionButton({
    @required this.onClose,
    @required this.onEdit
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButton(
          onPressed: onClose,
          buttonText: "Close",
        ),
        CustomButton(
          onPressed: onEdit,
          buttonText: "Edit",
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
