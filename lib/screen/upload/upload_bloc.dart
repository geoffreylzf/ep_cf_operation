import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/upload_body.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:ep_cf_operation/repository/weight_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UploadBloc extends BlocBase {
  final _mortalityCountSubject = BehaviorSubject<int>();
  final _weightCountSubject = BehaviorSubject<int>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<int> get mortalityCountStream => _mortalityCountSubject.stream;

  Stream<int> get weightCountStream => _weightCountSubject.stream;

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void dispose() {
    _mortalityCountSubject.close();
    _weightCountSubject.close();
    _isLoadingSubject.close();
  }

  SimpleAlertDialogMixin _simpleAlertDialogMixin;

  UploadBloc({@required SimpleAlertDialogMixin mixin}) {
    _simpleAlertDialogMixin = mixin;
    loadPendingUploadCount();
  }

  loadPendingUploadCount() async {
    final mList = await MortalityRepository().getNoUpload();
    _mortalityCountSubject.add(mList.length);

    final wList = await WeightRepository().getNoUpload();
    _weightCountSubject.add(wList.length);
  }

  upload() async {
    final totalUploadCount = _mortalityCountSubject.value + _weightCountSubject.value;

    if (totalUploadCount > 0) {
      try {
        _isLoadingSubject.add(true);
        await Future.delayed(Duration(seconds: 1));
        final cfMortalityList = await MortalityRepository().getNoUpload();
        final cfWeightList = await WeightRepository().getNoUpload();
        final uploadBody = UploadBody(
          cfMortalityList: cfMortalityList,
          cfWeightList: cfWeightList,
        );

        final response = await ApiModule().upload(uploadBody);

        await MortalityRepository().updateStatusAfterUpload(response.result.cfMortalityPairIdList);
        await WeightRepository().updateStatusAfterUpload(response.result.cfWeightPairIdList);
        await loadPendingUploadCount();
      } catch (e) {
        _simpleAlertDialogMixin.onDialogMessage(Strings.error, e.toString());
      } finally {
        _isLoadingSubject.add(false);
      }
    } else {
      _simpleAlertDialogMixin.onDialogMessage(Strings.error, "No data to upload.");
    }
  }

  bool getIsLoading() {
    return _isLoadingSubject.value;
  }
}
