import 'package:flutter/widgets.dart';
import 'package:time_tracker/common_widgets/CustomElevatedButton.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton(
      {@required String text,
      Color color,
      Color textColor,
      VoidCallback onPressed})
      : assert(text != null),
        super(
            child:
                Text(text, style: TextStyle(color: textColor, fontSize: 15.0)),
            color: color,
            onPressed: onPressed);
}
