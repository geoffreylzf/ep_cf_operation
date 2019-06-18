import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/cf_feed_in_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/repository/feed_in_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class FeedInViewBloc extends BlocBase {
  final _cfFeedInSubject = BehaviorSubject<CfFeedIn>();
  final _cfFeedInDetailListSubject = BehaviorSubject<List<CfFeedInDetailWithInfo>>();

  Stream<CfFeedIn> get cfFeedInStream => _cfFeedInSubject.stream;

  Stream<List<CfFeedInDetailWithInfo>> get cfFeedInDetailListStream => _cfFeedInDetailListSubject.stream;

  @override
  void dispose() {
    _cfFeedInSubject.close();
    _cfFeedInDetailListSubject.close();
  }

  int _cfFeedInId;

  FeedInViewBloc({@required int cfFeedInId}) {
    _cfFeedInId = cfFeedInId;
    _loadCfFeedIn();
    _loadCfFeedInDetailList();
  }

  _loadCfFeedIn() async {
    _cfFeedInSubject.add(await CfFeedInDao().getById(_cfFeedInId));
  }

  _loadCfFeedInDetailList() async {
    _cfFeedInDetailListSubject.add(await CfFeedInDetailDao().getListByCfFeedInId(_cfFeedInId));
  }

  deleteCfFeedIn() async {
    await FeedInRepository().deleteById(_cfFeedInId);
    await _loadCfFeedIn();
  }

  CfFeedIn getCfFeedIn() {
    return _cfFeedInSubject.value;
  }
}
