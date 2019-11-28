import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MortalityBloc extends BlocBase {
  final _locationSubject = BehaviorSubject<Branch>();

  Stream<Branch> get locationStream => _locationSubject.stream;

  @override
  void dispose() {
    _locationSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  int _companyId;
  int _locationId;

  MortalityBloc({
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

  Future<bool> saveMortality(
      {@required String recordDate,
      @required int houseNo,
      @required int mQty,
      @required int rQty,
      @required String remark}) async {
    var cfMortality = CfMortality.db(
      companyId: _companyId,
      locationId: _locationId,
      recordDate: recordDate,
      houseNo: houseNo,
      mQty: mQty,
      rQty: rQty,
      remark: remark
    );

    var res = await MortalityRepository().saveCfMortality(cfMortality);

    if (!res) {
      _simpleAlertDialogMixin.onDialogMessage(
          Strings.error, "Data already exists for date and house");
    }

    return res;
  }
}
