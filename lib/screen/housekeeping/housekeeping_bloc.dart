import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/db/dao/feed_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/feed.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HousekeepingBloc extends BlocBase {
  final _branchCountSubject = BehaviorSubject<int>();
  final _feedCountSubject = BehaviorSubject<int>();
  final _isLoadingSubject = BehaviorSubject<bool>();

  Stream<int> get branchCountStream => _branchCountSubject.stream;

  Stream<int> get feedCountStream => _feedCountSubject.stream;

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void dispose() {
    _branchCountSubject.close();
    _feedCountSubject.close();
    _isLoadingSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;

  HousekeepingBloc({@required SimpleAlertDialogMixin mixin}) {
    _simpleAlertDialogMixin = mixin;
    _loadCount();
  }

  _loadCount() async {
    _branchCountSubject.add(await BranchDao().getCount());
    _feedCountSubject.add(await FeedDao().getCount());
  }

  retrieveAll() async {
    try {
      _isLoadingSubject.add(true);
      final branchResponse = await ApiModule().getBranch();
      await BranchDao().deleteAll();
      await Future.forEach<Branch>(branchResponse.result, (ip) async {
        await BranchDao().insert(ip);
      });

      final feedResponse = await ApiModule().getFeed();
      await FeedDao().deleteAll();
      await Future.forEach<Feed>(feedResponse.result, (ip) async {
        await FeedDao().insert(ip);
      });

      await _loadCount();
      _simpleAlertDialogMixin.onDialogMessage(
          Strings.success, "Housekeeping successfully retrieve.");
    } catch (e) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, e.toString());
    } finally {
      _isLoadingSubject.add(false);
    }
  }
}
