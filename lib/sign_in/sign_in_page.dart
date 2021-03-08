import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/sign_in_button.dart';
import 'package:time_tracker/sign_in/social_sig_sign_button.dart';

import 'email_sign_in_page.dart';


class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.auth}) : super(key: key);

  final Auth auth;
  Future<void> _signInAnonymously() async{
    try {
      final user = await auth.signInAnonymously();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async{
    try {
      await auth.signInWithGoogle();
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async{
    try {
      await auth.signInWithFacebook();
    }catch(e){
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
          builder: (context) => EmailSignInPage(auth: auth,),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
        elevation: 2,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 48),
          SocialSignInButton(
            assetName: 'images/google_icon.png',
            text: "Sign in with Google",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 8),
          SocialSignInButton(
            assetName: 'images/facebook_icon.png',
            text: "Sign in with Facebook",
            color: Colors.blue[1500],
            textColor: Colors.white,
            onPressed: _signInWithFacebook,
          ),
          SizedBox(height: 8),
          SignInButton(
            text: "Sign in with Email",
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8),
          Text(
            "or",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          SignInButton(
            text: "Go anonymous ",
            color: Colors.lime[800],
            textColor: Colors.white,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
