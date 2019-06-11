import 'package:ep_cf_operation/bloc/bloc.dart';
import 'package:ep_cf_operation/db/dao/branch_dao.dart';
import 'package:ep_cf_operation/db/dao/util_dao.dart';
import 'package:ep_cf_operation/model/table/branch.dart';
import 'package:ep_cf_operation/module/shares_preferences_module.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {
  final _locationSubject = BehaviorSubject<Branch>();
  final _pendingUploadCountSubject = BehaviorSubject<int>();

  Stream<Branch> get locationStream => _locationSubject.stream;

  Stream<int> get pendingUploadCountStream => _pendingUploadCountSubject.stream;

  @override
  void dispose() {
    _locationSubject.close();
    _pendingUploadCountSubject.close();
  }

  loadLocation() async {
    var locationId = await SharedPreferencesModule().getLocationId();
    if (locationId != null) {
      _locationSubject.add(await BranchDao().getLocationById(locationId));
    }
  }

  loadPendingUploadCount() async {
    _pendingUploadCountSubject.add(await UtilDao().getPendingUploadCount());
  }
}
