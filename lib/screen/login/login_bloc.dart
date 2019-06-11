import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/user.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginBloc extends BlocBase{

  final _txtGoogleBtnSubject = BehaviorSubject<String>.seeded(Strings.msgSignInWithGoogle);
  final _signedInEmailSubject = BehaviorSubject<String>.seeded("");
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<String> get textBtnGoogleStream => _txtGoogleBtnSubject.stream;
  Stream<String> get signedInEmailStream => _signedInEmailSubject.stream;
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void dispose() {
    _txtGoogleBtnSubject.close();
    _signedInEmailSubject.close();
    _isLoadingSubject.close();
  }

  final _googleSignIn = new GoogleSignIn(scopes: ['email']);
  String _email;
  bool _isGoogleLogin = false;
  SimpleAlertDialogMixin _simpleAlertDialogMixin;

  LoginBloc({@required SimpleAlertDialogMixin mixin}) {
    _simpleAlertDialogMixin = mixin;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        _signedInEmailSubject.add(account.email);
        _txtGoogleBtnSubject.add(Strings.signOutFromGoogle);
        _isGoogleLogin = true;
        _email = account.email;
      } else {
        _signedInEmailSubject.add("");
        _txtGoogleBtnSubject.add(Strings.msgSignInWithGoogle);
        _isGoogleLogin = false;
        _email = null;
      }
    });
  }

  Future<bool> login(String username, String password) async {
    if (_email == null || _email.isEmpty) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please login google account");
    } else {
      try {
        _isLoadingSubject.add(true);
        await Future.delayed(Duration(seconds: 1));
        await ApiModule().login(username, password, _email);
        await SharedPreferencesModule().saveUser(User(username, password));
        return true;
      } catch (e) {
        _simpleAlertDialogMixin.onDialogMessage(Strings.error, e.toString());
      } finally{
        _isLoadingSubject.add(false);
      }
    }
    return false;
  }

  onGoogleButtonPressed() {
    if (_isGoogleLogin) {
      _googleSignIn.signOut();
    } else {
      _googleSignIn.signIn();
    }
  }

}