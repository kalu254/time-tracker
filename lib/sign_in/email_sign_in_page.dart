import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(),
          ),
        ),
      ),
    );
  }

}
