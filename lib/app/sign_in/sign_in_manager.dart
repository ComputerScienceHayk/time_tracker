import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/services/auth.dart';

class SignInManager {
  SignInManager({required this.auth, required this.loading});
  final AuthBase auth;
  final ValueNotifier<bool> loading;


  Future<User?> _signIn(Future<User?> Function() signInMethod) async{
    try {
     loading.value = true;
      return await signInMethod();
    } catch(e){
      loading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async => await _signIn(auth.signInAnonymously);
  Future<User?> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
  Future<User?> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);

}