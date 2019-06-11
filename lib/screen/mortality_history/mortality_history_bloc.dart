import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class MortalityHistoryBloc extends BlocBase {
  final _mortalityListSubject = BehaviorSubject<List<CfMortality>>();
  final _filterTextListSubject = BehaviorSubject<List<String>>.seeded([]);

  final _isRefreshableSubject = BehaviorSubject<bool>();
  final _isRefreshLoadingSubject = BehaviorSubject<bool>();
  final _refreshTextSubject = BehaviorSubject<String>();

  Stream<List<CfMortality>> get cfMortalityListStream => _mortalityListSubject.stream;

  Stream<List<String>> get filterListStream => _filterTextListSubject.stream;

  Stream<bool> get isRefreshableStream => _isRefreshableSubject.stream;

  Stream<bool> get isRefreshLoadingStream => _isRefreshLoadingSubject.stream;

  Stream<String> get refreshTextStream => _refreshTextSubject.stream;

  @override
  void dispose() {
    _mortalityListSubject.close();
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

  MortalityHistoryBloc({@required BuildContext context}) {
    _context = context;
    _loadMortalityList();
  }

  filterMortalityList(
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

    await _loadMortalityList();
  }

  _loadMortalityList() async {
    _mortalityListSubject.add(await MortalityRepository().getSearchedList(
      _filterHouseNo,
      _filterRecordStartDate,
      _filterRecordEndDate,
    ));
  }

  deleteMortality(int id) async {
    await MortalityRepository().deleteById(id);
    await _loadMortalityList();
  }

  refreshMortality(bool isFirst) async {
    if (isFirst) {
      _refreshBatch = 1;
    }

    try {
      _isRefreshLoadingSubject.add(true);
      await Future.delayed(Duration(milliseconds: 500));
      await MortalityRepository().refreshHistory(_refreshBatch).timeout(Duration(seconds: 10));

      //construct load more button text
      final endDate =
          DateTime.now().add(Duration(days: -30 * _refreshBatch)).add(Duration(days: -1));
      final startDate = endDate.add(Duration(days: -29));
      final endDateStr = DateFormat("MMM d, yy").format(endDate);
      final startDateStr = DateFormat("MMM d, yy").format(startDate);
      _refreshTextSubject.add("Load Prev. ($startDateStr ~ $endDateStr)");

      _refreshBatch++;
      _isRefreshableSubject.add(true);

      await _loadMortalityList();
    } catch (e) {
      Toast.show(e.toString(), _context, duration: 3);
    } finally {
      _isRefreshLoadingSubject.add(false);
    }
  }
}
