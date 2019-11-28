import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/user.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc extends BlocBase{

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void dispose() {
    _isLoadingSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;

  LoginBloc({@required SimpleAlertDialogMixin mixin}) {
    _simpleAlertDialogMixin = mixin;
  }

  Future<bool> login(String username, String password) async {
    try {
      _isLoadingSubject.add(true);
      await Future.delayed(Duration(seconds: 1));
      await ApiModule().login(username, password);
      await SharedPreferencesModule().saveUser(User(username, password));
      return true;
    } catch (e) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, e.toString());
    } finally{
      _isLoadingSubject.add(false);
    }
    return false;
  }
}