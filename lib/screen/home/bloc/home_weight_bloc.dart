import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/weighing_schedule_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/weighing_schedule.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/repository/weight_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeWeightBloc extends BlocBase {
  final _curWeightListSubject = BehaviorSubject<List<CfWeight>>();

  final _weighingScheduleListSubject = BehaviorSubject<List<WeighingSchedule>>();

  final _scheduleMsgSubject = BehaviorSubject<String>();

  Stream<List<CfWeight>> get curWeightListStream => _curWeightListSubject.stream;

  Stream<List<WeighingSchedule>> get weighingScheduleStream => _weighingScheduleListSubject.stream;

  Stream<String> get scheduleMsgStream => _scheduleMsgSubject.stream;

  @override
  void dispose() {
    _curWeightListSubject.close();
    _weighingScheduleListSubject.close();
    _scheduleMsgSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;

  HomeWeightBloc({@required SimpleAlertDialogMixin mixin}) {
    _simpleAlertDialogMixin = mixin;
  }

  init() async {
    await _loadCurrentMortalityList();
    await getWeighingSchedule();
    await retrieveWeighingSchedule();
  }

  _loadCurrentMortalityList()async{
    _curWeightListSubject.add(await WeightRepository().getTodayList());
  }

  retrieveWeighingSchedule() async {
    final locationId = await SharedPreferencesModule().getLocationId();
    try {
      if (locationId != null) {
        _scheduleMsgSubject.add("Getting newest schedule...");
        await Future.delayed(Duration(seconds: 1));
        final scheduleResponse = await ApiModule().getWeighingSchedule(locationId);
        await WeighingScheduleDao().deleteByLocationId(locationId);
        await Future.forEach<WeighingSchedule>(scheduleResponse.result, (ip) async {
          await WeighingScheduleDao().insert(ip);
        });
        _scheduleMsgSubject.add("Newest schedule is retrieved...");
        await getWeighingSchedule();
      }
    } catch (e) {
      _scheduleMsgSubject.add("Error getting newest schedule,\nshow last retreived data");
    }
  }

  getWeighingSchedule() async {
    final locationId = await SharedPreferencesModule().getLocationId();
    if (locationId != null) {
      _weighingScheduleListSubject.add(await WeighingScheduleDao().getByLocationId(locationId));
    }
  }
}
