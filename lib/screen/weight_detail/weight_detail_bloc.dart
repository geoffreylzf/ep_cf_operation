import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/cf_weight_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/db/dao/temp_cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/enum.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';
import 'package:ep_cf_operation/model/table/temp_cf_weight_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:vibration/vibration.dart';

class WeightDetailBloc extends BlocBase {
  final _cfWeightSubject = BehaviorSubject<CfWeight>();
  final _tempListSubject = BehaviorSubject<List<TempCfWeightDetail>>();
  final _genderSubject = BehaviorSubject<Gender>();

  Stream<CfWeight> get cfWeightStream => _cfWeightSubject.stream;

  Stream<List<TempCfWeightDetail>> get tempListStream => _tempListSubject.stream;

  Stream<Gender> get genderStream => _genderSubject.stream;

  @override
  void dispose() {
    _cfWeightSubject.close();
    _tempListSubject.close();
    _genderSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  CfWeight _cfWeight;

  WeightDetailBloc({
    @required SimpleAlertDialogMixin mixin,
    @required CfWeight cfWeight,
  }) {
    _simpleAlertDialogMixin = mixin;
    _cfWeight = cfWeight;
    _cfWeightSubject.add(_cfWeight);
    _loadTempList();
  }

  setGender(Gender gender) {
    _genderSubject.add(gender);
  }

  _loadTempList() async {
    _tempListSubject.add(await TempCfWeightDetailDao().getList());
  }

  Future<bool> insertDetail(int section, int qty, int weight) async {
    if (section == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter section");
      return false;
    }
    if (_genderSubject.value == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select gender");
      return false;
    }
    if (qty == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter quantity");
      return false;
    }
    if (weight == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter weight");
      return false;
    }

    final gender = _genderSubject.value.toString().split(".").last;

    final temp = TempCfWeightDetail(
      section: section,
      gender: gender,
      weight: weight,
      qty: qty,
    );

    await TempCfWeightDetailDao().insert(temp);
    await _loadTempList();

    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate();
    }
    return true;
  }

  deleteDetail(int id) async {
    await TempCfWeightDetailDao().deleteById(id);
    await _loadTempList();
  }

  Future<bool> validate() async {
    final temp = await TempCfWeightDetailDao().getList();
    if (temp.length == 0) {
      _simpleAlertDialogMixin.onDialogMessage(
          Strings.error, "Please enter at least 1 data to save.");
      return false;
    }
    return true;
  }

  Future<void> saveWeight() async {
    final cfWeight = CfWeight.db(
      companyId: _cfWeight.companyId,
      locationId: _cfWeight.locationId,
      houseNo: _cfWeight.houseNo,
      day: _cfWeight.day,
      recordDate: _cfWeight.recordDate,
      recordTime: _cfWeight.recordTime,
    );

    final cfWeightId = await CfWeightDao().insert(cfWeight);
    final tempList = await TempCfWeightDetailDao().getList();
    final detailList = CfWeightDetail.fromTempWithCfWeightId(cfWeightId, tempList);

    await Future.forEach(detailList, (detail) async {
      await CfWeightDetailDao().insert(detail);
    });

    await TempCfWeightDetailDao().removeAll();
  }
}
