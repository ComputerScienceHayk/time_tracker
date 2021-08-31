import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,

  }): super(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    ),
    height: 44.0,
    borderRadius: 4.0,
    onPressed: onPressed,
    color: color,
  );
}