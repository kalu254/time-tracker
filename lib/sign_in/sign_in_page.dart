import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/show_exception_alert_dialog.dart';
import 'package:time_tracker/sign_in/sign_in_button.dart';
import 'package:time_tracker/sign_in/social_sig_sign_button.dart';

import 'email_sign_in_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoadingState = false;

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      setState(() => _isLoadingState = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      final user = await auth.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoadingState = false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      setState(() => _isLoadingState = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoadingState = false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      setState(() => _isLoadingState = true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() => _isLoadingState = false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
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
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(
            height: 48,
          ),
          SocialSignInButton(
            assetName: 'images/google_icon.png',
            text: "Sign in with Google",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed:_isLoadingState ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assetName: 'images/facebook_icon.png',
            text: "Sign in with Facebook",
            color: Colors.blue[1500],
            textColor: Colors.white,
            onPressed:_isLoadingState ? null :() => _signInWithFacebook(context),
          ),
          SizedBox(height: 8),
          SignInButton(
            text: "Sign in with Email",
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed:_isLoadingState ? null : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8,
          ),
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
            onPressed:_isLoadingState ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_isLoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
