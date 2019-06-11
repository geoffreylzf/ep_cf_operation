import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc extends BlocBase {
  final _locListSubject = BehaviorSubject<List<Branch>>();

  Stream<List<Branch>> get locListStream => _locListSubject.stream;

  @override
  void dispose() {
    _locListSubject.close();
  }

  int _companyId;

  LocationBloc({@required int companyId}) {
    _companyId = companyId;
    _loadCoyList();
  }

  _loadCoyList() async {
    _locListSubject.add(await BranchDao().getLocationListByCompanyId(_companyId));
  }

  saveLocation(int locationId) async {
    await SharedPreferencesModule().saveCompanyId(_companyId);
    await SharedPreferencesModule().saveLocationId(locationId);
  }
}
