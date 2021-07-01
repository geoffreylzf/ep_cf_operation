import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/repository/feed_consumption_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class FeedConsumptionBloc extends BlocBase {
  final _locationSubject = BehaviorSubject<Branch>();
  final _itemTypeCodeSubject = BehaviorSubject<ItemTypeCode>();

  Stream<Branch> get locationStream => _locationSubject.stream;

  Stream<ItemTypeCode> get itemTypeCodeStream => _itemTypeCodeSubject.stream;

  @override
  void dispose() {
    _locationSubject.close();
    _itemTypeCodeSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  int _companyId;
  int _locationId;

  FeedConsumptionBloc({
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

  setItemTypeCode(ItemTypeCode itc){
    _itemTypeCodeSubject.add(itc);
  }

  Future<bool> saveFeedConsumption(
      {@required String recordDate, @required int houseNo, @required double weight}) async {
    if (_itemTypeCodeSubject.value == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select feed type");
      return false;
    }

    var cfMortality = CfFeedConsumption.db(
      companyId: _companyId,
      locationId: _locationId,
      recordDate: recordDate,
      houseNo: houseNo,
      itemTypeCode: _itemTypeCodeSubject.value.value,
      weight: weight,
    );

    var res = await FeedConsumptionRepository().saveCfFeedConsumption(cfMortality);

    if (!res) {
      _simpleAlertDialogMixin.onDialogMessage(
          Strings.error, "Data already exists for date and house");
    }

    return res;
  }
}
