import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/util/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WeightBloc extends BlocBase {
  final _locationSubject = BehaviorSubject<Branch>();

  Stream<Branch> get locationStream => _locationSubject.stream;

  @override
  void dispose() {
    _locationSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  int _companyId;
  int _locationId;

  WeightBloc({
    @required SimpleAlertDialogMixin mixin,
  }) {
    _simpleAlertDialogMixin = mixin;
    _init();
  }

  _init() async {
    _companyId = await SharedPreferencesModule().getCompanyId();
    _locationId = await SharedPreferencesModule().getLocationId();
    await _loadLocation();
  }

  _loadLocation() async {
    _locationSubject.add(await BranchDao().getLocationById(_locationId));
  }

  CfWeight validateEntry(String recordDate, int houseNo, int day) {

    if (recordDate == null || recordDate == "") {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select date");
      return null;
    }

    if (houseNo == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter house no");
      return null;
    }

    if (day == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter day");
      return null;
    }

    return CfWeight(
      companyId: _companyId,
      locationId: _locationId,
      recordDate: recordDate,
      houseNo: houseNo,
      day: day,
      recordTime: DateTimeUtil().getCurrentTime(),
    );
  }
}
