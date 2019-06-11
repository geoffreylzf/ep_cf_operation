import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:rxdart/rxdart.dart';

class CompanyBloc extends BlocBase {
  final _coyListSubject = BehaviorSubject<List<Branch>>();

  Stream<List<Branch>> get coyListStream => _coyListSubject.stream;

  @override
  void dispose() {
    _coyListSubject.close();
  }

  CompanyBloc() {
    _loadCoyList();
  }

  _loadCoyList() async {
    _coyListSubject.add(await BranchDao().getCompanyList());
  }
}
