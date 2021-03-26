import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/cf_feed_discharge.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedDischargeBloc extends BlocBase {
  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  int _companyId;
  int _locationId;

  @override
  void dispose() {}

  FeedDischargeBloc({
    @required SimpleAlertDialogMixin mixin,
  }) {
    _simpleAlertDialogMixin = mixin;
    _init();
  }

  _init() async {
    _companyId = await SharedPreferencesModule().getCompanyId();
    _locationId = await SharedPreferencesModule().getLocationId();
  }

  CfFeedDischarge validateEntry(String recordDate, String truckNo) {
    if (recordDate == null || recordDate == "") {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select date");
      return null;
    }

    if (truckNo == null || truckNo == "") {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter truck no");
      return null;
    }

    String dischargeCode = DateFormat("yyyyMMddHHmmss").format(DateTime.now()) +
        _companyId.toString().padLeft(4, "0") +
        _locationId.toString().padLeft(4, "0");

    return CfFeedDischarge(
      companyId: _companyId,
      locationId: _locationId,
      recordDate: recordDate,
      truckNo: truckNo,
      dischargeCode: dischargeCode,
    );
  }
}
