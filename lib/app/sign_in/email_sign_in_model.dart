import 'dart:ui';

import '../validators.dart';


enum EmailSignInFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.loading = false,
    this.submitted = false,
  });
  final String email;
  final String password;
  final EmailSignInFormType formType;
  final bool loading;
  final bool submitted;

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

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      loading: isLoading ?? this.loading,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  int get hashCode =>
      hashValues(email, password, formType, loading, submitted);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final otherModel = other as EmailSignInModel;
    return email == otherModel.email &&
        password == otherModel.password &&
        formType == otherModel.formType &&
        loading == otherModel.loading &&
        submitted == otherModel.submitted;
  }

  @override
  String toString() =>
      'email: $email, password: $password, formType: $formType, isLoading: $loading, submitted: $submitted';
}
