import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import '../validators.dart';
import 'email_sign_in_model.dart';


class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  final VoidCallback? onSignedIn;
  EmailSignInFormStateful({this.onSignedIn});
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful>  {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode  _emailFocusNode = FocusNode();
  final FocusNode  _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    print("typed");
    setState(() {
      _submitted = true;
      _loading = true;
    });

    try {
      final auth = Provider.of<AuthBase>(context, listen: false,);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      if (widget.onSignedIn != null) {
        widget.onSignedIn!();
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Sign in failed",
        exception: e,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }

    print("email: ${_emailController.text} and $_email");
    print("password: ${_passwordController.text} and $_password");

  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.valid(_email) ?
    _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && widget.emailValidator.valid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _loading == false ? true : false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && widget.passwordValidator.valid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText: null,
      ),
      enabled: _loading == false ? true : false,
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (email) => _updateState(),
    );
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? "Sign in"
        : "Create an account";
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an account? Register"
        : "Have an account? Sign in";
    bool submitEnabled = widget.emailValidator.valid(_email) &&
        widget.passwordValidator.valid(_password) && !_loading;

    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        color: submitEnabled ? Colors.indigo :Color(0xFFF2F2F2),
        onPressed: submitEnabled == true ? _submit: (){},
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
        child: Text(secondaryText),
        onPressed: !_loading ? _toggleFormType: null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }

  _updateState() {
    setState(() {});
  }

}
