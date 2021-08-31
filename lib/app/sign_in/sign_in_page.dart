import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'email_sign_in_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key? key,
    required this.manager,
    required this.loading,
  }) : super(key: key);

  final SignInManager manager;
  final bool loading;
  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, loading, __) => Provider<SignInManager>(
          create: (_)=> SignInManager(auth: auth, loading: loading,),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(manager: manager, loading: loading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if(exception is FirebaseException && exception.code == "ERROR_ABORTED_BY_USER") {
      return;
    }
    showExceptionAlertDialog(
        context,
        title: "Sign in failed",
        exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context,e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    }  on Exception catch (e) {
      _showSignInError(context,e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    }  on Exception catch (e) {
      _showSignInError(context,e);
    }
  }

   void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
            child:_buildHeader(),
          ),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButton(
            assetName: 'assets/images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: loading ? null: () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            assetName: 'assets/images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: loading ? null: () => _signInWithFacebook(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: "Sign in with email",
            color: Colors.teal[700]!,
            textColor: Colors.white,
            onPressed: loading ? null: ()=> _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "or",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300]!,
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
  Widget _buildHeader() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
