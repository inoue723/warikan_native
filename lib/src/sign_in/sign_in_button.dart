import 'package:flutter/material.dart';
import 'package:warikan_native/src/common_widgets/custom_raised_buddon.dart';

class SignInButton extends CustomeRaisedButton {
  SignInButton({
    String text,
    Color color,
    Color textColor,
    VoidCallback onPressed,
  }) : super(
          child: Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
          color: color,
          borderRadius: 8.0,
          onPressed: onPressed,
        );
}
