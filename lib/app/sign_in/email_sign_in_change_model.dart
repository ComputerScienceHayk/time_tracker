import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

import '../validators.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.loading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool loading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.valid(email) &&
        passwordValidator.valid(password) &&
        !loading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.valid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.valid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.loading = isLoading ?? this.loading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
