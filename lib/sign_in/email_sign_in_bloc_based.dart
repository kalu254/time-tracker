import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/FormSubmitButton.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/sign_in/show_exception_alert_dialog.dart';
import 'package:time_tracker/sign_in/validators.dart';


class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidator {
  EmailSignInFormBlocBased({@required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void _submit() async {

    try {
     await widget.bloc.submit();
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

  void _toggleFormType(EmailSignInModel model) {
    widget.bloc.updateWith(
      email: '',
        password: '',
        formType: model.formType == EmailSignInFormType.signIn
            ? EmailSignInFormType.register : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
    );


    _controllerEmail.clear();
    _controllerPassword.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email)
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

  List<Widget> _buildChildren(EmailSignInModel model) {
    final primaryText =
        model.formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create Account';
    final secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
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
        onPressed: !model.isLoading ? ()=> _toggleFormType(model) : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorMessage =
        model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
        focusNode: _emailFocusNode,
        controller: _controllerEmail,
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'test@test.com',
            errorText:
                showErrorMessage ? widget.invalidEmailValidatorError : null,
            enabled: model.isLoading == false),
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (email) => widget.bloc.updateWith(email: email),
        onEditingComplete:() => _emailEditingComplete(model));
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool showErrorMessage =
        model.submitted && !widget.passwordValidator.isValid(model.password);

    return TextField(
      controller: _controllerPassword,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText:
            showErrorMessage ? widget.invalidPasswordValidatorError : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => widget.bloc.updateWith(password: password),
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          ),
        );
      }
    );
  }


}
