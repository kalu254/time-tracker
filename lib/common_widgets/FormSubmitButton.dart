import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/CustomElevatedButton.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed
  }) : super(
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0
        ),
      ),

      height: 44.0,
      color: Colors.indigo,
      borderRadius: 8.0,
      onPressed: onPressed

  );
}
