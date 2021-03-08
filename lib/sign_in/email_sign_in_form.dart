import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/FormSubmitButton.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/show_exception_alert_dialog.dart';
import 'package:time_tracker/sign_in/validators.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  void _submit() async {
    _submitted = true;
    _isLoading = true;

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createAccountWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionDialog(
        context,
        title: 'Sign In Failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _controllerEmail.clear();
    _controllerPassword.clear();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String get _email => _controllerEmail.text;

  String get _password => _controllerPassword.text;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  bool _submitted = false;

  bool _isLoading = false;

  @override
  void dispose(){
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create Account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildEmailTextField() {
    bool showErrorMessage =
        _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
        focusNode: _emailFocusNode,
        controller: _controllerEmail,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'test@test.com',
            errorText:
                showErrorMessage ? widget.invalidEmailValidatorError : null,
            enabled: _isLoading == false),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        onChanged: (email) => _updateState);
  }

  TextField _buildPasswordTextField() {
    bool showErrorMessage =
        _submitted && !widget.passwordValidator.isValid(_email);

    return TextField(
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText:
            showErrorMessage ? widget.invalidPasswordValidatorError : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
