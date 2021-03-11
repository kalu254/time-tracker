import 'package:flutter/widgets.dart';
import 'package:time_tracker/common_widgets/CustomElevatedButton.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton(
      {@required String text,
      @required String assetName,
      Color color,
      Color textColor,
      VoidCallback onPressed})
      : assert(text != null),
        assert(assetName != null),
        super(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(assetName),
                Text(
                  text,
                  style: TextStyle(color: textColor, fontSize: 15.0),
                ),
                Opacity(
                  opacity: 0.0,
                  child: Image.asset(assetName),
                ),
              ],
            ),
            color: color,
            onPressed: onPressed);
}
