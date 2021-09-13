import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_feed_consumption.dart';
import 'package:ep_cf_operation/model/table/cf_feed_in.dart';
import 'package:ep_cf_operation/repository/feed_consumption_repository.dart';
import 'package:ep_cf_operation/repository/feed_in_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeFeedInBloc extends BlocBase {
  final _curFeedInListSubject = BehaviorSubject<List<CfFeedIn>>();

  Stream<List<CfFeedIn>> get curFeedInListStream => _curFeedInListSubject.stream;


  @override
  void dispose() {
    _curFeedInListSubject.close();
  }

  loadCurrentFeedInList() async {
    _curFeedInListSubject.add(await FeedInRepository().getTodayList());
  }
}
