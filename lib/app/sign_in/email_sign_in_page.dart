import 'package:flutter/material.dart';

import 'email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Sign in"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            elevation: 1.0,
            // child: EmailSignInFormBlocBased.create(context),
            child: EmailSignInFormChangeNotifier.create(context),
          ),
        ),
      ),
    );
  }
}
