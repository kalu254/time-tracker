import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/FormSubmitButton.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/sign_in/email_sign_in_model.dart';

import 'email_sign_in_change_model.dart';


class EmailSignInFormChangeNotifier extends StatefulWidget
     {
  EmailSignInFormChangeNotifier({@required this.model});

  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model,),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  void _submit() async {

    try {
     await model.submit();
     Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showAlertDialog(
        context,
        title: 'Sign In Failed',
        content: e.message,
        defaultActionText: 'OK',
      );
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _controllerEmail.clear();
    _controllerPassword.clear();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  List<Widget> _buildChildren() {

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
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      ),
    ];
  }

  TextField _buildEmailTextField() {

    return TextField(
        focusNode: _emailFocusNode,
        controller: _controllerEmail,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'test@test.com',
            errorText: model.emailErrorText,
            enabled: model.isLoading == false),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: model.updateEmail,
        onEditingComplete:() => _emailEditingComplete());
  }

  TextField _buildPasswordTextField() {
       return TextField(
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: model.updatePassword,
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



}
