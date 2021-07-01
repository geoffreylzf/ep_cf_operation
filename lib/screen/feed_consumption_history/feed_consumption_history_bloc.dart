import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/repository/feed_consumption_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class FeedConsumptionHistoryBloc extends BlocBase {
  final _cfFeedConsumptionListSubject = BehaviorSubject<List<CfFeedConsumption>>();
  final _filterTextListSubject = BehaviorSubject<List<String>>.seeded([]);

  final _isRefreshableSubject = BehaviorSubject<bool>();
  final _isRefreshLoadingSubject = BehaviorSubject<bool>();
  final _refreshTextSubject = BehaviorSubject<String>();

  Stream<List<CfFeedConsumption>> get cfFeedConsumptionListStream => _cfFeedConsumptionListSubject.stream;

  Stream<List<String>> get filterListStream => _filterTextListSubject.stream;

  Stream<bool> get isRefreshableStream => _isRefreshableSubject.stream;

  Stream<bool> get isRefreshLoadingStream => _isRefreshLoadingSubject.stream;

  Stream<String> get refreshTextStream => _refreshTextSubject.stream;

  @override
  void dispose() {
    _cfFeedConsumptionListSubject.close();
    _filterTextListSubject.close();
    _isRefreshableSubject.close();
    _isRefreshLoadingSubject.close();
    _refreshTextSubject.close();
  }

  int _filterHouseNo;
  String _filterRecordStartDate;
  String _filterRecordEndDate;
  int _refreshBatch = 1;
  BuildContext _context;

  FeedConsumptionHistoryBloc({@required BuildContext context}) {
    _context = context;
    _loadFeedConsumptionList();
  }

  _loadFeedConsumptionList() async {
    _cfFeedConsumptionListSubject.add(await FeedConsumptionRepository().getSearchedList(
      _filterHouseNo,
      _filterRecordStartDate,
      _filterRecordEndDate,
    ));
  }

  filterFeedConsumptionList(
      int houseNo,
      String recordStartDate,
      String recordEndDate,
      ) async {
    _filterHouseNo = houseNo;
    _filterRecordStartDate = recordStartDate;
    _filterRecordEndDate = recordEndDate;

    final arr = <String>[];
    if (_filterHouseNo != null) {
      arr.add("House #$_filterHouseNo");
    }
    if (_filterRecordStartDate != null && _filterRecordStartDate != "") {
      arr.add("Start Date : $_filterRecordStartDate");
    }
    if (_filterRecordEndDate != null && _filterRecordEndDate != "") {
      arr.add("End"
          " Date : $_filterRecordEndDate");
    }
    _filterTextListSubject.add(arr);

    await _loadFeedConsumptionList();
  }

  deleteFeedConsumption(int id) async {
    await FeedConsumptionRepository().deleteById(id);
    await _loadFeedConsumptionList();
  }

  refreshFeedConsumption(bool isFirst) async {
    if (isFirst) {
      _refreshBatch = 1;
    }

    try {
      _isRefreshLoadingSubject.add(true);
      await Future.delayed(Duration(milliseconds: 500));
      await FeedConsumptionRepository().refreshHistory(_refreshBatch).timeout(Duration(seconds: 10));

      //construct load more button text
      final endDate =
      DateTime.now().add(Duration(days: -30 * _refreshBatch)).add(Duration(days: -1));
      final startDate = endDate.add(Duration(days: -29));
      final endDateStr = DateFormat("MMM d, yy").format(endDate);
      final startDateStr = DateFormat("MMM d, yy").format(startDate);
      _refreshTextSubject.add("Load Prev. ($startDateStr ~ $endDateStr)");

      _refreshBatch++;
      _isRefreshableSubject.add(true);

      await _loadFeedConsumptionList();
    } catch (e) {
      Toast.show(e.toString(), _context, duration: 3);
    } finally {
      _isRefreshLoadingSubject.add(false);
    }
  }
}
