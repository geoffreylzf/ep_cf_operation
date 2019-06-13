import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/feed_in_qr.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

class FeedInBloc extends BlocBase {
  final _locationSubject = BehaviorSubject<Branch>();
  final _feedInQrSubject = BehaviorSubject<FeedInQr>();

  Stream<Branch> get locationStream => _locationSubject.stream;

  Stream<FeedInQr> get feedInQrStream => _feedInQrSubject.stream;

  @override
  void dispose() {
    _feedInQrSubject.close();
    _locationSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;
  int _companyId;
  int _locationId;

  FeedInBloc({
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

  Future<FeedInQr> scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      final feedInQr = FeedInQr(barcode);
      _feedInQrSubject.add(feedInQr);
      return feedInQr;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please grant camera permission");
      } else {
        _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Unknown error: $e");
      }
    } on FormatException {
      //User return using back button
    } catch (e) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Unknown error: $e");
    }
    _feedInQrSubject.add(null);
    return null;
  }

  FeedInQr getFeedInQr() {
    return _feedInQrSubject.value;
  }

  CfFeedIn validateEntry(String recordDate, String truckNo) {
    final feedInQr = getFeedInQr();
    if (feedInQr == null) {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please scan document");
      return null;
    }

    if (recordDate == null || recordDate == "") {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please select record date");
      return null;
    }

    if (truckNo == null || truckNo == "") {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "Please enter truck no");
      return null;
    }

    return CfFeedIn(
      companyId: _companyId,
      locationId: _locationId,
      docId: feedInQr.headData.docId,
      docNo: feedInQr.headData.docNo,
      recordDate: recordDate,
      truckNo: truckNo,
    );
  }
}
