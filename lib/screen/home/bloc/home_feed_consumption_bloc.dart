import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/repository/feed_consumption_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeFeedConsumptionBloc extends BlocBase {
  final _curFeedConsumptionListSubject = BehaviorSubject<List<CfFeedConsumption>>();

  Stream<List<CfFeedConsumption>> get curFeedConsumptionListStream =>
      _curFeedConsumptionListSubject.stream;

  @override
  void dispose() {
    _curFeedConsumptionListSubject.close();
  }

  loadCurrentFeedInList() async {
    _curFeedConsumptionListSubject.add(await FeedConsumptionRepository().getTodayList());
  }
}
