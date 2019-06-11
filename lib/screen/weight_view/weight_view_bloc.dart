import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/cf_weight_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_weight_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/model/table/cf_weight_detail.dart';
import 'package:ep_cf_operation/repository/weight_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WeightViewBloc extends BlocBase {
  final _cfWeightSubject = BehaviorSubject<CfWeight>();
  final _cfWeightDetailListSubject = BehaviorSubject<List<CfWeightDetail>>();

  Stream<CfWeight> get cfWeightStream => _cfWeightSubject.stream;

  Stream<List<CfWeightDetail>> get cfWeightDetailListStream => _cfWeightDetailListSubject.stream;

  @override
  void dispose() {
    _cfWeightSubject.close();
    _cfWeightDetailListSubject.close();
  }

  int _cfWeightId;

  WeightViewBloc({@required int cfWeightId}) {
    _cfWeightId = cfWeightId;
    _loadCfWeight();
    _loadCfWeightDetailList();
  }

  _loadCfWeight() async {
    _cfWeightSubject.add(await CfWeightDao().getById(_cfWeightId));
  }

  _loadCfWeightDetailList() async {
    _cfWeightDetailListSubject.add(await CfWeightDetailDao().getListByCfWeightId(_cfWeightId));
  }

  deleteCfWeight() async {
    await WeightRepository().deleteById(_cfWeightId);
    await _loadCfWeight();
  }

  CfWeight getCfWeight(){
    return _cfWeightSubject.value;
  }
}
