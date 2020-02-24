import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/cf_feed_in_dao.dart';
import 'package:ep_cf_operation/db/dao/cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/db/dao/temp_cf_feed_in_detail_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/feed_in_qr.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in_detail.dart';
import 'package:ep_cf_operation/model/table/temp_cf_feed_in_detail.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/feed_in_detail/feed_in_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';

class FeedInDetailBloc extends BlocBase {
  //For detail entry
  final _feedItemListSubject = BehaviorSubject<List<FeedData>>();
  final _compartmentListSubject = BehaviorSubject<List<CompartmentData>>();
  final _selectedFeedSubject = BehaviorSubject<FeedData>();
  final _selectedCompartmentSubject = BehaviorSubject<CompartmentData>();
  final _qtySubject = BehaviorSubject<double>();
  final _weightSubject = BehaviorSubject<double>();

  //For summary
  final _tempListSubject = BehaviorSubject<List<TempCfFeedInDetailWithInfo>>();
  final _cfFeedInSubject = BehaviorSubject<CfFeedIn>();

  Stream<List<FeedData>> get feedItemStream => _feedItemListSubject.stream;

  Stream<List<CompartmentData>> get compartmentListStream => _compartmentListSubject.stream;

  Stream<FeedData> get selectedFeedIDataStream => _selectedFeedSubject.stream;

  Stream<CompartmentData> get selectedCompartmentStream => _selectedCompartmentSubject.stream;

  Stream<double> get qtyStream => _qtySubject.stream;

  Stream<double> get weightStream => _weightSubject.stream;

  Stream<List<TempCfFeedInDetailWithInfo>> get tempListStream => _tempListSubject.stream;

  Stream<CfFeedIn> get cfFeedInStream => _cfFeedInSubject.stream;

  @override
  void dispose() {
    _feedItemListSubject.close();
    _compartmentListSubject.close();
    _selectedFeedSubject.close();
    _selectedCompartmentSubject.close();
    _qtySubject.close();
    _weightSubject.close();

    _tempListSubject.close();
    _cfFeedInSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  FeedInDetailDelegate _delegate;
  CfFeedIn _cfFeedIn;
  FeedInQr _feedInQr;

  FeedInDetailBloc({
    @required SimpleAlertDialogMixin simpleAlertDialogMixin,
    @required FeedInDetailDelegate delegate,
    @required CfFeedIn cfFeedIn,
    @required FeedInQr feedInQr,
  }) {
    this._simpleAlertDialogMixin = simpleAlertDialogMixin;
    this._delegate = delegate;
    this._cfFeedIn = cfFeedIn;
    this._feedInQr = feedInQr;

    _init();
  }

  Future<void> _init() async {
    await TempCfFeedInDetailDao().removeAll();
    _feedItemListSubject.add(_feedInQr.feedDataList);
    _cfFeedInSubject.add(_cfFeedIn);
    await _loadTempList();
    await clearSelected();
  }

  _loadTempList() async {
    final tempList = await TempCfFeedInDetailDao().getList();
    _tempListSubject.add(tempList);
  }

  deleteDetail(int id) async {
    await TempCfFeedInDetailDao().deleteById(id);
    await _loadTempList();
    await clearSelected();
  }

  setFeedItem(FeedData feedData) {
    _selectedFeedSubject.add(feedData);

    if (feedData != null) {
      _compartmentListSubject.add(feedData.compartmentDataList);
      _selectedCompartmentSubject.add(null);

      if (feedData.compartmentDataList.length != 0) {
        _qtySubject.add(null);
        _weightSubject.add(null);
      } else {
        _qtySubject.add(feedData.remaining);
        _weightSubject.add(feedData.remaining);
      }
    }
  }

  setCompartment(CompartmentData compartment) {
    _selectedCompartmentSubject.add(compartment);
    if (compartment != null) {
      _qtySubject.add(compartment.remaining);
      _weightSubject.add(compartment.remaining);
    }
  }

  FeedData getSelectedFeedData() {
    return _selectedFeedSubject.value;
  }

  CompartmentData getSelectedCompartmentData() {
    return _selectedCompartmentSubject.value;
  }

  setQty(double qty) {
    if (qty == null) {
      _weightSubject.add(0);
      return;
    }
    final factor = getSelectedFeedData()?.stdWeight ?? 1000;
    final weight = qty * factor;
    _weightSubject.add(weight);
  }

  Future<bool> insertDetail(int houseNo, double qty) async {
    final feedData = getSelectedFeedData();
    final compartmentData = getSelectedCompartmentData();
    final weight = _weightSubject.value;

    var compartmentNo;
    if (feedData == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select feed");
      return false;
    }

    if (feedData.compartmentDataList.length != 0 && compartmentData == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select compartment");
      return false;
    }

    if (houseNo == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter house no");
      return false;
    }

    if (qty == null || qty == 0.0) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter quantity");
      return false;
    }

    if (compartmentData != null) {
      compartmentNo = compartmentData.compartmentNo;
    }

    final temp = TempCfFeedInDetail(
      docDetailId: feedData.docDetailId,
      houseNo: houseNo,
      itemPackingId: feedData.itemPackingId,
      compartmentNo: compartmentNo,
      qty: qty,
      weight: weight,
    );

    await TempCfFeedInDetailDao().insert(temp);
    await _loadTempList();

    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate();
    }
    _delegate.switchTab(1); //switch the tab to summary
    await clearSelected();
    return true;
  }

  Future<void> clearSelected() async {
    _qtySubject.add(null); //set qty to empty
    setCompartment(null); //set selected compartment to null
    setFeedItem(null); //set selected feed to null
    _compartmentListSubject.add(null); //clear compartment list
    await _feedInQr.loadRemaining();
    _feedItemListSubject.add(_feedInQr.feedDataList);
  }

  Future<bool> validate() async {
    final temp = await TempCfFeedInDetailDao().getList();
    if (temp.length == 0) {
      _simpleAlertDialogMixin.onDialogMessage(
          Strings.error, "Please enter at least 1 data to save.");
      return false;
    }
    return true;
  }

  Future<void> saveFeedIn() async {
    await _feedInQr.loadRemaining();

    final variance = _feedInQr.feedDataList
        .map((feed) => feed.remaining * feed.stdWeight) //get remaining weight in kg of each feed
        .reduce((curr, next) => curr + next); //sum total

    final cfFeedIn = CfFeedIn.db(
      companyId: _cfFeedIn.companyId,
      locationId: _cfFeedIn.locationId,
      docId: _cfFeedIn.docId,
      docNo: _cfFeedIn.docNo,
      recordDate: _cfFeedIn.recordDate,
      truckNo: _cfFeedIn.truckNo,
      variance: variance,
    );

    final cfFeedInId = await CfFeedInDao().insert(cfFeedIn);
    final tempList = await TempCfFeedInDetailDao().getList();
    final detailList = CfFeedInDetail.fromTempWithCfFeedInId(cfFeedInId, tempList);

    await Future.forEach(detailList, (detail) async {
      await CfFeedInDetailDao().insert(detail);
    });

    await TempCfFeedInDetailDao().removeAll();
  }
}
