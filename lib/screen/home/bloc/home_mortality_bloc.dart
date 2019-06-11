import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/model/table/cf_mortality.dart';
import 'package:ep_cf_operation/repository/mortality_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeMortalityBloc extends BlocBase {
  final _curMortalityListSubject = BehaviorSubject<List<CfMortality>>();

  Stream<List<CfMortality>> get curMortalityListStream => _curMortalityListSubject.stream;

  @override
  void dispose() {
    _curMortalityListSubject.close();
  }

  loadCurrentMortalityList() async {
    _curMortalityListSubject.add(await MortalityRepository().getTodayList());
  }
}
