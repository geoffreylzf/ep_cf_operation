import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_weight.dart';
import 'package:ep_cf_operation/repository/weight_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeWeightBloc extends BlocBase {
  final _curWeightListSubject = BehaviorSubject<List<CfWeight>>();

  Stream<List<CfWeight>> get curWeightListStream => _curWeightListSubject.stream;

  @override
  void dispose() {
    _curWeightListSubject.close();
  }

  loadCurrentMortalityList() async {
    _curWeightListSubject.add(await WeightRepository().getTodayList());
  }
}
