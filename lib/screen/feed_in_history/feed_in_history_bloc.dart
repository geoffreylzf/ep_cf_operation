import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/repository/feed_in_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class FeedInHistoryBloc extends BlocBase {
  final _feedInListSubject = BehaviorSubject<List<CfFeedIn>>();
  final _filterTextListSubject = BehaviorSubject<List<String>>.seeded([]);

  final _isRefreshableSubject = BehaviorSubject<bool>();
  final _isRefreshLoadingSubject = BehaviorSubject<bool>();
  final _refreshTextSubject = BehaviorSubject<String>();

  Stream<List<CfFeedIn>> get cfFeedInListStream => _feedInListSubject.stream;

  Stream<List<String>> get filterListStream => _filterTextListSubject.stream;

  Stream<bool> get isRefreshableStream => _isRefreshableSubject.stream;

  Stream<bool> get isRefreshLoadingStream => _isRefreshLoadingSubject.stream;

  Stream<String> get refreshTextStream => _refreshTextSubject.stream;

  @override
  void dispose() {
    _feedInListSubject.close();
    _filterTextListSubject.close();
    _isRefreshableSubject.close();
    _isRefreshLoadingSubject.close();
    _refreshTextSubject.close();
  }

  String _filterRecordStartDate;
  String _filterRecordEndDate;
  String _filterDocNo;
  String _filterTruckNo;
  int _refreshBatch = 1;
  BuildContext _context;

  FeedInHistoryBloc({@required BuildContext context}) {
    _context = context;
    loadFeedInList();
  }

  filterWeightList(
    String recordStartDate,
    String recordEndDate,
    String docNo,
    String truckNo,
  ) async {
    _filterRecordStartDate = recordStartDate;
    _filterRecordEndDate = recordEndDate;
    _filterDocNo = docNo;
    _filterTruckNo = truckNo;

    final arr = <String>[];
    if (_filterRecordStartDate != null && _filterRecordStartDate != "") {
      arr.add("Start Date : $_filterRecordStartDate");
    }
    if (_filterRecordEndDate != null && _filterRecordEndDate != "") {
      arr.add("End"
          " Date : $_filterRecordEndDate");
    }
    if (_filterDocNo != null && _filterDocNo != "") {
      arr.add("Doc No : #$_filterDocNo");
    }
    if (_filterTruckNo != null && _filterTruckNo != "") {
      arr.add("Truck : $_filterTruckNo");
    }

    _filterTextListSubject.add(arr);

    await loadFeedInList();
  }

  loadFeedInList() async {
    _feedInListSubject.add(await FeedInRepository().getSearchedList(
      _filterRecordStartDate,
      _filterRecordEndDate,
      _filterDocNo,
      _filterTruckNo,
    ));
  }

  deleteWeight(int id) async {
    await FeedInRepository().deleteById(id);
    await loadFeedInList();
  }

  refreshFeedIn(bool isFirst) async {
    if (isFirst) {
      _refreshBatch = 1;
    }

    try {
      _isRefreshLoadingSubject.add(true);
      await Future.delayed(Duration(milliseconds: 500));
      await FeedInRepository().refreshHistory(_refreshBatch).timeout(Duration(seconds: 10));

      //construct load more button text
      final endDate =
      DateTime.now().add(Duration(days: -30 * _refreshBatch)).add(Duration(days: -1));
      final startDate = endDate.add(Duration(days: -29));
      final endDateStr = DateFormat("MMM d, yy").format(endDate);
      final startDateStr = DateFormat("MMM d, yy").format(startDate);
      _refreshTextSubject.add("Load Prev. ($startDateStr ~ $endDateStr)");

      _refreshBatch++;
      _isRefreshableSubject.add(true);

      await loadFeedInList();
    } catch (e) {
      Toast.show(e.toString(), _context, duration: 3);
    } finally {
      _isRefreshLoadingSubject.add(false);
    }
  }
}
