import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/model/upload_body.dart';
import 'package:ep_cf_operation/module/api_module.dart';
import 'package:ep_cf_operation/repository/feed_consumption_repository.dart';
import 'package:ep_cf_operation/repository/feed_in_repository.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:ep_cf_operation/repository/weight_repository.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class UploadBloc extends BlocBase {
  final _mortalityCountSubject = BehaviorSubject<int>();
  final _weightCountSubject = BehaviorSubject<int>();
  final _feedInCountSubject = BehaviorSubject<int>();
  final _feedConsumptionCountSubject = BehaviorSubject<int>();
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<int> get mortalityCountStream => _mortalityCountSubject.stream;

  Stream<int> get weightCountStream => _weightCountSubject.stream;

  Stream<int> get feedInCountStream => _feedInCountSubject.stream;

  Stream<int> get feedConsumptionCountStream => _feedConsumptionCountSubject.stream;

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;

  @override
  void dispose() {
    _mortalityCountSubject.close();
    _weightCountSubject.close();
    _feedInCountSubject.close();
    _feedConsumptionCountSubject.close();
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

    final fiList = await FeedInRepository().getNoUpload();
    _feedInCountSubject.add(fiList.length);

    final fcList = await FeedConsumptionRepository().getNoUpload();
    _feedConsumptionCountSubject.add(fcList.length);
  }

  upload() async {
    final totalUploadCount = _mortalityCountSubject.value +
        _weightCountSubject.value +
        _feedInCountSubject.value +
        _feedConsumptionCountSubject.value;

    if (totalUploadCount > 0) {
      try {
        _isLoadingSubject.add(true);
        await Future.delayed(Duration(seconds: 1));
        final cfMortalityList = await MortalityRepository().getNoUpload();
        final cfWeightList = await WeightRepository().getNoUpload();
        final cfFeedInList = await FeedInRepository().getNoUpload();
        final cfFeedConsumptionList = await FeedConsumptionRepository().getNoUpload();

        final uploadBody = UploadBody(
          cfMortalityList: cfMortalityList,
          cfWeightList: cfWeightList,
          cfFeedInList: cfFeedInList,
          cfFeedConsumptionList: cfFeedConsumptionList,
        );

        final response = await ApiModule().upload(uploadBody);

        await MortalityRepository().updateStatusAfterUpload(response.result.cfMortalityPairIdList);
        await WeightRepository().updateStatusAfterUpload(response.result.cfWeightPairIdList);
        await FeedInRepository().updateStatusAfterUpload(response.result.cfFeedInPairIdList);
        await FeedConsumptionRepository().updateStatusAfterUpload(response.result.cfFeedConsumptionPairIdList);
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
